#!/bin/bash
set -e

#export DO_TOKEN=XXX

GIT_REPO="https://github.com/lucasbasquerotto/ansible-demo.git"
 
cd ~
git clone "$GIT_REPO"
mkdir chef-repo
shopt -s dotglob
mv ansible-demo/droplet/* ansible/

ansible-playbook ~/ansible/droplet.yml