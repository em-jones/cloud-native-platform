# 🌐 OpenDev Platform

**OpenDev Platform** is an open-source, cloud-native software development platform designed to streamline the entire application lifecycle — from source to production — using modern DevOps, GitOps, and Platform Engineering principles.

It empowers developers and operators to collaborate effectively by providing an integrated environment for:
- Source control
- Continuous Integration & Delivery (CI/CD)
- Infrastructure as Code (IaC)
- Observability
- Documentation & discovery

---

## 🚀 Features

- **Unified Developer Experience** — Bring your code, pipelines, and environments together under one consistent interface.  
- **GitOps by Default** — Declarative configuration and environment automation via GitOps workflows.  
- **Extensible Service Catalog** — Register and manage all services, APIs, and infrastructure components.  
- **Built-in TechDocs** — Markdown-based documentation that stays versioned alongside code.  
- **Pluggable Architecture** — Extend functionality through modular integrations (e.g., GitHub, GitLab, Azure DevOps, AWS, GCP).  
- **Observability Integrations** — Native support for OpenTelemetry, Prometheus, and Grafana.  
- **Secure Multi-Tenant Design** — RBAC and SSO support using OAuth2/OpenID Connect.  

---

## 🎯 Goals
### Open-source and Community-driven
- Foster a vibrant community of contributors and users to continuously enhance the platform.
- Leverage open standards, open source tools, and best practices to ensure interoperability and avoid vendor lock-in.

### Sustainability
- Build a maintainable and scalable platform that can evolve with changing technology landscapes and organizational needs.
- Prioritize documentation, testing, and automation to reduce operational overhead.
- Leverage cloud-native technologies to optimize resource usage and cost.

### Spec-driven Development
- Maintenance of the platform should leverage agent-based spec-driven development tooling

---

## 🧩 Architecture Overview
<!-- Placeholder for architecture diagram -->


---

## 🛠️ Getting Started

### Prerequisites

- **Devbox** for local development environment
- **Docker** ≥ 24

### Installation

```bash
# Clone the repository
git clone https://github.com/em-jones/cloud-native-platform.git
cd cloud-native-platform

# Install dependencies
curl -fsSL https://get.jetify.com/devbox | bash # Install Devbox if not already installed (https://www.jetify.com/docs/devbox/installing-devbox/index)
devbox shell

task help # List available tasks
```

Access the platform at **http://localhost:3000**

---

## ⚙️ Configuration

All configuration is managed via environment variables and `.yaml` manifests.

Example:

```yaml
platform:
  name: OpenDev
  auth:
    provider: github
  catalog:
    sources:
      - type: github
        org: opendev-platform
  ci:
    provider: github-actions
```

---

## 🧪 CI/CD & Automation

The platform supports both **GitHub Actions** and **GitLab CI** out of the box.  
Pipelines are declared as YAML manifests and automatically discovered through the catalog.

Example pipeline:

```yaml
apiVersion: ci.opendev.io/v1
kind: Pipeline
metadata:
  name: build-and-deploy
spec:
  steps:
    - name: Build
      run: npm ci && npm run build
    - name: Deploy
      run: helm upgrade --install app ./charts/app
```

---

## 🔍 Observability

- Built-in metrics via **Prometheus** and **Grafana Dashboards**
- Tracing with **OpenTelemetry**
- Logging via **Loki**

---

## 🧱 Extending the Platform

You can extend OpenDev with plugins and templates.

### Example Plugin

```bash
npx create-opendev-plugin my-plugin
```

Register your plugin in `app-config.yaml` under the `plugins` section.

---

## 🤝 Contributing

We welcome contributions! Please see our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository  
2. Create a feature branch  
3. Submit a pull request  

All contributions must follow the project’s [Code of Conduct](CODE_OF_CONDUCT.md).

---

## 📜 License

Licensed under the **Apache License 2.0** — see the [LICENSE](LICENSE) file for details.

---

## 🌟 Acknowledgements

OpenDev Platform is inspired by/ built upon the following projects:
- [Spotify Backstage](https://backstage.io)
- [Dagger](https://dagger.io)
- [Nx](https://nx.dev)
- [Argo CD](https://argo-cd.readthedocs.io)
- [OpenTelemetry](https://opentelemetry.io)

---

**Made with ❤️ by the OpenDev community**
