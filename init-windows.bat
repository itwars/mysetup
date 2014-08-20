@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco install virtualbox vagrant git
vagrant plugin install vagrant-vbguest
git clone https://github.com/itwars/mysetup
copy mysetup\Vagrantfile .
git clone https://github.com/Lokaltog/powerline-fonts.git
