#!/bin/bash
set -e

ssh ubuntu@master-001.kube

kubectl get nodes

#kubectl run nginx --image=nginx --port 80
kubectl create deployment my-nginx --image nginx

#kubectl expose deploy nginx --port 80 --target-port 80 --type NodePort
#kubectl expose deployment my-nginx --type=LoadBalancer --port=8080
kubectl expose deployment my-nginx --type=LoadBalancer --port 80 --target-port 80

kubectl get services

kubectl delete service my-nginx

kubectl get services

kubectl delete deployment  my-nginx

kubectl get deployments

# kubeadm reset

# kubeadm init --ignore-preflight-errors=NumCPU

# kubectl get pods --all-namespaces

# kubectl describe pod -n kube-system coredns-86c58d9df4-hq897