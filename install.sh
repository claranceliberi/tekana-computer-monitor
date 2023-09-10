#!/bin/bash

# Define the repository and destination directory
REPO_URL="https://github.com/claranceliberi/tekana-computer-monitor/raw/main"
TEMP_DIR="./tmc"
DEST_BINARY_DIR="/usr/local/tmc"


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

# If the folder to hold the binary does not exist create it
if [ ! -d "$TEMP_DIR" ]; then
    sudo mkdir -p $TEMP_DIR
else
    sudo rm -rf $TEMP_DIR/**
fi


# If the folder to hold the binary does not exist create it
if [ ! -d "$DEST_BINARY_DIR" ]; then
    sudo mkdir -p $DEST_BINARY_DIR
else
    echo ""
    echo ""
    echo "Directory already exists. Preparing for reinstallation..."
    cd $DEST_BINARY_DIR
    sudo rm -rf *
fi



# Downloading neccessary files
sudo wget -P $DEST_BINARY_DIR  $REPO_URL/build/$BINARY
sudo wget -P $TEMP_DIR $REPO_URL/service.sh 


# Copy the service script to a location in PATH
sudo cp $TEMP_DIR/service.sh /usr/local/bin/tmc

# Make it executable
sudo chmod +x /usr/local/bin/tmc
sudo chmod +x $DEST_BINARY_DIR/$BINARY

echo ""
echo ""
echo "Installation completed. You can now use the 'tmc' command."
