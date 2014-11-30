# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT

root="root"

function myEcho {
echo -e "\e[34m$1\e[39m"
}

function nodejs {
   myEcho "____________________"
   myEcho "Provisioning NodeJS "
   myEcho "____________________"
   apt-add-repository -y ppa:chris-lea/node.js
   apt-get -y update
   apt-get -y install nodejs
   mkdir /home/vagrant/.npm-packages
}

function nginx {
   myEcho "____________________"
   myEcho "Provisioning Nginx  "
   myEcho "____________________"
   add-apt-repository -y ppa:nginx/stable
   apt-get -y update
   apt-get install -y nginx
   cat > /etc/nginx/sites-available/default << EOF

server {
        listen 80 default_server;
        root /vagrant;

        location / {
                try_files  $uri $uri/ /index.php$is_args$args;
        }

        location ~ .php$ {
               try_files $uri /index.php =404;
               fastcgi_pass 127.0.0.1:9000;
               fastcgi_index index.php;
               fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
               include fastcgi_params;
        }
        location ~ \.(ico|css|js|gif|jpg|jpeg|png|gz|ttf|woff|svg|eot|json) {
                expires max;
                add_header Pragma public;
                add_header Cache-Control "public, must-revalidate, proxy-revalidate";
                add_header X-Powered-By "NodeJS";
        }
        location ~ \.(html|html\.gz) {
                expires modified +2h;
                add_header Pragma public;
                add_header Cache-Control "public, must-revalidate, proxy-revalidate";
                add_header X-Powered-By "NodeJS";
        }
}


EOF
   service nginx restart
}

function php {
   myEcho "____________________"
   myEcho "Provisioning Php    "
   myEcho "____________________"
   apt-get install -y php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-gmp php5-mcrypt php5-xdebug php5-memcached php5-imagick php5-intl
   # Set PHP FPM to listen on TCP instead of Socket
   sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php5/fpm/pool.d/www.conf
   # Set PHP FPM allowed clients IP address
   sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php5/fpm/pool.d/www.conf
   service nginx restart
}

function mysql {
   myEcho "____________________"
   myEcho "Provisioning MySQL  "
   myEcho "____________________"
   debconf-set-selections <<< "mysql-server mysql-server/root_password password $root"
   debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $root"
   apt-get install -y mysql-server
   sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
   service mysql restart

   # create the backup crontab
   (crontab -u vagrant -l ; echo "00 16 * * * /vagrant/mysetup/backup-mysql.sh") | crontab -u vagrant -
}

myEcho "____________________"
myEcho "I am provisioning..."
myEcho "____________________"
echo deb http://archive.ubuntu.com/ubuntu  trusty            main universe multiverse              > /etc/apt/sources.list
echo deb http://archive.ubuntu.com/ubuntu  trusty-updates    main universe multiverse              >>/etc/apt/sources.list
echo deb http://archive.ubuntu.com/ubuntu  trusty-backports  main restricted universe multiverse   >>/etc/apt/sources.list
echo deb http://security.ubuntu.com/ubuntu trusty-security   main universe multiverse              >>/etc/apt/sources.list

apt-get -y update
apt-get -y dist-upgrade
apt-get -y install curl python g++ make checkinstall binutils gcc patch software-properties-common vim mc sqlite git

while test $# -gt 0
do
   case "$1" in
      nodejs)  nodejs
      ;;
      nginx)   nginx
      ;;
      php)     php
      ;;
      mysql)   mysql
      ;;
      *) echo "Bad option $1"
      ;;
    esac
    shift
done

apt-get -y autoremove
apt-get -y autoclean
git clone https://github.com/itwars/mysetup
cp /home/vagrant/mysetup/.tmux.conf /home/vagrant/
cp /home/vagrant/mysetup/.bashrc    /home/vagrant/
cp /home/vagrant/mysetup/.vimrc     /home/vagrant/
cp /home/vagrant/mysetup/.gemrc     /home/vagrant/
cp /home/vagrant/mysetup/.gitconfig /home/vagrant/
cd /home/vagrant/mysetup
wget https://raw.githubusercontent.com/rupa/z/master/z.sh
git clone https://github.com/gmarik/Vundle.vim.git /home/vagrant/.vim/bundle/Vundle.vim
timedatectl set-timezone Europe/Paris
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
   config.vm.define "MyVagrantBox" do "MyVagrantBox"
   end
   config.vm.box = "trusty64-LTS"
   config.vm.provision "shell", inline: $script , args: ["nginx","php","mysql","nodejs"]
   config.vm.network :forwarded_port, guest: 3000, host: 3000
   config.vm.network :forwarded_port, guest: 80, host: 8080
   config.vm.network :forwarded_port, guest: 3001, host: 3001
   config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--chipset", "ich9"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
   end
end
