# Deploy one PA VM-Series on Alicloud using Terraform

Prequisites:
- Create a keypair in the region where you want to deploy the PA VM
  - https://www.alibabacloud.com/help/doc-detail/51792.htm
- Create a custom image to launch the PA VM
  - https://docs.paloaltonetworks.com/vm-series/9-0/vm-series-deployment/set-up-the-vm-series-firewall-on-alibaba-cloud/prepare-to-deploy-the-vm-series-firewall-on-alibaba-cloud.html#idd95814fd-ab5f-4a67-a060-e9858975316c
  - Your customer image name must contain the string: "vm-series-9.0.1"

Description:
- This skillet deploys a single VM-Series on Alibaba Cloud with 3 interfaces (Management, Untrust, Trust), with a public IP attached to the management interface.

