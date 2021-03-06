# # update kernel version
# sudo apt-get update
# sudo apt-get install linux-generic-lts-xenial
# sudo reboot

# # set up RDMA
# pdsh -w cp-[1-2] /usr/local/bin/phase2-setup.sh accelio
# pdsh -w cp-[1-2] sudo reboot

# # pmdk
# cd ~
# sudo apt-get install autoconf automake pkg-config libglib2.0-dev pandoc libncurses5-dev
# sudo apt-get install -y git gcc g++ autoconf automake asciidoc asciidoctor bash-completion xmlto libtool pkg-config libglib2.0-0 libglib2.0-dev doxygen graphviz pandoc libncurses5 libkmod2 libkmod-dev libudev-dev uuid-dev libjson-c-dev libkeyutils-dev
# sudo apt-get install systemd
# export NDCTL_ENABLE=n
# git clone https://github.com/pmem/pmdk
# git checkout 1.4.1
# cd pmdk
# make
# sudo make install

# instal essentials
sudo apt-get update
sudo apt-get install -y libevent-dev lxc sshpass

# build Infiniswap

## setup infiniband NIC
local_ip=$(ifconfig | egrep '192.168.0' | awk '{print $2}' | cut -d : -f 2 | head -n 1)
echo ${local_ip}
cd setup
sudo bash ib_setup.sh ${local_ip}

## install infiniswap block device
bash install.sh daemon

## start daemon
cd ../infiniswap_daemon
echo "./infiniswap-daemon ${local_ip} 9400"
./infiniswap-daemon ${local_ip} 9400