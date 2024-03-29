# Ansible-windows

Generic Ansible role dedicated to execute various commons Windows tasks by mostly just providing a set of variables.

# Getting started

To quickly test the role, `create` a new playbook in the role directory with the content below.

*playbook-demo.yml*

```yaml
- name: Common windows tasks executer
  hosts: localhost
  tasks:
    - name: Install Demo
      include_tasks: tasks/main.yml
      vars: { product: 'demo', extras: { chocolatey: { name: thisisanextra, 
                                                       pinned: False, 
                                                       state: present, 
                                                       timeout: 666, 
                                                       version: "69.0.0"} } }
```

Now you can launch the demo playbook using the command below.

```shell
ansible-playbook playbook-demo.yml -i localhost
```
