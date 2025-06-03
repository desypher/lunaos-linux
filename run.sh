#!/bin/bash

# Function to check X server
check_xserver() {
    export DISPLAY=:0
    echo "Checking X server at DISPLAY=$DISPLAY..."
    
    for i in {1..3}; do
        if xset q &>/dev/null; then
            echo "Successfully connected to X server at $DISPLAY"
            return 0
        fi
        sleep 1
    done
    
    echo "Failed to connect to X server"
    return 1
}

# Create and set runtime directory permissions
mkdir -p /run/user/1000
sudo chown $USER:$USER /run/user/1000
chmod 700 /run/user/1000

# Set X11 and OpenGL environment variables
export DISPLAY=:0
export QT_QPA_PLATFORM=xcb
export XDG_RUNTIME_DIR=/run/user/1000


# Install required packages
if ! command -v glxinfo &> /dev/null || ! command -v xset &> /dev/null; then
    echo "Installing required packages..."
    sudo apt update
    sudo apt install -y \
        x11-utils \
        x11-xserver-utils \
        mesa-utils \
        libgl1-mesa-glx \
        libgl1-mesa-dri \
        libqt5gui5 \
        libxcb-xinerama0 \
        libxcb-glx0 \
        qt5-default
fi

# Check X server
if ! check_xserver; then
    echo "Error: X server is not running or not accessible."
    echo "Please ensure VcXsrv is running on Windows with these settings:"
    echo "1. Run XLaunch"
    echo "2. Choose 'Multiple windows'"
    echo "3. Set 'Display number' to 0"
    echo "4. Select 'Start no client'"
    echo "5. Check 'Disable access control'"
    echo "6. In Extra settings:"
    echo "   - Add '-ac' to additional parameters"
    exit 1
fi

# Test OpenGL capabilities with software rendering
echo "Testing OpenGL capabilities..."
LIBGL_ALWAYS_SOFTWARE=1 glxinfo -B || echo "OpenGL information not available"

# Run the application with software rendering
echo "Starting LunaOS..."
./lunaos