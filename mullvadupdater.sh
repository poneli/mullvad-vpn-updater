#!/bin/bash
#### Description: Upgrades mullvad-vpn app for debian/ubuntu based distros
#### 
#### Written by: poneli on 2021 October 2
#### Published on: https://github.com/poneli/
#### =====================================================================
#### <VARIABLES>
latestversion=$(curl -s -L https://github.com/mullvad/mullvadvpn-app/releases/latest | grep -m1 '<meta property="og:title"' |sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')
currentversion=$(dpkg -s mullvad-vpn | grep '^Version:' | awk '{ print $NF }')
package=$(curl -s -L https://github.com/mullvad/mullvadvpn-app/releases/latest | grep "/mullvad/mullvadvpn-app/releases/download/${lversion}/" | grep -m1 amd64.deb | cut -d '"' -f2)
downloadfolder="/change/me/example/directory" # No trailing slash
#### </VARIABLES>
if [ "$EUID" -ne 0 ]; then
	printf -- "Run with sudo... \n";
	exit
fi

if [ "$latestversion" \> "$currentversion" ]; then
	printf -- "Downloading updated package to %s... \n" $downloadfolder;
	wget -q https://github.com$package -P $downloadfolder
	printf -- "Installing update... \n";
	dpkg -i $downloadfolder/*.deb &>/dev/null
	if [ "$(dpkg -s mullvad-vpn | grep '^Version:' | awk '{ print $NF }')" == "$latestversion" ]; then
	  printf -- "%s installed successfully... \n" $latestversion;
	  printf -- "Cleaning up %s... \n" $downloadfolder;
	  rm -f $downloadfolder/*.deb
	else
	  printf -- "Installation failed... \n";
	fi
else
	printf -- "Latest version %s is already installed... \n" $latestversion;
fi
