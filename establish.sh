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
client_ip=$1

if [$# -eq 0]
then
    echo "Need client ip"
    exit 1
fi

## setup infiniband NIC
local_ip=$(ifconfig | egrep '192.168.0' | awk '{print $2}' | cut -d : -f 2 | head -n 1)
echo ${local_ip}
cd setup
sudo bash ib_setup.sh ${local_ip}

## install infiniswap block device
bash install.sh bd

## prepare client list
newline=$'\n'
list='1'${newline}${client_ip}
echo "${list}" > portal.list

## disable existing swap partitions
device=$(sudo swapon -s | egrep dev | awk '{print$1}')
sudo swapoff ${device}

## create infiniswap block device
sudo bash infiniswap_bd_setup.sh

## check
num=$(sudo swapon -s | wc -l)
if [ ${num} == '2' ]
then
    echo "Seems to be installed"
else
    echo "Not successfully installed"
fi

# build memaslap
cd ~
git clone https://github.com/pgaref/memcached_bench.git
cd ~/memcached_bench
rm -rf libmemcached-1.0.15
tar -zxvf libmemcached-1.0.15-patched.tar.gz
cd libmemcached-1.0.15
./configure --enable-memaslap
sed -i 's/^LDFLAGS =/LDFLAGS = -L\/lib64 -lpthread/' Makefile
make
cd clients
cp memaslap ~/Infiniswap/memcached_bench/

# setup LXC
cd ~
mkdir lxc
cd lxc
cp /etc/lxc/default.conf ./memcached.conf
echo 'lxc.cgroup.memory.limit_in_bytes = 4G' >> memcached.conf
echo 'test' > memcached.log
sudo lxc-create -n memcached -f memcached.conf -t ubuntu
sudo lxc-start -d -n memcached --console-log memcached.log
sudo lxc-attach -n memcached -- /bin/bash -c "sudo apt-get update && sudo apt-get install -y memcached"
echo "lxc started, wait for several seconds"
sleep 5
lxcip=$(sudo lxc-attach -n memcached -- /bin/bash -c "ifconfig | egrep '10.0.3' | cut -d : -f 2 | cut -d ' ' -f 1 | head -n 1")
echo ${lxcip} > ~/lxcip.txt
sshpass -p ubuntu ssh ubuntu@${lxcip} -f 'memcached -d -m 65535'

# prepare experiment file
echo "~/Infiniswap/memcached_bench/memcached -s "${lxcip}":11211 -F bost.cfg -x 3000000" > ~/bost.sh
echo "~/Infiniswap/memcached_bench/memcached -s "${lxcip}":11211 -F SYS.cfg -x 10000000" > ~/SYS.sh
