# install sublime text
# https://www.sublimetext.com/docs/3/linux_repositories.html

# git https://www.gitkraken.com/

# ubuntu after install https://www.thefanclub.co.za/how-to/ubuntu-after-install

sudo apt-get install vim

sudo apt-get install -y build-essential cmake unzip pkg-config

# download postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql postgresql-contrib

# go to
vim /etc/postgresql/13/main/pg_hba.conf
# add this as second line:wq
local   all             all                                     md5

sudo vim /etc/postgresql/13/main/postgresql.conf
# uncomment
listen_addresses = 'localhost'
# comment out ssh
#ssl = on
#ssl_ca_file = ''
#ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
#ssl_crl_file = ''
#ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'

# change the following values
shared_buffers = 512MB
temp_buffers = 512MB
work_mem = 128MB
vacuum_cost_limit = 10000
max_worker_processes = 8
max_parallel_workers_per_gather = 4
max_parallel_workers = 8

seq_page_cost = 1.0			# measured on an arbitrary scale	
random_page_cost = 1.0			# same scale as above	
cpu_tuple_cost = 0.01			# same scale as above	
cpu_index_tuple_cost = 0.005		# same scale as above	
cpu_operator_cost = 0.0025		# same scale as above	
parallel_tuple_cost = 0.1		# same scale as above	
parallel_setup_cost = 1000.0	# same scale as above

autovacuum = on
log_autovacuum_min_duration = 0


# install odbc drivers
sudo apt-get install unixodbc unixodbc-dev
# not sure if the below line is required
sudo apt-get install iodbc libiodbc2 libiodbc2-dev libpq-dev libssl-dev
# this is required
sudo apt-get install odbcinst1debian2 odbc-postgresql


sudo apt-get install odbc-postgresql
sudo odbcinst -i -d -f /usr/share/psqlodbc/odbcinst.ini.template
sudo odbcinst -i -s -l -n test -f /usr/share/doc/odbc-postgresql/examples/odbc.ini.template

# edit the below file to make sure the driver is pointing to the right path
sudo vim /etc/odbcinst.ini
# append the following to the paths (make sure they point to the correct binaries)
# /usr/lib/x86_64-linux-gnu/odbc/


# install cuda
sudo apt install nvidia-cuda-toolkit
# add this at the end of .bashrc
export CUDA_PATH=/usr
source ~/.bashrc
# check that cuda 11.2 is installed
nvidia-smi

# install cudnn. First download from nvidia and extract it
sudo cp cuda/include/cudnn*.h /usr/lib/cuda/include
sudo cp -P cuda/lib64/libcudnn* /usr/lib/cuda/lib64 
sudo chmod a+r /usr/lib/cuda/include/cudnn*.h /usr/lib/cuda/lib64/libcudnn*
echo 'export LD_LIBRARY_PATH=/usr/lib/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/lib/cuda/include:$LD_LIBRARY_PATH' >> ~/.bashrc 
sudo ln -s /usr/lib/cuda /usr/local/cuda-11.2


# optionally test that cuda is working correctly
wget https://github.com/NVIDIA/cuda-samples/archive/v11.2.tar.gz
tar xvf v11.2.tar.gz 
cd cuda-samples-11.2
make SMS="86"
./bin/x86_64/linux/release/immaTensorCoreGemm 


watch -d -n 0.5 nvidia-smi

