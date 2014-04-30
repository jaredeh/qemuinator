#export http_proxy=http://10.0.2.2:8888
#apt-get update
#apt-get -y install sudo
#cat /etc/sudoers | sed 's/root\tALL=(ALL:ALL) ALL/root\tALL = NOPASSWD: ALL\nuser\tALL = NOPASSWD: ALL/' > /etc/sudoers.new
#mv /etc/sudoers.new /etc/sudoers
#apt-get -y install default-jre
echo "freedom!"
uname -a