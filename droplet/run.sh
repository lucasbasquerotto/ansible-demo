#!/bin/bash
set -e

GIT_REPO="https://github.com/lucasbasquerotto/ansible-demo.git"

rm -rf ansible-demo
rm -rf ansible

cd ~
git clone "$GIT_REPO"
mkdir ansible
shopt -s dotglob
mv ansible-demo/droplet/* ansible/
rm -rf ansible-demo

# ansible-playbook ~/ansible/droplet.yml
cd ~/ansible/
ansible-playbook droplet.yml