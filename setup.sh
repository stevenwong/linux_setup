#!/bin/sh

# https://mensfeld.pl/2018/05/lenovo-thinkpad-x1-carbon-6th-gen-2018-ubuntu-18-04-tweaks/

# trackpad
# Edit the /etc/modprobe.d/blacklist.conf file and comment out following line:
# This line needs to be commented out
# blacklist i2c_i801

# Edit the /etc/default/grub file and change this line:
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
# to
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash psmouse.synaptics_intertouch=1"

sudo update-grub
sudo apt-get install xserver-xorg-input-synaptics
# You may want to add it to your .bashrc to make it work after reboot
synclient TapButton1=1 TapButton2=3 TapButton3=2


# low cTDP and trip temperature in Linux
sudo apt-get install msr-tools
sudo modprobe msrsudo
sudo rdmsr -f 29:24 -d 0x1a2

# Disable Secure Boot in the BIOS (won’t work otherwise)
sudo apt install git virtualenv build-essential python3-dev \
  libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev

git clone https://github.com/erpalma/lenovo-throttling-fix.git
cd lenovo-throttling-fix/
sudo ./install.sh

# Check again, that the result from running the rdmsr command is 3

# edit /etc/lenovo_fix to set TDP/trip temp and undervolt
[UNDERVOLT]
# CPU core voltage offset (mV)
#CORE: -105
# Integrated GPU voltage offset (mV)
#GPU: -85
# CPU cache voltage offset (mV)
#CACHE: -105
# System Agent voltage offset (mV)
#UNCORE: -85
# Analog I/O voltage offset (mV)
#ANALOGIO: 0


# battery charging
sudo apt-get install tlp tlp-rdw acpi-call-dkms tp-smapi-dkms acpi-call-dkms

# edit /etc/default/tlp
# Uncomment both of them if commented out
#START_CHARGE_THRESH_BAT0=45
#STOP_CHARGE_THRESH_BAT0=75

# reboot and run
sudo tlp-stat | grep tpacpi-bat

# you should see
#tpacpi-bat.BAT0.startThreshold          = 45 [%]
#tpacpi-bat.BAT0.stopThreshold           = 75 [%]

# if you ever need to recharge
#tlp fullcharge


# custom battery monitor
sudo add-apt-repository ppa:maateen/battery-monitor -y
sudo apt-get update
sudo apt-get install battery-monitor -y

# edit /usr/share/battery-monitor/config.py and comment out the first message
#MESSAGES = {
#    "success": (
#        u"Battery Monitor",
#        u"Cheers! Your battery is being monitored now."
#    ),


# WQHD display
# Install Gnome-Tweak-Tools as followed:
sudo apt-get install gnome-tweak-tool

# set Font Scaling Factor to 1.5


# HD (not WQHD) external monitor support
# add this script to ubuntu startup
#!/bin/bash
 
xrandr --query  | grep ' connected' | grep 1920 > /dev/null
result=$?
 
if [ $result -ne 0 ]; then
  # WQHD
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.5
  gsettings set org.gnome.nautilus.icon-view default-zoom-level standard
  gsettings set org.gnome.desktop.interface cursor-size 32
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 64
else
  # HD
  gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
  gsettings set org.gnome.nautilus.icon-view default-zoom-level small
  gsettings set org.gnome.desktop.interface cursor-size 24
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
fi


# S3 sleep mode
sudo apt-get install acpica cpio

# in BIOS, set Thunderbolt BIOS Assist Mode to ENABLED
# you will see the following in dmesg
#[    0.000000] ACPI: DSDT ACPI table found in initrd [kernel/firmware/acpi/dsdt.aml][0x2338b]
#[    0.000000] Lockdown: ACPI table override is restricted; see man kernel_lockdown.7
#[    0.000000] ACPI: kernel is locked down, ignoring table override

# generate the override
curl -O https://raw.githubusercontent.com/fiji-flo/x1carbon2018s3/master/generate_and_apply_patch.sh
chmod +x generate_and_apply_patch.sh
./generate_and_apply_patch.sh

# Edit your boot loader configuration and add /acpi_override to the initrd line. To ensure S3 is used as sleep default add mem_sleep_default=deep to you kernel parameters
# edit /boot/grub/grub.cfg and add
initrd   /acpi_override /initramfs-linux.img

# edit /etc/default/grub and edit
GRUB_CMDLINE_LINUX_DEFAULT="quiet mem_sleep_default=deep"

# reboot and you should see
#dmesg | grep ACPI | grep supports"
#    [    0.213668] ACPI: (supports S0 S3 S4 S5)