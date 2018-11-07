#!/bin/bash
set -e

cd ~/kube-cluster

# Creates the non-root user ubuntu.
# Configures the sudoers file to allow the ubuntu user to run sudo commands without a password prompt.
# Adds the public key in your local machine (usually ~/.ssh/id_rsa.pub) to the remote ubuntu user's authorized key list. 
# >This will allow you to SSH into each server as the ubuntu user.
ansible-playbook -i hosts ~/kube-cluster/initial.yml

# 1) First Play:
# >Installs Docker, the container runtime.
# >Installs apt-transport-https, allowing you to add external HTTPS sources to your APT sources list.
# >Adds the Kubernetes APT repository's apt-key for key verification.
# >Adds the Kubernetes APT repository to your remote servers' APT sources list.
# >Installs kubelet and kubeadm.
#
# 2) Second Play 
# >Consists of a single task that installs kubectl on your master node.
ansible-playbook -i hosts ~/kube-cluster/kube-dependencies.yml

# The first task initializes the cluster by running kubeadm init. 
# >Passing the argument --pod-network-cidr=10.244.0.0/16 specifies the private subnet that the pod IPs will be assigned from. 
# >Flannel uses the above subnet by default; we're telling kubeadm to use the same subnet.
# The second task creates a .kube directory at /home/ubuntu. 
# >This directory will hold configuration information such as the admin key files, which are required to connect to the cluster, and the cluster's API address.
# The third task copies the /etc/kubernetes/admin.conf file that was generated from kubeadm init to your non-root user's home directory. 
# >This will allow you to use kubectl to access the newly-created cluster.
# The last task runs kubectl apply to install Flannel. 
# >kubectl apply -f descriptor.[yml|json] is the syntax for telling kubectl to create the objects described in the descriptor.[yml|json] file. 
# >The kube-flannel.yml file contains the descriptions of objects required for setting up Flannel in the cluster.
ansible-playbook -i hosts ~/kube-cluster/master.yml

# The first play gets the join command that needs to be run on the worker nodes. 
# >This command will be in the following format:kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>. 
# >Once it gets the actual command with the proper token and hash values, the task sets it as a fact so that the next play will be able to access that info.
#
# The second play has a single task that runs the join command on all worker nodes. 
# >On completion of this task, the two worker nodes will be part of the cluster.
ansible-playbook -i hosts ~/kube-cluster/workers.yml