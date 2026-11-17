# Azure Infrastructure Automation with Terraform

Terraform deploys an Ubuntu VM on Azure. A reusable network module creates the
VNet, subnet, and network security group. Cloud-init installs Nginx and creates
a custom web page on first boot.

## Verification

I tested the public endpoint from my Mac with `curl`. It returned
`HTTP/1.1 200 OK` and displayed “Nginx deployed on Azure with Terraform.”

## Troubleshooting

Azure couldn't allocate `Standard_B2s` in Central India. I changed the VM size
and reran Terraform to complete the deployment.