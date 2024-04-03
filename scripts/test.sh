#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mkdir -p $SCRIPT_DIR/../catalog/demo
mkdir -p $SCRIPT_DIR/../catalog/demo/templates

cat <<EOF > "$SCRIPT_DIR/../catalog/demo/templates/configuration.ini.j2"
test: {{ test }}
test1: {{ test1 }}
test2: {{ test2 }}
EOF

cat <<EOF > "$SCRIPT_DIR/../catalog/demo/main.yml"
jobs:
- chocolatey:
      name: test1
      pinned: False
      state: latest
      package_params: ""
      install_args: "/norestart /v /s"

      choco_args:
       - "--package-parameters-sensitive"

- chocolatey:
      name: test2
      pinned: True
      state: present
      timeout: 2700
      version: "1.0.0"
      ignore_errors: True

- download:
      url: 'http://urldownload2.com'
      destination: "/tmp/destination/"
      force: True
      archive:
        destination: "/tmp/unarchive_destination/"

- download:
      url: 'http://urldownload1.com'
      destination: "destination1"
      force: False
      ignore_errors: True

- regedits:
      name: Language Hotkey
      path: HKCU:\Keyboard Layout\Toggle
      data: 3
      type: dword
      state: present

- regedits:
      name: Language Hotkey
      path: HKCU:\Keyboard Layout\Toggle
      state: absent
      delete_key: yes
      ignore_errors: True

- services:
      name: 'spooler'
      start_mode: 'auto'
      state: 'started'

- shortcut:
      source: /tmp/test.png
      destination: /Desktop/test.png

- reboot:
      timeout: 3600

- win_features:
      name: Net-Framework-Features
      source: C:\Temp\iso\sources\sxs
      state: present
      reboot_if_needed: False
      include_sub_features: False
      include_management_tools: True
      ignore_errors: True

- executables:
      path: 'C:\temp\SQLEXPR_x64_ENU\SETUP.EXE'
      product_id: 'Microsoft SQL Server SQL2019'
      arguments:
        [
          SAPWD=VeryHardPassword,
          /ConfigurationFile=C:\temp\configuration.ini,
        ]
      become: True
      become_method: runas
      become_user: "user"
      become_pass: "password"

- executables:
      path: 'C:\temp\SAMPLE_x64_ENU\SETUP.EXE'
      product_id: 'Microsoft Demo Test'

- delete_file:
      path: 'C:\temp\test.txt'

- firewall_rule:
      name: SMTP
      localport: 25
      action: allow
      direction: in
      protocol: tcp
      state: present
      enabled: yes
      program: any
      ignore_errors: True

- template:
      source: templates/configuration.ini.j2
      destination: "/tmp/configtest.ini"
      owner: bin
      group: wheel
      mode: "0644"
      force: True
      template:
        vars: { test: test, test1: test1, test2: test2 }

- win_dsc:
      resource_name: win_dsc_test
      group_name: test_group
      members:
            - member1
            - member2
            - member3

- "{{ extras | default({}) }}"
EOF

cat <<EOF > "$SCRIPT_DIR/../playbook-demo.yml"
- name: Common windows tasks executer
  hosts: localhost
  tasks:
    - name: Install Demo
      include_tasks: tasks/main.yml
      vars: { target_product: 'demo', extras: { chocolatey: { name: thisisanextra, state: present, version: "69.0.0" } } }
EOF

ansible-playbook  -i localhost $SCRIPT_DIR/../playbook-demo.yml

rm -rf "$SCRIPT_DIR/../catalog/demo"
rm -rf "$SCRIPT_DIR/../playbook-demo.yml"