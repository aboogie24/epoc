# epoc
EPOC Repo

# Install procedures
```
Important! Ensure that you have accessed the Apple App Store before executing this script.
1. Open terminal
2. git clone https://github.com/jmcclenny-epoc/epoc.git
3. cd epoc/MacOS-Install
4. vi MacOS-Install.sh update the following variables:
        VPN_AUTH_GROUP
        VPN_AUTH_CONNECT
        ADMIN911_PW=
5. ./MacOS-install.sh

See below for individual script usage.
```
This project is to provision tools on a MacBook OS for an EPOC Platform Operator that our team identified necessary for day-to-day ops.

Additionally, this project builds the scripts for specific VPN connection and splitting. As well as compliance for disabling specific functions of the MacBook to bring into secure facilities.

## Programs installed to make my life easier
    - Homebrew (version: latest)

## Packages installed with homebrew:  
    - mas (version: latest)  
    - tmux (version: latest)  
    - jq (version: latest)  
    - blueutil (version: latest) 
    - bosh-cli (version: latest)
    - credhub-cli (version: latest)
    - watch (version: latest)
    - openconnect (version: latest)
    - tree (version: latest) 
    - mc-cli (version: latest)
    - cf-cli (version: latest)
    - iterm2
    - zsh 

## Packages installed from github
    - fly (version: latest)
    - concourse (version: latest)
    - om-cli (version: latest)
        
## Packages installed with gem
    - cf-uaac (version: latest)

## Packages installed from AppleStore
    - Microsoft Remote Desktop 8 (version: latest)
    - Slack (version: latest)

## Packages installed from curl
    - Zoom (version: latest)
    - Google Chrome (version: latest)
    - Microsoft Visual Code (version: latest)
    - Oh-My-Zsh

## Additional configuration
    - creates VPN connection script
    - creates VPN split script
    - creates MacBook compliance script
    - creates admin911 administrator account
    - creates the workspace directory in the user home director (~/workspace))
      
- - -

To Do:
- [] TBD

- - -

#### VPN Usage:
```
IMPORTANT! 
Update the ./connect-ceif.sh script with the authgroup and connection information before running.
./connect-ceif.sh
```
#### Compliance Usage:
```
./rc-compliance.sh disable
./rc-compliance.sh enable
```