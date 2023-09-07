#!/bin/bash

# Set the output directory for compiled binaries
OUTPUT_DIR="build"

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# List of OS and architectures to build for
platforms=("windows/amd64" "windows/386" "darwin/amd64" "linux/amd64" "linux/386" "linux/arm" "linux/arm64")

# Compile for each platform
for platform in "${platforms[@]}"
do
    split=(${platform//\// })
    GOOS=${split[0]}
    GOARCH=${split[1]}
    output_name=$OUTPUT_DIR/'app-'$GOOS'-'$GOARCH
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi  

    # Print progress
    echo "Compiling for $GOOS/$GOARCH..."

    env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name .

    if [ $? -ne 0 ]; then
        echo "An error occurred while compiling for $GOOS/$GOARCH! Aborting the script execution..."
        exit 1
    else
        echo "Compilation for $GOOS/$GOARCH completed successfully!"
        # Make the compiled build executable (this doesn't harm on Windows, but is crucial for Unix-like OSes)
        chmod +x $output_name
    fi
done

echo "All compilations completed."
