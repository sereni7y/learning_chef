# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

CHEF_SERVER_SCRIPT = <<EOF.freeze
apt-get update
apt-get -y install curl

# ensure the time is up to date
echo "Installing ntp..."
apt-get -y install ntp
service ntp stop
echo "Setting time..."
ntpdate -s time.nist.gov
service ntp start

# checking for local Chef server package and downloading if not found
echo "Checking for local Chef server package..."
if [ ! -e /vagrant/chef-server-core_12.11.1_amd64.deb ]; then
  echo "No local Chef server package found, downloding from chef.io, this may take some time..." 
  wget -nv -P /vagrant https://packages.chef.io/files/stable/chef-server/12.11.1/ubuntu/14.04/chef-server-core_12.11.1-1_amd64.deb
fi

# install the package
echo "Installing Chef server..."
sudo dpkg -i /vagrant/chef-server-core_12.11.1-1_amd64.deb

# reconfigure and restart services
echo "Reconfiguring Chef server..."
sudo chef-server-ctl reconfigure
echo "Restarting Chef server..."
sudo chef-server-ctl restart

# wait for services to be fully available
echo "Waiting for services..."
until (curl -D - http://localhost:8000/_status) | grep "200 OK"; do sleep 15s; done
while (curl http://localhost:8000/_status) | grep "fail"; do sleep 15s; done

# create admin user
echo "Creating a user..."
sudo chef-server-ctl user-create admin andrew andrew admin@learning-chef.com insecurepassword --filename admin.pem
echo "Creating an organisation..."
sudo chef-server-ctl org-create dev "development" --association_user admin --filename LearningChef-validator.pem

# copy admin RSA private key to share
echo "Copying admin key to /vagrant/secrets..."
mkdir -p /vagrant/secrets
cp -f /home/vagrant/admin.pem /vagrant/secrets

echo "Your Chef server is ready!"
EOF

NODE_SCRIPT = <<EOF.freeze
echo "Preparing node..."

# ensure the time is up to date
echo "Installing ntp..."
apt-get update
apt-get -y install ntp
service ntp stop
echo "Setting time..."
ntpdate -s time.nist.gov
service ntp start

echo "10.1.1.10 chef-server.test" | tee -a /etc/hosts
EOF

WORKSTATION_SCRIPT = <<EOF.freeze
echo "updating apt repo..."
apt-get update
echo "installing curl..."
apt-get -y install curl
echo "installing git..."
apt-get -y install git

# ensure the time is up to date
echo "Installing ntp..."
apt-get -y install ntp
service ntp stop
echo "Setting time..."
ntpdate -s time.nist.gov
service ntp start

# download the Chef DK package
echo "Checking for local Chef DK..."
if [ ! -e /vagrant/chefdk_1.2.22-1_amd64.deb ]; then
  echo "No local Chef DK package found, downloding from chef.io, this may take some time..." 
  wget -nv -P /vagrant https://packages.chef.io/files/stable/chefdk/1.2.22/ubuntu/14.04/chefdk_1.2.22-1_amd64.deb
fi

# install the package
echo "Installing Chef DK..."
sudo dpkg -i /vagrant/chefdk_1.2.22-1_amd64.deb

# Setting up working folders
echo "creating working folders..."
mkdir /home/vagrant/learning_chef
mkdir /home/vagrant/learning_chef/.chef
mkdir /home/vagrant/learning_chef/cookbooks
cd /home/vagrant/learning_chef/cookbooks
echo "Downloading example cookbook..."
git clone https://github.com/learn-chef/learn_chef_apache2.git

echo "copying pem file to .chef..."
cp /vagrant/secrets/admin.pem /home/vagrant/learning_chef/.chef/

echo "copying knife.rb file to .chef..."
cp /vagrant/setup/knife.rb /home/vagrant/learning_chef/.chef/

chown -R vagrant:vagrant /home/vagrant/learning_chef

echo "10.1.1.10 chef-server.test" | tee -a /etc/hosts

echo "Your Chef workstation is ready!"
EOF

def set_hostname(server)
  server.vm.provision 'shell', inline: "hostname #{server.vm.hostname}"
end

Vagrant.configure(2) do |config|
  config.vm.define 'chef-server' do |cs|
    cs.vm.box = 'bento/ubuntu-14.04'
    cs.vm.box_version = '2.2.9'
    cs.vm.hostname = 'chef-server.test'
    cs.vm.network 'private_network', ip: '10.1.1.10'
    cs.vm.provision 'shell', inline: CHEF_SERVER_SCRIPT.dup
    set_hostname(cs)

    cs.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define 'node' do |n|
    n.vm.box = 'bento/ubuntu-14.04'
    n.vm.box_version = '2.2.9'
    n.vm.hostname = 'node'
    n.vm.network 'private_network', ip: '10.1.1.11'
    n.vm.provision :shell, inline: NODE_SCRIPT.dup
    set_hostname(n)
  end
  
  config.vm.define 'workstation' do |w|
    w.vm.box = 'bento/ubuntu-14.04'
    w.vm.box_version = '2.2.9'
    w.vm.hostname = 'workstation'
    w.vm.network 'private_network', ip: '10.1.1.12'
	w.vm.provision :shell, inline: WORKSTATION_SCRIPT.dup
    set_hostname(w)
  end
end