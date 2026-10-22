#!/bin/bash

set -e
set -x

# Arguments:
# $1: Service name (e.g., vote, result, worker)
# $2: Image repository name (e.g., vote, result, worker)
# $3: Image tag / Build ID

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <service-name> <image-name> <image-tag>"
    exit 1
fi

SERVICE_NAME=$1
IMAGE_NAME=$2
IMAGE_TAG=$3

# Use an environment variable for the PAT (fallback to placeholder if not set)
AZURE_PAT="${AZURE_DEVOPS_PAT:-<AZURE_PERSONAL_ACCESS_TOKEN>}"
REPO_URL="https://${AZURE_PAT}@dev.azure.com/23P31A04D6/voting-application/_git/voting-application"

# Temporary directory for repository clone
TEMP_DIR=$(mktemp -d /tmp/gitops-sync-XXXXXX)

# Clone the git repository
git clone "$REPO_URL" "$TEMP_DIR"

# Navigate into the cloned directory
cd "$TEMP_DIR"

# Configure Git committer identity for automated pipeline commits
git config user.name "Azure DevOps Pipeline"
git config user.email "azure-devops-ci@noreply.azure.com"

# Update the Kubernetes manifest file with the new container image tag
sed -i "s|image:.*|image: pragnyaaurecicd/${IMAGE_NAME}:${IMAGE_TAG}|g" "k8s-specifications/${SERVICE_NAME}-deployment.yaml"

# Stage, commit and push the updated manifest
git add "k8s-specifications/${SERVICE_NAME}-deployment.yaml"
git commit -m "chore(ci): update ${SERVICE_NAME} deployment image to tag ${IMAGE_TAG} [skip ci]"
git push

# Cleanup: remove temporary directory
rm -rf "$TEMP_DIR"

echo "Successfully updated manifest for ${SERVICE_NAME} to tag ${IMAGE_TAG}!"
