#!/bin/bash
set -e

GIT_REPO="https://github.com/lucasbasquerotto/ansible-demo.git"

yes | pip install 'dopy>=0.3.5,<=0.3.5'

cd ~

rm -rf ansible-demo
rm -rf ansible

git clone "$GIT_REPO"
mkdir ansible
shopt -s dotglob
mv ansible-demo/kube-cluster-do/* ansible/
rm -rf ansible-demo

mkdir -p ~/env
mv -vn ~/ansible/env.yml ~/env/env.yml

cd ~/ansible/
ansible-playbook "$1"
