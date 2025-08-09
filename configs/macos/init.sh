#!/bin/sh -eu

if [ "$(uname -s)" != "Darwin" ]; then
	log "info" "Do nothing on non-Darwin systems."
	return
fi

log "info" "Applying macOS settings..."

# Change trackpad speed
defaults write 'Apple Global Domain' com.apple.trackpad.scaling -float 3

# Enable three-finger drag
defaults write 'com.apple.AppleMultitouchTrackpad' TrackpadThreeFingerDrag -int 1
defaults write 'om.apple.driver.AppleBluetoothMultitouch.trackpad' TrackpadThreeFingerDrag -int 1

# Enable tap to click
defaults write 'com.apple.AppleMultitouchTrackpad' Clicking -int 1
defaults write 'com.apple.driver.AppleBluetoothMultitouch.trackpad' Clicking -int 1

# Automatically show/hide the Dock
defaults write 'com.apple.dock' autohide -int 1

# Enable dark-mode
defaults write 'Apple Global Domain' AppleInterfaceStyle -string Dark

log "info" "Reloading settings..."
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

log "info" "macOS settings have been applied."

log "info" "Please manually set the following settings in System Preferences:"
log "info" "  - Set Ctrl+Option+Space to switch input sources in Keyboard settings."
log "info" "  - Disable Ctrl-Space in Keyboard settings."
