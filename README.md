# hadoop-on-ubuntu-based-on-Parallels-Desktop
# system setup
0. install Linux
1.建立vim設定檔
~~~
vi ~/.vimrc
~~~
add
~~~
set nu
set ai
set cursorline
set smartindent
set bg=light
set tabstop=2
set shiftwidth=2
~~~
2. change hostname
~~~
sudo vim /etc/hostname
~~~
~~~
reboot
~~~
3. set static ip
~~~
sudo vim /etc/netplan/00-installer-config.yaml
~~~
~~~
# This is the network config written by 'subiquity'
network:
  renderer: networkd
  ethernets:
    enp0s5:
      addresses: [ 10.211.55.10/24 ]
      dhcp4: false
      gateway4: 10.211.55.1
      nameservers:
        addresses: [ 10.211.55.1 ]
  version: 2
~~~
apply netplan
~~~
sudo netplan apply
~~~
4. 設定hosts
~~~
sudo vim /etc/hosts
~~~
加入
~~~
10.211.55.10 dta1
10.211.55.11 dtm1
10.211.55.12 dtm2
10.211.55.13 dtw1
10.211.55.14 dtw2
10.211.55.15 dtw3
~~~
5. 修改 /etc/sudoers
~~~
sudo vim /etc/sudoers
~~~
~~~
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL
~~~

# install JAVA JDK 8
先下載至mac, 利用scp指令傳到Linux虛擬機家目錄
~~~
sudo mkdir /opt/software
sudo mv /home/titus/jdk-8u341-linux-aarch64.tar.gz /opt/software/
~~~
~~~
cd /opt/software
~~~
~~~
sudo tar -zxvf jdk-8u341-linux-aarch64.tar.gz
~~~
~~~
sudo mv jdk1.8.0_341 ../
~~~
設定環境變數
~~~
vim /etc/profile
~~~
加入
~~~
export JAVA_HOME=/opt/jdk1.8.0_341
export PATH=${PATH}:${JAVA_HOME}/bin
~~~
更新變數
~~~
source /etc/profile
~~~
確認環境變數設定
~~~
which java
java -version
echo $JAVA_HOME
~~~

# 建立parallels 虛擬機副本
建立後，設定hostname和固定IP.

# 設定 rsa key
1. 只有master建立，make a rsa key,不設定密碼直接連續Enter
~~~
cd ~/.ssh
ssh-keygen -t rsa
~~~
~~~
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
~~~
2. scp pub key to dtm1/2,dtw1/2/3
~~~
scp ~/.ssh/id_rsa.pub titus@dtm1:/home/titus/
scp ~/.ssh/id_rsa.pub titus@dtm2:/home/titus/
scp ~/.ssh/id_rsa.pub titus@dtw1:/home/titus/
scp ~/.ssh/id_rsa.pub titus@dtw2:/home/titus/
scp ~/.ssh/id_rsa.pub titus@dtw3:/home/titus/
~~~
3. login dtm1, dtm2, dtw1, dtw2, dtw3, append key(from master) to authorized_keys
~~~
cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
~~~

4.back to dta1(master), try ssh to others.
~~~
ssh dtm1
exit
~~~
~~~
ssh dtm1 sudo cat /etc/sudoers
~~~

# create pub key for github
Create key
~~~
ssh-keygen -t ed25519 -C "your_email@example.com"
~~~
Start the ssh-agent in the background.
~~~
eval "$(ssh-agent -s)"
~~~
add key to ssh-agent
~~~
ssh-add ~/.ssh/id_ed25519
~~~
cat your key and copy it.
add it to github ssh key.
~~~
cat ~/.ssh/id_ed25519.pub
~~~
set git config
~~~
git config --global user.email "your email"
git config --global user.name "your name"
~~~



# download hadoop
1. run tihdpwget.sh
~~~
./tihdpwget.sh
~~~

edit the file etc/hadoop/hadoop-env.sh
~~~
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
~~~
Try the following command:
~~~
bin/hadoop
~~~
This will display the usage documentation for the hadoop script.

# Setup passphraseless ssh
Now check that you can ssh to the localhost without a passphrase:
~~~
ssh localhost
~~~
If you cannot ssh to localhost without a passphrase refer ref/setssh-guide.txt

# Configuring the Hadoop Daemons
1. etc/hadoop/core-site.xml

