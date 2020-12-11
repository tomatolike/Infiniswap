export LC_ALL=en_US.UTF-8
sudo dpkg-reconfigure locales

# install essentials
sudo apt-get update
sudo apt-get install -y git gcc g++ autoconf automake asciidoc asciidoctor bash-completion xmlto libtool pkg-config libglib2.0-0 libglib2.0-dev doxygen graphviz pandoc libncurses5 libkmod2 libkmod-dev libudev-dev uuid-dev libjson-c-dev libkeyutils-dev
sudo apt-get install -y dpkg

# install ndctl
cd ~

wget http://archive.ubuntu.com/ubuntu/pool/main/n/ndctl/libdaxctl1_67-1_amd64.deb
sudo dpkg -i libdaxctl1_67-1_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/main/n/ndctl/libndctl6_67-1_amd64.deb
sudo dpkg -i libndctl6_67-1_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/main/n/ndctl/libndctl-dev_67-1_amd64.deb
sudo dpkg -i libndctl-dev_67-1_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/universe/i/infinipath-psm/libpsm-infinipath1_3.3+20.604758e7-5_amd64.deb
sudo dpkg -i libpsm-infinipath1_3.3+20.604758e7-5_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/universe/libf/libfabric/libfabric1_1.5.3-1_amd64.deb
sudo dpkg -i libfabric1_1.5.3-1_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/universe/libf/libfabric/libfabric-dev_1.5.3-1_amd64.deb
sudo dpkg -i libfabric-dev_1.5.3-1_amd64.deb

wget http://archive.ubuntu.com/ubuntu/pool/main/n/ndctl/libdaxctl-dev_67-1_amd64.deb
sudo dpkg -i libdaxctl-dev_67-1_amd64.deb

#install pmem
cd ~
git clone https://github.com/pmem/pmdk.git
cd pmdk
make
sudo make install

#install vmem
cd ~
git clone https://github.com/pmem/vmem.git
cd vmem
git checkout tags/1.7
make
sudo make install

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH