#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ansible-playbook $SCRIPT_DIR/../playbook-demo.yml -i localhost