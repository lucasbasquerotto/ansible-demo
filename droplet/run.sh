#!/bin/bash
set -e

GIT_REPO="https://github.com/lucasbasquerotto/ansible-demo.git"
 
cd ~
git clone "$GIT_REPO"
mkdir ansible
shopt -s dotglob
mv ansible-demo/droplet/* ansible/
rm -rf ansible-demo

ansible-playbook ~/ansible/droplet.yml