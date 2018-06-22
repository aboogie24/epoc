# epoc
EPOC Repo

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

#### Usage:
```
IMPORTANT! 
Update the MacOS-install.sh with the password for the admin911 account
./MacOS-install.sh ---- The MacBook must be rebooted inorder for the admin911 account to reflect as admin.
```
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