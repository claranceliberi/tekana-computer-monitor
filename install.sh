#!/bin/bash

# Define the repository and destination directory
REPO_URL="https://gitlab.pepc.rw/tekana-v21/frontend-services/tekana-computer-monitor.git"
TEMP_DIR="~/tmc"
DEST_BINARY_DIR="/usr/local/tmc"

# Clone the repository
if [ ! -d "$TEMP_DIR" ]; then
    git clone $REPO_URL $DESTEMP_DIRT_DIR
else
    echo "Directory already exists. Pulling latest changes..."
    cd $TEMP_DIR
    git pull
fi



# Detect platform
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')/$(uname -m)"

# Map platform to binary
case "$PLATFORM" in
    "darwin/x86_64")
        BINARY="app-darwin-amd64"
        ;;
    "linux/x86_64")
        BINARY="app-linux-amd64"
        ;;
    "linux/i686"|"linux/i386")
        BINARY="app-linux-386"
        ;;
    "linux/arm")
        BINARY="app-linux-arm"
        ;;
    "linux/aarch64")
        BINARY="app-linux-arm64"
        ;;
    *)
        echo "Unsupported platform: $PLATFORM"
        exit 1
        ;;
esac


# Copy the service script to a location in PATH
sudo cp $TEMP_DIR/service.sh /usr/local/bin/tmc

# If the folder to hold the binary does not exist create it
if [ ! -d "$DEST_BINARY_DIR" ]; then
    sudo mkdir -p $DEST_BINARY_DIR
else
    echo "Directory already exists. Preparing for reinstallation..."
    cd $DEST_BINARY_DIR
    sudo rm -rf *
fi

# Copy the binary file into the etc folder
sudo cp $TEMP_DIR/build/$BINARY $DEST_BINARY_DIR/$BINARY

# Make it executable
sudo chmod +x /usr/local/bin/tmc

echo "Installation completed. You can now use the 'tmc' command."
