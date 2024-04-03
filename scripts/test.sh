#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cat <<EOF > "$SCRIPT_DIR/../playbook-demo.yml"
- name: Common windows tasks executer
  hosts: localhost
  tasks:
    - name: Install Demo
      include_tasks: tasks/main.yml
      vars: { target_product: 'demo', extras: { chocolatey: { name: thisisanextra, state: present, version: "69.0.0" } } }
EOF

ansible-playbook  -i localhost $SCRIPT_DIR/../playbook-demo.yml

rm -rf "$SCRIPT_DIR/../playbook-demo.yml"