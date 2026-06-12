# Deploying OpenStack from Scratch: Service-by-Service Architecture

This project shows how to build an OpenStack Cloud infrastructure manually, service by service. Instead of using automatic tools (like DevStack), I installed every component step-by-step. This helped me deeply understand how Cloud architecture, Linux systems, and networks work together.

## 📋 Project Overview

The goal of this project is to build a working Private Cloud. By installing each OpenStack service one by one, I learned exactly how Compute, Network, Identity, and Storage components talk to each other.

### OpenStack Services Implemented:
* **Keystone (Identity):** Manages authentication, users, and the service catalog.
* **Glance (Image):** Stores and manages Virtual Machine (VM) images.
* **Placement:** Tracks available hardware resources (CPU, RAM) for the instances.
* **Nova (Compute):** Creates and manages the lifecycle of Virtual Machines.
* **Neutron (Networking):** Manages virtual networks, subnets, routers, and ports.
* **Horizon (Dashboard):** The web interface to manage the Cloud easily.

---

## 🛠️ Technical Stack & Topology

I deployed a **3-node architecture** to simulate a real-world production environment:

* **1 Controller Node:** Runs Identity (Keystone), Image (Glance), Placement, Management APIs, MariaDB, and RabbitMQ.
* **2 Compute Nodes (Compute-01 & Compute-02):** Dedicated nodes running Nova-Compute and Hypervisors to host the Virtual Machines.

* **Operating System:** Ubuntu Server 24.04 LTS
* **OpenStack Version:** 2025.1 (Epoxy)

* **Database:** MariaDB (To store configuration and service data)
* **Message Queue:** RabbitMQ (For communication between OpenStack services)
* **Hypervisor:** KVM/QEMU (To run the virtual machines)

---

## 🏗️ How the Architecture Works

When you launch a virtual machine, the services communicate in this order:

1. **Authentication:** The user logs in and gets a security token from **Keystone**.
2. **Resource Check:** **Nova** asks **Placement** to find a hypervisor with enough free RAM and CPU.
3. **Network Creation:** **Neutron** creates a virtual port and gives an IP address to the future VM.
4. **Image Download:** **Nova** fetches the operating system image from **Glance**.
5. **Boot:** The hypervisor starts the Virtual Machine with the network and image attached.

---

## 🧠 What I Learned & Troubleshooting

Installing OpenStack "the hard way" is challenging. Here are the main problems I solved:

### 1. Advanced Cloud Networking
* **Problem:** Getting internal VMs to communicate with the external internet through Neutron.
* **Solution:** I configured the Management Network and the Provider Network. I learned how to configure Linux Bridges and routing paths to allow correct traffic flow.

### 2. Service Endpoints Configuration
* **Problem:** Services could not talk to each other because of incorrect URL configurations.
* **Solution:** I learned how Keystone manages `public`, `internal`, and `admin` endpoints, and how to verify them using the OpenStack CLI.

### 3. Reading Logs & Debugging
* **Problem:** Sometimes a VM failed to start without a clear error message on the screen.
* **Solution:** I learned to inspect log files directly (like `/var/log/nova/nova-compute.log` and `/var/log/neutron/neutron-server.log`) to find and fix the root cause.

---

## 🚀 Next Steps
- [ ] Secure the APIs using TLS/SSL certificates.
- [ ] Automate this entire manual installation using **Ansible** to transition into true Infrastructure as Code (IaC).