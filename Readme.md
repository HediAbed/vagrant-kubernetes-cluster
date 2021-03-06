# About The Project
Every developer wants to have his own local cluster instance running to play around with it. Therefore, this Vagrant project is for building a k8s cluster environment in VirtualBox with Ubuntu VMs.

![CMD Image](img/starting-cluster.png)

### What is docker?
Docker is a tool designed to make it easier to create, deploy, and run applications by using containers.
### What is k8s?
Kubernetes is a container-orchestration system for automating application deployment, scaling, and management.
### What is Vagrant?
Vagrant is a tool for building and managing virtual machine environments.

# Installation
Vagrant needs a virtual machine provider. In this project we are using VirtualBox.

Install VBox and Vagrant CLI:
* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)

# Getting Started
This kubernates cluster hast a one Master Node `kmaster` and two Worker Nodes `kworker1` and `kworker2`.

### Bringing up the Cluster

    vagrant up

### Checking the Status

    vagrant status

### Logging to the master Node 

    vagrant ssh kmaster

### Bringing down the Cluster

    vagrant halt --force

### How to change the number of workers
1) go to the `Vagrantfile` (line 21) and increase the `NodeCount` value.
```ruby
   NodeCount = 3
```
2) go to `bootstrap.sh` shell script and scroll to `# Update hosts file` section (line 42) and add the folowing new line for the `kworker3`.
```sh
   # Update hosts file
    echo "[TASK 5] Update /etc/hosts file"
    cat >>/etc/hosts<<EOF
    200.1.1.100 kmaster.example.com kmaster
    200.1.1.101 kworker1.example.com kworker1
    200.1.1.102 kworker2.example.com kworker2
    200.1.1.103 kworker3.example.com kworker3 
    EOF
```
3) Save all and run `vagrant up` cli

![kworker3 added image](img/added-kworker3.png)

# Vagrantfile Explanation

### Env Variables
Vagrant has a set of environmental variables that can be used to configure and control it in a global way. and setting `VAGRANT_NO_PARALLEL` means that it will not perform any parallel operations (parallel box provisioning)

```ruby
ENV['VAGRANT_NO_PARALLEL'] = 'yes'
```

### Init
If you run `vagrant init`, the cli generate a Vagrantfile with the following example. And The "2" in the first line of the example below represents the version of the configuration object `config`.

```ruby
Vagrant.configure("2") do |config|
  # ...
end
```

### Shell provisioner
The Vagrant Shell provisioner allows you to upload and execute a script within the guest machine.
```ruby
config.vm.provision "shell", path: "example.sh"
```
### Machine Settings
Vagrant is able to define and control multiple guest machines. The using of `config.vm.define` method call creates a Vagrant configuration within the "global configuration" `Vagrant.configure`.

```ruby
config.vm.define "mydebian" do |mydebian|
  # ...
end
```

#### Machine 
This configures what box the machine will be brought up against. The value here should be the name of an installed box or a shorthand name of a box in HashiCorp's Vagrant Cloud.

```ruby
config.vm.define "mydebian" do |mydebian|
  mydebian.vm.box = "debian/buster64"
  # ...
end
```

#### Hostname 
The `__.vm.hostname` setting.  By default, this will modify `/etc/hosts` and add the hostname on a loopback interface that is not in use. For example `127.0.X.1`. However, A public `public_network` or private `public_network` network with assigned IP could be flagged for the hostname.
 
```ruby
config.vm.define "mydebian" do |mydebian|
  # ...
  mydebian.vm.hostname = "debian.example.com"
  mydebian.vm.network "private_network", ip: "100.10.10.10"
  # ...
end
```
#### Provider 
The VirtualBox provider exposes some configuration options that allow you to more control your VirtualBox environments. And By default, VirtualBox machines are started in headless mode.

```ruby
config.vm.define "mydebian" do |mydebian|
  # ...
  mydebian.vm.provider "virtualbox" do |v|
  v.name = "mydebian"
  v.memory = 2048
  v.cpus = 2
  end
  # ...
end
```

# Resources
This is the link of the original tutorial: [Tutorial](https://www.exxactcorp.com/blog/HPC/building-a-kubernetes-cluster-using-vagrant)