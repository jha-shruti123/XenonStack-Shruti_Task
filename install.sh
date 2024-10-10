#!/bin/bash

# Define the script and man page names
SCRIPT_NAME="sysopctl"
MAN_PAGE_NAME="sysopctl.1"

# Use the home directory of the user who invoked sudo
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

BIN_DIR="$USER_HOME/bin"

MAN_DIR="/usr/share/man/man1"


# Function to display usage
function show_usage() {
    echo "Usage: $0 [--help]"
    echo "Install the sysopctl script and man page."
}

# Check for help option
if [[ "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Create the bin directory if it doesn't exist
if [ ! -d "$BIN_DIR" ]; then
    mkdir -p "$BIN_DIR"
    echo "Created directory: $BIN_DIR"
fi

# Copy the script to the bin directory
if [ -f "$SCRIPT_NAME" ]; then
    cp "$SCRIPT_NAME" "$BIN_DIR/"
    echo "Copied $SCRIPT_NAME to $BIN_DIR"
else
    echo "Error: $SCRIPT_NAME not found."
    exit 1
fi

# Make the script executable
chmod +x "$BIN_DIR/$SCRIPT_NAME"
echo "Made $SCRIPT_NAME executable."

# Install the man page
if [ -f "$MAN_PAGE_NAME" ]; then
    cp "$MAN_PAGE_NAME" "$MAN_DIR/"
    echo "Copied $MAN_PAGE_NAME to $MAN_DIR"
    mandb > /dev/null 2>&1
    echo "Updated man database."
else
    echo "Warning: $MAN_PAGE_NAME not found. Man page not installed."
fi

# Check if ~/bin is in PATH and add it if not
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Adding $BIN_DIR to PATH."
    echo "export PATH=\"\$HOME/bin:\$PATH\""
    echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$USER_HOME/.bashrc"
else
    echo "$BIN_DIR is already in PATH."
fi

# Source the .bashrc to apply changes immediately
echo "Sourcing ~/.bashrc to apply changes..."
source "$USER_HOME/.bashrc"

echo "Installation complete."

