
# setup LXC
cd ~
mkdir lxc
cd lxc
cp /etc/lxc/default.conf ./memcached.conf
echo 'lxc.cgroup.memory.limit_in_bytes = 4G' >> memcached.conf
echo 'test' > memcached.log
sudo lxc-create -n memcached -f memcached.conf -t ubuntu
sudo lxc-start -d -n memcached --console-log memcached.log
echo "lxc started, wait for several seconds"
sleep 5
sudo lxc-attach -n memcached -- /bin/bash -c "sudo apt-get update && sudo apt-get install -y memcached"
lxcip=$(sudo lxc-attach -n memcached -- /bin/bash -c "ifconfig | egrep '10.0.3' | cut -d : -f 2 | cut -d ' ' -f 1 | head -n 1")
echo ${lxcip} > ~/lxcip.txt
echo "wait for several seconds again"
sleep 5
sshpass -p ubuntu ssh -o "StrictHostKeyChecking no" ubuntu@${lxcip} -f 'memcached -d -m 65535'

# prepare experiment file
echo "~/Infiniswap/memcached_bench/memaslap -s "${lxcip}":11211 -F ~/Infiniswap/memcached_bench/bost.cfg -x 3000000" > ~/bost.sh
echo "~/Infiniswap/memcached_bench/memaslap -s "${lxcip}":11211 -F ~/Infiniswap/memcached_bench/SYS.cfg -x 10000000" > ~/SYS.sh
