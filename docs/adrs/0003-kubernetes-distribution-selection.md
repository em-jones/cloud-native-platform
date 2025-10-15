---
title: Adopt a Kubernetes Distribution for Secure Self-Managed AWS Deployment
status: Accepted
date: 2025-10-14
---

## 1. Context

For the "OpenDev" platform, a "container workload orchestration tool" must exist
to:

- Deploying custom software components
- Deploying third-party services (for example databases, monitoring, CI/CD)

The "OpenDev" platform selected Kubernetes as the orchestration platform due to
its wide adoption, ecosystem, and flexibility.
While evaluating the deployment options, "ODP" must choose a Kubernetes
distribution that aligns with the priorities:

- Simplicity
- Security
- Compatibility with third-party tools (for example `ArgoCD`, `Prometheus`,
  `AWS/Azure IAM`, `CSI` drivers)

The cluster will support up to 300 pods across heterogeneous (`x86`, `ARM`, `GPU`)
node types.
In the spirit of simplicity, this architecture chose Kine to replace `etcd` with a `Postgres` or `SQLite`
back-end data store (the latter via `Litestream`).

This ADR evaluates the most appropriate Kubernetes distributions for the `ODP`
use case: **RKE2**, **K3s**, and **Talos Linux**, considering their:

- Simplicity and maintainability
- Security and compliance posture
- Ecosystem/tooling compatibility
- Disaster recovery and HA support

## 2. Considered options

### 2.1 `RKE2`

**Rancher Kubernetes Engine 2** (RKE2) is a hardened Kubernetes distribution
built for production workloads, supporting embedded `etcd, CIS benchmark defaults, and FIPS 140-2 validation. It closely follows upstream Kubernetes and integrates well with Rancher.

#### Pros

- Built-in CIS hardening and FIPS readiness
- Strong community and Rancher/SUSE commercial support
- Compatible with all AWS components and IaC tools
- Embedded etcd with automatic snapshotting
- Upstream-conformant API

#### Cons

- Slightly more operational complexity than K3s
- No native support for external SQL stores via Kine (etcd-only)

### 2.2 K3s

K3s is a lightweight Kubernetes distribution for edge and development environments. It supports embedded SQLite or external Postgres/MySQL via Kine. It’s ideal for small clusters with minimal setup overhead.

#### Pros

- Very fast and simple setup (single binary)
- Native support for Kine + Postgres or SQLite
- Minimal resource footprint, great for ARM and GPU edge workloads
- Built-in components (Traefik, Flannel, etc.)

#### Cons

- Not hardened for production security out-of-the-box
- Lacks formal compliance (CIS, FIPS, STIG)
- Requires more effort to secure for production
- Less upstream fidelity than RKE2

### 2.3 Talos Linux

**Talos** is a Linux distribution designed _only_ to run Kubernetes and nothing else. It removes SSH access, uses an immutable OS, and is API-driven. Talos integrates tightly with kubelet and simplifies lifecycle operations (install, upgrade, recover).

#### Pros

- Highest security profile: immutable, minimal surface area, rootless
- GitOps native and API-managed (no SSH)
- FIPS-compliant builds available
- Compatible with Kine + Postgres (via etcd-less setup)
- Strong disaster recovery tools (automated backups, etc.)
- Excellent support for multi-arch, GPU, ARM64

#### Cons

- Higher learning curve (API-driven workflows differ from traditional ops)
- Smaller ecosystem/community vs. RKE2
- Requires Talos CLI and new CI/CD patterns
- No package manager or shell access
- Some integrations (e.g. AWS ALB controller) require careful RBAC and bootstrap

## 3. Comparative Summary

| Feature                           | RKE2                         | K3s                                   | Talos Linux                                       |
| --------------------------------- | ---------------------------- | ------------------------------------- | ------------------------------------------------- |
| **Security**                      | CIS + FIPS hardened          | Minimal defaults, insecure by default | Immutable OS, rootless, FIPS-capable              |
| **HA Support**                    | Yes (etcd)                   | Yes (etcd or external DB via Kine)    | Yes (etcd or Kine + Postgres)                     |
| **Kine Support**                  | ❌ Not officially supported  | ✅ Native (SQLite, Postgres)          | ✅ Supported via static pods                      |
| **Disaster Recovery**             | Built-in etcd snapshots      | etcd or external DB backup            | Built-in backup tooling (etcd + secrets)          |
| **ARM & GPU Support**             | ✅                           | ✅                                    | ✅                                                |
| **AWS Integration (IAM/CSI/ALB)** | ✅ Full support              | ✅ With extra configuration           | ✅ Supported via bootstrap scripts                |
| **Observability Integration**     | ✅ Full Prom/Grafana support | ✅ Community Helm charts              | ✅ Native + sidecar integrations                  |
| **Ease of Use**                   | Simple, kubeadm-style        | Easiest (single binary)               | Advanced (Talos API)                              |
| **GitOps Ready**                  | Optional                     | Optional                              | ✅ Native Flux, ArgoCD supported                  |
| **Community/Support**             | Strong + Rancher Enterprise  | Strong, large community               | Growing, active Slack, commercial via Sidero Labs |

## 4. Decision

We will **adopt Talos Linux** for our Kubernetes control plane due to its unmatched security posture, compatibility with Kine/Postgres, and ability to run across our diverse AWS infrastructure. Its immutable design and API-only architecture reduce operational surface area and offer reproducibility across environments.

While RKE2 offers stronger third-party support and easier transition for traditional ops teams, Talos better aligns with our **long-term goals of automation, declarative infrastructure, and minimal attack surface**.

## 5. Consequences

- We must train our team in the Talos operating model (Talosctl, machine configs, no SSH).
- Cluster provisioning and disaster recovery will be declarative and automated via Talos APIs and GitOps.
- All integrations (Prometheus, Grafana, ArgoCD, CSI, ALB controller) must be installed via Helm or manifests after Talos bootstraps Kubernetes.
- We’ll use Postgres with Kine for etcd-less control planes, replicating database snapshots via Litestream.
- We accept the smaller ecosystem in exchange for a secure, streamlined foundation for long-term maintainability.

## 6. References

- <https://www.talos.dev>
- <https://docs.rke2.io>
- <https://docs.k3s.io>
- <https://github.com/k3s-io/kine>
- <https://www.siderolabs.com/talos>
- <https://github.com/talos-systems/talos/blob/main/website/content/docs/v1.6/guides/kubernetes/kine.md>
