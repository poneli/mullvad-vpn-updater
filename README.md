# mullvad-vpn-updater
Update script for mullvad-vpn application for Debian/Ubuntu and RHEL/Fedora based systems.

mullvad-vpn-updater-deb.sh = Debian/Ubuntu

mullvad-vpn-updater-rpm.sh = RHEL/Fedora

Fetches latest version from https://github.com/mullvad/mullvadvpn-app/releases and compares version to currently installed version, will only download/install update if latest version is newer then currently installed version.

Update downloadfolder="/change/me/example/directory" to the directory where you want packages temp stored and log files stored.

Run with sudo.

Cheers!
