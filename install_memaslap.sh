
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
