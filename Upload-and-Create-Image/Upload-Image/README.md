# Upload File into Alibaba Cloud Object Storage Service (OSS)

Prequisites:
- Download a copy of the VM-Series KVM qcow2 base image from the Palo Alto Networks support website
- Ensure that you start Panhandler with the option to mount a volume on the /root/.pan_cnc folder
  - See Panhandler documentation for instructions
    - https://panhandler.readthedocs.io/en/master/running.html
- Assuming you mounted local directory ~/.pan_cnc
  - Copy/move the VM-Series image to the directory ~/.pan_cnc/panhandler/repositories/Upload-and-Create-Image/Upload-Image
  - Take note of the filename (including any extensions)

Description:
- This skillet will create an OSS bucket and upload the VM-Series image into the bucket.


## Support Policy
The code and templates in the repo are released under an as-is, best effort,
support policy. These scripts should be seen as community supported and
Palo Alto Networks will contribute our expertise as and when possible.
We do not provide technical support or help in using or troubleshooting the
components of the project through our normal support options such as
Palo Alto Networks support teams, or ASC (Authorized Support Centers)
partners and backline support options. The underlying product used
(the VM-Series firewall) by the scripts or templates are still supported,
but the support is only for the product functionality and not for help in
deploying or using the template or script itself. Unless explicitly tagged,
all projects or work posted in our GitHub repository
(at https://github.com/PaloAltoNetworks) or sites other than our official
Downloads page on https://support.paloaltonetworks.com are provided under
the best effort policy.
