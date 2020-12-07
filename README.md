# bufFPlug

## System requirements

We support and test macOS 11.0 and higher. 10.15 _might_ also work. 

## HowTo Setup

### Add your sudo pass to secretSudoPassword.sh

If you want Xcode to install the plugin, we need your suso password
```
git clone https://github.com/buffstop/bufFPlug.git
pushd bufFPlug
echo "YOUR_SUDO_PASS" > secretSudoPassword.sh
popd
```
