#!/bin/bash
set -e

ssh ubuntu@master-001.kube

kubectl get nodes

kubectl run nginx --image=nginx --port 80

kubectl expose deploy nginx --port 80 --target-port 80 --type NodePort

kubectl get services

kubectl delete service nginx

kubectl get services

kubectl delete deployment nginx

kubectl get deployments

# kubeadm reset