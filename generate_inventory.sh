#!/bin/bash
# generate_inventory.sh
# Generates a static Ansible inventory file (inventory.ini) from Terraform outputs.
# Ensure that Terraform and jq are installed.

# Get Terraform outputs in JSON format
outputs_json=$(terraform output -json)

# Parse outputs using jq (make sure jq is installed)
dc_ip=$(echo "${outputs_json}" | jq -r '.adlab_dc_public_ip.value')
win10_ip=$(echo "${outputs_json}" | jq -r '.adlab_win10_public_ip.value')
blueteam_ip=$(echo "${outputs_json}" | jq -r '.blueteam_public_ip.value')
redteam_ip=$(echo "${outputs_json}" | jq -r '.redteam_public_ip.value')

# Generate the inventory file
cat <<EOF > inventory.ini
[domain_controllers]
dc1 ansible_host=${dc_ip}

[workstations]
ws1 ansible_host=${win10_ip}

[blueteam]
blueteam1 ansible_host=${blueteam_ip}

[redteam]
redteam1 ansible_host=${redteam_ip}

[all:vars]
ansible_user=Administrator
ansible_password=LabPass1
ansible_connection=winrm
ansible_port=5986
ansible_winrm_transport=basic
ansible_winrm_server_cert_validation=ignore
EOF

echo "Inventory file 'inventory.ini' has been generated."
