# Crownstone cloud installer

This repository maintains scripts to install your own instance of Crownstone cloud on a local machine such as a raspberry pi (3/4/400).

This `install.sh` script installs the complete Crownstone cloud, and updates it as well.

The Crownstone cloud uses MongoDB to store data. This script can install MongoDB as well. However, authorization will not be set up, though it will not be accessible via network.

## Installing

When building for a raspberry pi, ensure to use the 64-bit OS. Please double check your system requirements.

How to run the installer:
```
sudo apt update
sudo apt install -y git
git clone https://github.com/Crownstone-Community/cloud-installer.git
cd cloud-installer
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
./install.sh ~/crownstone-cloud
```

Some installation confirmations may be asked during the installation process and you might need to update the keys of `mongo-init.js`.

You can see logs with `journalctl --user`.

## Data import

Every user in your sphere will have to download their data at [https://next.crownstone.rocks/user-data](https://next.crownstone.rocks/user-data).

Then, go to your own cloud v2 server [http://127.0.0.1:3050/import-data](http://127.0.0.1:3050/import-data) and the port configured for cloud v2. Make sure to replace `127.0.0.1` with the IP address of your server, you can find it with the command `hostname -I`.

Now upload the downloaded data. Note that this can take a while, wait until the page changes into "DONE".

## App settings

Make sure to configure your pi to have a static ip address. Usually this can be done by logging in on your router.

Now you can change the cloud address in the Crownstone app settings.
- Address of custom cloud v1: http://127.0.0.1:3000/api/
- Address of custom cloud v2: http://127.0.0.1:3050/api/
- Address of custom sse server: http://127.0.0.1:8000/sse/

Again, fill in the IP address of your server, and use the ports as configured.

Note: After a preliminary success message you may get a warning pop-up saying that the cloud endpoints are not stored. This is a known bug. As long as the preliminary message reported success, you're all good.


## Open-source license

This software is provided under a noncontagious open-source license towards the open-source community. It's available under three open-source licenses:
 
* License: LGPL v3+, Apache, MIT

<p align="center">
  <a href="http://www.gnu.org/licenses/lgpl-3.0">
    <img src="https://img.shields.io/badge/License-LGPL%20v3-blue.svg" alt="License: LGPL v3" />
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT" />
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License: Apache 2.0" />
  </a>
</p>

## Commercial license

This software can also be provided under a commercial license. If you are not an open-source developer or are not planning to release adaptations to the code under one or multiple of the mentioned licenses, contact us to obtain a commercial license.

* License: Crownstone commercial license

# Contact

For any question contact us at <https://crownstone.rocks/contact/> or on our discord server through <https://crownstone.rocks/forum/>.
