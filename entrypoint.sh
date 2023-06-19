#!/bin/bash

# Display usage information
echo "Usage:"
echo "  docker run aietix/tfmuxa start - For starting the scan in the current directory"
echo "  docker run -it aietix/tfmuxa sh - For shell mode (with an argument 'sh')"
echo "  docker run aietix/tfmuxa <git-repo-url> - For automatic clone and run scan (with git-repo-url as an argument)"
echo ""

scan() {
    echo "===================================================="
    echo "================= Running TFLint ==================="
    echo "===================================================="
    echo ""
    tflint --chdir .
    echo ""

    echo "===================================================="
    echo "================= Running TFSec ===================="
    echo "===================================================="
    echo ""
    tfsec .
    echo ""

    echo "===================================================="
    echo "=============== Running Terrascan =================="
    echo "===================================================="
    echo ""
    terrascan init
    terrascan scan .
    echo ""
}

# If no argument is provided, the script will do nothing and exit
if [ "$#" -ne 1 ]; then
    exit 0
fi

# If the argument is 'sh', run the shell
if [ "$1" == "sh" ]; then
    echo "Initiating shell..."
    /bin/bash -i
    
# If the argument is a URL, clone the git repository and navigate to the 'repo' directory
elif [[ "$1" == http://* || "$1" == https://* ]]; then
    # Clone the git repository into a directory named 'repo'
    git clone "$1" repo
    scan
    # Navigate to the 'repo' directory
    cd repo || { echo "Failed to change to the 'repo' directory"; exit 1; }
# If the argument is a start, start the scan process
elif [[ "$1" == "start" ]]; then
    scan
else
    echo "Invalid argument. Please provide start, sh or git repository URL."
    exit 1
fi

