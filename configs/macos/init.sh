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

# Disable 'Click wallpaper to reveal desktop'
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -int 0

# Fix workspace order
defaults write 'com.apple.dock' mru-spaces -int 0

# Enable dark-mode
defaults write 'Apple Global Domain' AppleInterfaceStyle -string Dark

# Enable backslash input when the yen symbol key is pressed.
defaults write 'com.apple.inputmethod.Kotoeri' JIMPrefCharacterForYenKey -int 1

log "info" "Reloading settings..."
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

log "info" "macOS settings have been applied."

log "info" "Please manually set the following settings in System Preferences:"
log "info" "  - Disable Ctrl-Space in Keyboard settings."
log "info" "  - Enable '英字' input mode of '日本語 - ローマ字入力' input source."
log "info" "  - Remove 'ABC' input source for typing backslash."
