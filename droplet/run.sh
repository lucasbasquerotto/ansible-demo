#!/bin/bash
set -e

GIT_REPO="https://github.com/lucasbasquerotto/ansible-demo.git"
 
cd ~
git clone "$GIT_REPO"
mkdir ansible
shopt -s dotglob
mv ansible-demo/droplet/* ansible/

ansible-playbook ~/ansible/droplet.yml