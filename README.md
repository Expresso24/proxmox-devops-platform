# Proxmox DevOps Platform

An automated, multi-distribution virtual datacenter provisioned on Proxmox VE using **OpenTofu** (Infrastructure as Code) and configured via **Ansible**. Designed to simulate enterprise network isolation, secure jump-host workflows, and heterogeneous Linux server workloads.

---

## Architecture Overview

```text
       [ Public / LAN Access ]
                  │
                  ▼ (SSH / Key-based only)
         ┌──────────────────┐
         │    Bastion VM    │ (Hardened Jump Host)
         └────────┬─────────┘
                  │
     ┌────────────┼────────────┬────────────┐
     │ (Internal) │            │            │
     ▼            ▼            ▼            ▼
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│ Debian  │  │  Rocky  │  │ Alpine  │  │  Arch   │
│ (Core)  │  │ (RHEL)  │  │ (Micro) │  │(Rolling)│
└─────────┘  └─────────┘  └─────────┘  └─────────┘
```

### Design Decisions
- **Bastion Host (`bastion.tf`)**: Single ingress point enforcing SSH key-based authentication and restricted administrative access to internal nodes.
- **Heterogeneous Workloads**:
  - **Rocky Linux (`rocky.tf`)**: Simulates enterprise RHEL environments for compliance and RPM-based workflows.
  - **Debian (`debian.tf`)**: Stable foundational tier for persistent background utilities.
  - **Alpine Linux (`alpine.tf`)**: Lightweight containerized host or micro-service sandbox.
  - **Arch Linux (`arch.tf`)**: Testing rolling-release packages and cutting-edge kernel features.
- **State & Secrets Management**: Sensitive state files and credential maps (`*.tfstate`, `*.tfvars`) are air-gapped and excluded from version control via strict `.gitignore` rules.

---

## Tech Stack

- **Virtualization:** Proxmox VE
- **IaC Engine:** OpenTofu
- **Configuration Management:** Ansible
- **Target OS:** Rocky Linux, Debian, Alpine Linux, Arch Linux

---

## Repository Structure

```text
├── modules/               # Reusable OpenTofu VM blueprints
├── ansible/               # Post-provisioning playbooks & baseline hardening
├── provider.tf            # Proxmox API provider configuration
├── variables.tf           # Variable declarations and typing
├── bastion.tf             # Edge gateway configuration
├── debian.tf              # Debian node definitions
├── rocky.tf               # Enterprise Linux definitions
├── alpine.tf              # Minimal footprint host definitions
├── arch.tf                # Rolling release testbed definitions
└── .terraform.lock.hcl    # Pinned provider dependencies
```

---

## Getting Started

### Prerequisites
1. Proxmox VE instance with API credentials.
2. OpenTofu CLI installed locally.
3. Ansible installed on your provisioning machine.

### Quickstart
1. Clone the repository:
   ```bash
   git clone https://github.com/Expresso24/proxmox-devops-platform.git
   cd proxmox-devops-platform
   ```
2. Set up credentials:
   Create a `secrets.auto.tfvars` file (not committed to VCS):
   ```hcl
   proxmox_api_url      = "https://proxmox.lan:8006/api2/json"
   proxmox_api_token_id = "tofu@pve!token"
   proxmox_api_secret   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
   ```
3. Initialize providers and inspect plan:
   ```bash
   tofu init
   tofu plan
   ```
4. Deploy:
   ```bash
   tofu apply
   ```

---

## License

Distributed under the MIT License. See `LICENSE` for more information.
