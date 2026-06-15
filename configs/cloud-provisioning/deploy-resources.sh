#!/bin/bash
# OpenStack Cloud Resources Provisioning Script

# 1. Upload Cloud Image
openstack image create "ubuntu-24.04-cloud" --file ubuntu-24.04-server-cloudimg-amd64.img --disk-format qcow2 --container-format bare --public

# 2. Create Flavor (Instance size)
openstack flavor create --id 1 --ram 2048 --disk 20 --vcpus 2 m1.small

# 3. Create Networks & Router
openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider
openstack subnet create --network provider --allocation-pool start=192.168.200.100,end=192.168.200.200 --dns-nameserver 8.8.8.8 --subnet-range 192.168.200.0/24 public-subnet

openstack network create internal
openstack subnet create --network internal --dns-nameserver 8.8.8.8 --subnet-range 192.168.100.0/24 internal-subnet

openstack router create my-router
openstack router add subnet my-router internal-subnet
openstack router set network my-router --external-gateway provider

# 4. Configure Security Group
openstack security group create sg_groupe_ubu --description "Security group pour SSH & ICMP"
openstack security group rule create --proto icmp sg_groupe_ubu
openstack security group rule create --proto tcp --dst-port 22 sg_groupe_ubu

# 5. Boot Instance
openstack server create --flavor m1.small --image "ubuntu-24.04-cloud" --network internal --security-group sg_groupe_ubu 	my-ubuntu-vm