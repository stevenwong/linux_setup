# install sublime text
# https://www.sublimetext.com/docs/3/linux_repositories.html

# if ubuntu doesn't detect nvidia driver, check what's the latest nvidia version
sudo ubuntu-drivers install --gpgpu
# check what version of CUDA TF is using. Usually, TF is more up to date than Pytorch and cuda is backward compatible
# https://www.tensorflow.org/install/pip
sudo apt install nvidia-headless-570 nvidia-dkms-570 nvidia-utils-570

# git https://www.gitkraken.com/

# ubuntu after install https://www.thefanclub.co.za/how-to/ubuntu-after-install

sudo apt install vim

sudo apt install -y build-essential cmake unzip pkg-config

# download postgres
sudo apt -y install postgresql postgresql-contrib

# go to
sudo vim /etc/postgresql/17/main/pg_hba.conf
# add this as second line (enables password connection for non-postgres users)
local   all             all                                     scram-sha-256
# add this line for docker
host    all    all    172.17.0.0/16    md5

sudo vim /etc/postgresql/17/main/postgresql.conf
# uncomment
# listen_addresses = 'localhost'
# for docker to work, you need the below
listen_addresses = '*'
# comment out ssh
#ssl = on
#ssl_ca_file = ''
#ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
#ssl_crl_file = ''
#ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'

# change the following values. Depending on how much system memory this machine has, set shared buffers to ~30% of system memory
shared_buffers = 16384MB
temp_buffers = 1024MB
work_mem = 1024MB
vacuum_cost_limit = 10000
#max_worker_processes = 8
max_parallel_workers_per_gather = 4
#max_parallel_workers = 8
autovacuum_max_workers = 5
autovacuum_vacuum_scale_factor = 0.02

seq_page_cost = 1.0			# measured on an arbitrary scale	
random_page_cost = 1.0			# same scale as above	

#autovacuum = on
#log_autovacuum_min_duration = 1min


# install odbc drivers
sudo apt install unixodbc unixodbc-dev
# not sure if the below line is required
sudo apt install libiodbc2 libiodbc2-dev libpq-dev libssl-dev
# this is required
sudo apt install unixodbc-common odbc-postgresql

sudo odbcinst -i -d -f /usr/share/psqlodbc/odbcinst.ini.template
sudo odbcinst -i -s -l -n test -f /usr/share/doc/odbc-postgresql/examples/odbc.ini.template

# edit the below file to make sure the driver is pointing to the right path
sudo vim /etc/odbcinst.ini
# append the following to the paths (make sure they point to the correct binaries)
# /usr/lib/x86_64-linux-gnu/odbc/


sudo apt install openssh-server

# docker can be installed via snap
# if using docker, you need to do this to enable connection to localhost
sudo ip addr show docker0 | grep inet
# check that the IP is the same as below
echo "172.17.0.1 host.docker.internal" | sudo tee -a /etc/hosts

# if you plan on using docker with cuda, you need to install nvidia container toolkit
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
