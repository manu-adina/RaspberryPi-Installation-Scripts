#!/bin/bash

set -e

printf -- '############################################\n\n'
printf -- 'Installing ROS Melodic on Pi 3B+ Stretch\n\n'

printf -- 'Turning Swap Off\n'
sudo dphys-swapfile swapoff

printf -- 'Increasing Swap Size to 1024\n'

sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile

printf -- 'Turning Swap On\n'
sudo dphys-swapfile swapon

printf -- 'Installing ROS Dependencies\n'
sudo apt-get -y --assume-yes install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential

printf -- 'Initializing Rosdep\n'
sudo rosdep init
rosdep update

printf -- 'Creating ROS Workspace\n'
mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws

printf -- 'Downloading packages to build\n'
install_generator desktop --rosdistro melodic --deps --tar > melodic-desktop.rosinstall
wstool init -j8 src melodic-desktop.rosinstall

printf -- 'Resolving dependencies\n'
rosdep install --from-paths src --ignore-src --rosdistro melodic -y

prinf -- 'Installing ROS\n'
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -j1

echo source ~/ros_catkin_ws/install_isolated/setup.bash >> ~/.bashrc
printf -- 'Added ROS to /.bashrc\n'

printf -- 'Reverting Swap Back to Default\n\n'

printf -- 'Turning Swap Off\n'
sudo dphys-swapfile swapoff

printf -- 'Reverting Swap Size Back to 100\n'
sudo sed -i 's/CONF_SWAPSIZE=1024/CONF_SWAPSIZE=100/g' /etc/dphys-swapfile

printf -- 'Turning Swap On\n'
sudo dphys-swapfile swapon

printf -- 'Installing ROS is Done.\n'
exit 0


