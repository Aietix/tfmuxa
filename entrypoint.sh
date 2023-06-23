#!/bin/sh

scan() {
    echo "===================================================="
    echo "================= Running TFLint ==================="
    echo "===================================================="
    echo ""
    tflint --color --chdir .
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

# If no argument is provided, start scannig.
if [ "$#" -ne 1 ]; then
    scan
fi
# If the argument is 'sh', run the shell
if [ "$1" == "sh" ]; then
    echo "Initiating shell..."
    /bin/sh -i
# If the argument is a URL, clone the git repository and navigate to the 'repo' directory
elif [[ "$1" == http://* || "$1" == https://* ]]; then
    # Clone the git repository into a directory named 'repo'
    git clone "$1" repo
    # Navigate to the 'repo' directory
    cd repo || { echo "Failed to change to the 'repo' directory"; exit 1; }
    scan
else
    # Display usage information
    echo "Invalid argument."
    echo "docker run aietix/tfmuxa - For starting the scan in the current directory"
    echo "docker run -it aietix/tfmuxa sh - For shell mode)"
    echo "docker run aietix/tfmuxa <git-repo-url> - For automatic clone and run scan"
    exit 1
fi

