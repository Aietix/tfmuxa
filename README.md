# 🌳 - tfmuxa # 
This Dockerfile creates a Docker image based on Alpine.  
It installs **TFLint**, **TFSec**, and **Terrascan**; these are utilities for **linting and security** scanning Terraform code.
  
**This Docker image, aietix/tfmuxa, is made for ARM architecture, but with this Dockerfile, you can easily rebuild it for other Unix-like systems with different architectures if needed.**

### Building the Docker Image# ###
Navigate to the directory containing the Dockerfile and run:
```
docker build -t tfmuxa .
```
### Usage: ### 
**Option 1:** 
```
docker run -v $(pwd):/workspace aietix/tfmuxa
```
This will run the scan in the current directory.
<br>
<br>

**Option 2:** Running shell with a Mounted Workspace Directory

```
docker run -v $(pwd):/workspace -it aietix/tfmuxa sh
```
<br>

**Option 3:** Running with a Specified GitHub Repository  
```
docker run aietix/tfmuxa https://github.com/Aietix/ec2-muxa.git
```
<br>
<br>

### Resources ###  
**TFLint** - Terraform Linter: https://github.com/terraform-linters/tflint  
**TFSec** - Terraform Security Scanner: https://github.com/aquasecurity/tfsec  
**Terrascan** - Detect compliance and security violations across Infrastructure as Code: https://github.com/tenable/terrascan  
