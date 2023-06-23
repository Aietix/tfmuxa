# 🌳 - tfmuxa # 
This Dockerfile creates a Docker image based on Alpine.  
It installs **TFLint**, **TFSec**, and **Terrascan**; these are utilities for **linting and security** scanning Terraform code.
  
  
### Prerequisites ###      
Docker installed on your machine.    


### Building the Docker Image# ## 
Navigate to the directory containing the Dockerfile and run:
```
docker build -t tfmuxa .
```

### Using the Docker Image ### 
**This Docker image (aietix/tfmuxa) is built specifically for Apple Silicon CPU arch**
<br>
<br>
**Option 1:**  Running in the Current Directory by Providing 'start' as an Argument
```
docker run -v $(pwd):/workspace aietix/tfmuxa start
```
This will run the scan in the current directory.
<br>
<br>

**Option 2:** Running shell with a Mounted Workspace Directory

```
docker run -v $(pwd):/workspace -it aietix/tfmuxa sh
```
<br>
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
