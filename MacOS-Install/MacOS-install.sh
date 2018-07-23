VPN_AUTH_GROUP=###CHANGEME###
VPN_AUTH_CONNECT=###CHANGEME###
ADMIN911_PW=###CHANGEME###

# install homebrew #
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install apps from homebrew #
brew install blueutil openconnect tmux watch tree jq
brew cask install spectacle
brew install minio/stable/mc
brew install cloudfoundry/tap/credhub-cli
brew install cloudfoundry/tap/bosh-cli
brew install cloudfoundry/tap/cf-cli
brew install homebrew/cask/powershell
brew install homebrew/cask-versions/slack-beta
brew cask install microsoft-remote-desktop-beta
brew cask install iterm2
brew install zsh
gem install cf-uaac

# install zoom #
cd ~/Downloads
curl -L --remote-name https://zoom.us/client/latest/zoomusInstaller.pkg
sudo installer -pkg zoomusInstaller.pkg -target /

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

    /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool TRUE

    /usr/bin/profiles remove -identifier mil.disa.STIG.Application_Restrictions.alacarte
    /usr/bin/profiles remove -identifier mil.disa.STIG.Restrictions.alacarte

    sudo osascript -e "set volume input volume 50" 
elif [ "$1" == "disable" ]
then
    # closes V-75965 in a different way. #
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    blueutil --power 0 #

    # closes V-75967 in a different way. #
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    networksetup -setairportpower en0 off
    
    # close V-75969 #       
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool FALSE 

    # closes V-76051 #
    # Reference: Apple OS X 10.12 Security Technical Implementation Guide #
    # Please note that both profiles listed below are required to lockdown the camera. 
    # Application Restriction prevents FaceTime to be accessed, Restrictions Policy disables the camera and other apps. However, both are required to lock down the camera functionality. #
    /usr/bin/profiles install -path ~/workspace/epoc/MacOS-Install/U_Apple_OS_X_10-12_V1R3_Mobile_Configuration_Files/U_Apple_OS_X_10-12_V1R3_STIG_Application_Restrictions_Policy.mobileconfig
    /usr/bin/profiles install -path ~/workspace/epoc/MacOS-Install/U_Apple_OS_X_10-12_V1R3_Mobile_Configuration_Files/U_Apple_OS_X_10-12_V1R3_STIG_Restrictions_Policy.mobileconfig    

    # closes V-51323 #
    # Reference: Apple OS X 10.8 (Mountain Lion) Workstation STIG #
    # Please note that this finding was derived from an OLDER STIG check #
    sudo osascript -e "set volume input volume 0" 
else
    echo "Incorrect argument, please enter enable or disable"
fi' > rc-compliance.sh
chmod +x rc-compliance.sh

##### Create VPN connect script #####
cd ~/
echo "sudo openconnect --authgroup $VPN_AUTH_GROUP --script=~/vpnc-script-split-traffic.sh   $VPN_AUTH_CONNECT  --servercert sha256:cca84f3585f647d4507276d3b714fb3868ed1bd27e33b6535652fd915818d34c" > connect-ceif.sh
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

# Move epoc directory into the workspace
mv ~/epoc ~/workspace/

# Create admin 911 account #
sudo dscl . -create /Users/admin911
sudo dscl . -create /Users/admin911 UserShell /bin/bash
sudo dscl . -create /Users/admin911 RealName "admin911" 
sudo dscl . -create /Users/admin911 UniqueID "510"
sudo dscl . -create /Users/admin911 PrimaryGroupID 80
sudo dscl . -create /Users/admin911 NFSHomeDirectory /Users/admin911
sudo dscl . -passwd /Users/admin911 $ADMIN911_PW
sudo dscl . -append /Groups/admin GroupMembership admin911

echo "admin911 account created, you may need to reboot so admin privileges show correctly via the GUI"

# install oh-my-zsh (drops you into zsh and you must exit)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"