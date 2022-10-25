#!/bin/bash
#### Description: Upgrades mullvad-vpn app for debian/ubuntu based distros
#### 
#### Written by: poneli on 2021 October 2
#### Published on: https://github.com/poneli/
#### =====================================================================
#### <VARIABLES>
latestversion=$(curl -s -L https://github.com/mullvad/mullvadvpn-app/releases/latest | grep -m1 "/mullvad/mullvadvpn-app/releases/tag/20*" | cut -d '/' -f 9 | cut -d '"' -f 1)
currentversion=$(mullvad version | awk '/Current version:/ { print $3 }')
package=$(curl -s -L https://github.com/mullvad/mullvadvpn-app/releases/latest | grep "/mullvad/mullvadvpn-app/releases/download/${latestversion}/" | grep -m1 amd64.deb | cut -d '"' -f2)
downloadfolder="/home/(username)/Downloads" # No trailing slash
#### </VARIABLES>
if [[ $EUID -gt 0 ]]; then
	printf "Run with sudo... \n"
	exit
fi

if [[ $latestversion > $currentversion ]]; then
	printf "Downloading mullvad-vpn to %s... \n" "$downloadfolder"
	wget https://github.com$package -P $downloadfolder
	printf "Installing update... \n";
	dpkg -i $downloadfolder/MullvadVPN*.deb &>/dev/null
	if [[ $(mullvad version | awk '/Current version:/ { print $3 }') = $latestversion ]]; then
	  printf "mullvad-vpn updated successfully from version %s to %s... \n" "$currentversion" "$latestversion"
	  printf -- "%(%Y-%m-%d %H:%M)T [SUCCESS] mullvad-vpn updated to %s... \n" "$(date +%s)" "$latestversion" | tee -a $downloadfolder/update.log >/dev/null
	  printf "Cleaning up %s... \n" "$downloadfolder"
	  rm -f $downloadfolder/MullvadVPN*.deb
	else
	  printf "Installation of mullvad-vpn %s failed... \nTerminated... \n" "$latestversion"
	  printf -- "%(%Y-%m-%d %H:%M)T [ERROR] mullvad-vpn %s update failed... \n" "$(date +%s)" "$latestversion" | tee -a $downloadfolder/update.log >/dev/null
	  rm -f $downloadfolder/MullvadVPN*.deb
	fi
else
	printf "mullvad-vpn %s is already installed... \nTerminated... \n" "$latestversion"
	printf -- "%(%Y-%m-%d %H:%M)T [INFO] mullvad-vpn %s is already installed... \n" "$(date +%s)" "$latestversion" | tee -a $downloadfolder/update.log >/dev/null
fi
