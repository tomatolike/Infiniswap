
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
