# install homebrew #
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install apps from homebrew #
brew install blueutil openconnect tmux watch tree jq 
brew install minio/stable/mc
brew install cloudfoundry/tap/credhub-cli
brew install cloudfoundry/tap/bosh-cli
brew install cloudfoundry/tap/cf-cli
brew install mas
mas install 715768417 803453959
gem install cf-uaac

# install zoom #
cd ~/Downloads
curl -L --remote-name https://zoom.us/client/latest/zoomusInstaller.pkg
sudo installer -pkg zoomusInstall.pkg -target /

#om-darwin
cd ~/Downloads
om_type=darwin
curl -L --remote-name $(curl -s https://api.github.com/repos/pivotal-cf/om/releases/latest | jq -r ".assets[] | select(.name | test(\"${om_type}\")) | .browser_download_url")
chmod +x om-darwin
mv om-darwin /usr/local/bin/om

# due to great reluctance, I'm allowing concourse to be installed #
cd ~/Downloads
concourse_type=concourse_darwin_amd64$
curl -L --remote-name $(curl -s https://api.github.com/repos/concourse/concourse/releases/latest | jq -r ".assets[] | select(.name | test(\"${concourse_type}\")) | .browser_download_url")
chmod +x concourse_darwin_amd64
mv concourse_darwin_amd64 /usr/local/bin/concourse

# install chrome #
cd ~/Downloads
curl https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg -o googlechrome.dmg
open ~/Downloads/googlechrome.dmg
sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

# install fly-cli #
cd ~/Downloads
fly_type=fly_darwin_amd64$
curl -L --remote-name $(curl -s https://api.github.com/repos/concourse/concourse/releases/latest | jq -r ".assets[] | select(.name | test(\"${fly_type}\")) | .browser_download_url")
chmod +x fly_darwin_amd64
mv fly_darwin_amd64 /usr/local/bin/fly

# install vscode #
cd ~/Downloads
curl -o VSCode-darwin-stable.zip -L --remote-name https://go.microsoft.com/fwlink/?LinkID=620882
cd /Applications
unzip ~/Downloads/VSCode-darwin-stable.zip

##### create workspace #####
mkdir ~/workspace

##### Create Ryan Center Compliance script #####
cd ~/workspace
echo '#!/bin/bash


if [ "$(which blueutil)" != "/usr/local/bin/blueutil" ]
then
    echo "blueutil is required to execute this script, please install: brew install blueutil"
    exit
fi

if [ "$1" == "enable" ]
then
    blueutil --power 1
    networksetup -setairportpower en0 on

    sudo chmod a+r /System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
    sudo chmod a+r /System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC
    #sudo chmod a+r /System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer
    sudo chmod a+r /Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
    sudo chmod a+r /Library/CoreMediaIO/Plug-Ins/FCP-DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera

    sudo osascript -e "set volume input volume 50" 
elif [ "$1" == "disable" ]
then
    blueutil --power 0
    networksetup -setairportpower en0 off
    sudo chmod a-r /System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
    sudo chmod a-r /System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC
    #sudo chmod a-r /System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer
    sudo chmod a-r /Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
    sudo chmod a-r /Library/CoreMediaIO/Plug-Ins/FCP-DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera

    sudo osascript -e "set volume input volume 0" 
else
    echo "Incorrect argument, please enter enable or disable"
fi' > rc-compliance.sh
chmod +x rc-compliance.sh

##### Create VPN connect script #####
cd ~/workspace
echo "sudo openconnect --authgroup ###update this value with authgroup### --script=~/vpnc-script-split-traffic.sh   ###update this value with connect info###   --servercert sha256:cca84f3585f647d4507276d3b714fb3868ed1bd27e33b6535652fd915818d34c" > connect-ceif-test.sh
chmod +x connect-ceif.sh

##### Create VPN tunnel script #####
echo '# Add one IP to the list of split tunnel
add_ip ()
{
	export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_ADDR=$1
        export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASK=$2
        export CISCO_SPLIT_INC_${CISCO_SPLIT_INC}_MASKLEN=$3
        export CISCO_SPLIT_INC=$(($CISCO_SPLIT_INC + 1))
}

# Initialize empty split tunnel list
export CISCO_SPLIT_INC=0

# Delete DNS info provided by VPN server to use internet DNS
# Comment following line to use DNS beyond VPN tunnel
#unset INTERNAL_IP4_DNS

# List of IPs beyond VPN tunnel
add_ip 10.5.15.0	 255.255.255.0 24   #MGMT1
add_ip 10.5.16.0 255.255.255.0 24       #MGMT2
add_ip 192.168.0.0 255.255.0.0 16		#Platform

# Execute default script
. /usr/local/etc/vpnc-script

# End of script' > vpnc-script-split-traffic.sh
chmod +x vpnc-script-split-traffic.sh

# Create admin 911 account #
sudo dscl . -create /Users/admin911
sudo dscl . -create /Users/admin911 UserShell /bin/bash
sudo dscl . -create /Users/admin911 RealName "admin911" 
sudo dscl . -create /Users/admin911 UniqueID "510"
sudo dscl . -create /Users/admin911 PrimaryGroupID 80
sudo dscl . -create /Users/admin911 NFSHomeDirectory /Users/admin911
sudo dscl . -passwd /Users/admin911 ### Updated password here ###
sudo dscl . -append /Groups/admin GroupMembership admin911

echo "admin911 account created, please reboot so admin privileges show correctly through the GUI"