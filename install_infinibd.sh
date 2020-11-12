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
list='1'${newline}${client_ip}:9400
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