# set up RDMA
pdsh -w cp-[1-2] /usr/local/bin/phase2-setup.sh accelio
pdsh -w cp-[1-2] sudo reboot

# build Infiniswap