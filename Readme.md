# About The Project
Every developer wants to have his own local cluster instance running to play around with it. Therefore, this Vagrant project is for building a k8s cluster environment in VirtualBox with Ubuntu VMs.

## What is docker?
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers.
## What is k8s?
Kubernetes is a container-orchestration system for automating application deployment, scaling, and management.
## What is Vagrant?
Vagrant is a tool for building and managing virtual machine environments.

# Getting Started
Vagrant needs a virtual machine provider. In this project we are using VirtualBox.

Install VBox and Vagrant CLI:
* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)



## Bringing up the Cluster

    vagrant up

## Checking the Status

    vagrant status

## Logging to the master Node 

    vagrant ssh kmaster

# Resources
This is the link of the original tutorial: [Tutorial](https://www.exxactcorp.com/blog/HPC/building-a-kubernetes-cluster-using-vagrant)