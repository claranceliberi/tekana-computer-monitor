#!/bin/bash

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

# Function to start the service
start_service() {
    nohup /usr/local/tmc/$BINARY &> /dev/null &
    echo $! > service.pid
    echo "Service started with PID $(cat service.pid)"
}

# Function to stop the service
stop_service() {
    if [ -f service.pid ]; then
        kill -9 $(cat service.pid)
        rm service.pid
        echo "Service stopped"
    else
        echo "Service is not running"
    fi
}

# Function to check the status of the service
check_status() {
    if [ -f service.pid ]; then
        if ps -p $(cat service.pid) > /dev/null; then
            echo "Service is running with PID $(cat service.pid)"
        else
            echo "Service is not running. PID $(cat service.pid) not found."
        fi
    else
        echo "Service is not running"
    fi
}

# Check command argument
case "$1" in
    "start")
        start_service
        ;;
    "stop")
        stop_service
        ;;
    "status")
        check_status
        ;;
    *)
        echo "Usage: $0 {start|status|stop}"
        exit 1
        ;;
esac
