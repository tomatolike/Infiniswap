pdsh -w cp-[1-4] free -h | egrep Swap
pdsh -w cp-[1-4] sudo lxc-info -n memcached | egrep Memory