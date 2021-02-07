#!/bin/bash

echo "Copying AutoHotkey script to startup dir. Start it yourself by running the script, or restart the PC"
USERNAME=$(powershell.exe '$env:UserName' | sed $'s/\r$//')
echo "Detected Windows username $USERNAME"
cp AutoHotkey.ahk "/mnt/c/Users/$USERNAME/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/"
