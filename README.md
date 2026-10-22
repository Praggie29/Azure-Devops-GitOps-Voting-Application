# 🚀 End-to-End GitOps CI/CD Platform on Azure Kubernetes Service (AKS)

A cloud-native microservices architecture deploying a multi-tier voting application using **Azure DevOps for Continuous Integration (CI)** and **Argo CD for GitOps-based Continuous Delivery (CD)** on **Azure Kubernetes Service (AKS)**.

---

## 🛠️ Architecture & Tech Stack

- **Cloud Platform:** Microsoft Azure (Resource Groups, AKS, VMSS, ACR, Azure Repos)
- **CI Orchestration:** Azure DevOps (3 Dedicated Multi-stage YAML Pipelines)
- **Self-Hosted Runner:** Custom Azure DevOps Agent Pool on Azure VM / VMSS
- **Continuous Delivery:** Argo CD (GitOps, Declarative Sync, Drift Detection)
- **Container Registry:** Azure Container Registry (ACR)
- **Container Orchestration:** Azure Kubernetes Service (AKS) with VMSS node pool
- **Application Services:**
  - `vote`: Python web application frontend
  - `result`: Node.js web application for real-time results
  - `worker`: .NET / Java background worker processing votes
  - `redis`: In-memory data store queue
  - `db`: PostgreSQL database

---

## 🔄 CI/CD Workflow Overview

1. **Code Commit:** Developers push updates to `Azure Repos`.
2. **Independent CI Pipelines (Azure DevOps):**
   - `azure-pipelines-vote.yml` triggers on `/vote` directory changes.
   - `azure-pipelines-result.yml` triggers on `/result` directory changes.
   - `azure-pipelines-worker.yml` triggers on `/worker` directory changes.
3. **Build & Package:** Jobs execute on a **Self-Hosted VMSS Agent Pool**, building Docker images and publishing versioned tags to **Azure Container Registry (ACR)**.
4. **Manifest Update:** Deployment scripts update Kubernetes YAML manifests with the latest image tags.
5. **GitOps CD (Argo CD):** 
   - Argo CD running in AKS monitors Azure Repos via scoped Personal Access Token (PAT).
   - Automatically synchronizes cluster state with Git commits (zero-downtime, self-healing).

---

## 📂 Project Structure

```text
├── .azure-pipelines/       # 3 Multi-stage Azure DevOps CI Pipelines
├── k8s-specifications/     # Kubernetes deployments, services, and ingress
├── scripts/                # Automated manifest update scripts
├── vote/                   # Python frontend microservice
├── result/                 # Node.js frontend microservice
└── worker/                 # Worker processing service
