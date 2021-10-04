#!/bin/bash
#### Description: Upgrades mullvad-vpn app for debian/ubuntu based distros
#### 
#### Written by: poneli on 2021 October 2
#### Published on: https://github.com/poneli/
#### =====================================================================
#### <VARIABLES>
latestversion=$(curl -s -L https://github.com/mullvad/mullvadvpn-app/releases/latest | grep -m1 '<meta property="og:title"' |sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')
currentversion=$(mullvad version | awk '/Current version:/ { print $3 }')
package=$(curl -s -L https://github.com/mullvad/mullvadvpn-app/releases/latest | grep "/mullvad/mullvadvpn-app/releases/download/${latestversion}/" | grep -m1 amd64.deb | cut -d '"' -f2)
downloadfolder="/change/me/example/directory" # No trailing slash
#### </VARIABLES>
if [[ $EUID > 0 ]]; then
	printf "Run with sudo... \n"
	exit
fi

if [[ $latestversion > $currentversion ]]; then
	printf "Downloading mullvad-vpn to %s... \n" $downloadfolder
	wget -q https://github.com$package -P $downloadfolder
	printf "Installing update... \n";
	dpkg -i $downloadfolder/*.deb &>/dev/null
	if [[ $(mullvad version | awk '/Current version:/ { print $3 }') = $latestversion ]]; then
	  printf "mullvad-vpn updated successfully from version %s to %s... \n" $currentversion $latestversion
	  printf "%(%Y-%m-%d %H:%M:%S)T [SUCCESS] mullvad-vpn updated to %s... \n" $(date +%s) $latestversion | tee -a $downloadfolder/update.log >/dev/null
	  printf "Cleaning up %s... \n" $downloadfolder
	  rm -f $downloadfolder/*.deb
	else
	  printf "Installation of mullvad-vpn %s failed... \nTerminated... \n" $latestversion
	  printf "%(%Y-%m-%d %H:%M:%S)T [ERROR] mullvad-vpn %s update failed... \n" $(date +%s) $latestversion | tee -a $downloadfolder/update.log >/dev/null
	fi
else
	printf "mullvad-vpn %s is already installed... \nTerminated... \n" $latestversion
	printf "%(%Y-%m-%d %H:%M:%S)T [INFO] mullvad-vpn %s is already installed... \n" $(date +%s) $latestversion | tee -a $downloadfolder/update.log >/dev/null
fi