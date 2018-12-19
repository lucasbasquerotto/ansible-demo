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

# kubeadm init --ignore-preflight-errors=NumCPU

# kubectl get pods --all-namespaces

# kubectl describe pod -n kube-system coredns-86c58d9df4-hq897