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
sudo reboot
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

# 安裝openjdk-8-jdk
~~~
sudo apt update
sudo apt upgrade
~~~
~~~
sudo apt -y install openjdk-8-jdk
~~~

# 設定環境變數
~~~
sudo vim /etc/profile
~~~
~~~
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
export LD_LIBRARY_PATH=/usr/local/lib
export PATH=${PATH}:/home/titus/vmhdp-mac/bin
~~~
~~~
source /etc/profile
~~~
~~~
echo $JAVA_HOME
echo $LD_LIBRARY_PATH
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
scp ~/.ssh/id_rsa.pub dtm1:/home/titus/
scp ~/.ssh/id_rsa.pub dtm2:/home/titus/
scp ~/.ssh/id_rsa.pub dtw1:/home/titus/
scp ~/.ssh/id_rsa.pub dtw2:/home/titus/
scp ~/.ssh/id_rsa.pub dtw3:/home/titus/
~~~
3. login dtm1, dtm2, dtw1, dtw2, dtw3, append key(from master) to authorized_keys
~~~
ssh dtm1
~~~
~~~
cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
rm ~/id_rsa.pub
~~~

4.back to dta1(master), try ssh to others, it should not need passwd.
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



# download package
1. git clone
~~~
git clone git@github.com:GuoYanMing-Titus/vmhdp-mac.git
~~~
~~~
cd vmhdp-mac/
~~~
執行tiwage 並帶入參數第幾版
~~~
tiwget 1
~~~
# special for hadoop
因為hadoop 64bit需要自己compile
這邊我們編譯好利用scp傳送至dta1
這邊是在本地終端下指令
~~~
scp hadoop-3.3.4.tar.gz dta1:/home/titus/hdp1/opt/
~~~
這邊是在dta1下指令
~~~
tar xvzf /home/titus/hdp1/opt/hadoop-3.3.4.tar.gz -C /home/titus/hdp1/opt/
~~~

# copy /heme/titus/hdp1/opt/* 到每一台虛擬機/opt/
執行ticopy
~~~
ticopy 1
~~~

# 設定Hadoop環境變數
~~~
vim /etc/profile
~~~
加入
~~~
# titus setting
export JAVA_HOME=/opt/jdk1.8.0_341
export PATH=${PATH}:${JAVA_HOME}/bin
# set self bin
export PATH=${PATH}:/home/titus/vmhdp-mac/bin
# set hadoop
export HADOOP_HOME=/opt/hadoop-3.3.4
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_LOG_DIR=/tmp
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
[ -z $HADOOP_USER_NAME ] && [ $SHELL == '/bin/bash' ] && declare -r HADOOP_USER_NAME=$USER


export YARN_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export YARN_LOG_DIR=/tmp

export HADOOP_ROOT_LOGGER="WARN,console"
export PIG_HOME=/opt/pig-0.17.0
export PIG_HEAPSIZE=512
export HIVE_HOME=/opt/apache-hive-3.1.3-bin

export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PIG_HOME/bin:$HIVE_HOME/bin

export HBASE_HOME=/opt/hbase-2.4.14
export HBASE_CONF_DIR=/opt/hbase-2.4.14/conf
export ZOOKEEPER_HOME=/opt/apache-zookeeper-3.6.3-bin
export ZOO_LOG_DIR=/tmp/logs
export PATH=$PATH:$ZOOKEEPER_HOME/bin:$HBASE_HOME/bin

export FLUME_HOME=/opt/apache-flume-1.10.1-bin
export PATH=$PATH:$FLUME_HOME/bin

export ZEPPELIN_HOME=/opt/zeppelin-0.10.1-bin-all
export PATH=$PATH:$ZEPPELIN_HOME/bin

export SPARK_HOME=/opt/spark-3.2.2-bin-hadoop3.2
export SPARK_CONF_DIR=$SPARK_HOME/conf
export PYSPARK_PYTHON=/usr/bin/python3
export PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
~~~
# 編輯vmhdp-mac/conf/hadoop/core-site.xml
~~~
<configuration>
	<property>
		<name>fs.defaultFS</name>
		<value>hdfs://dtm1:8020</value>
	</property>
	<describe>hdfs master node serve port.</describe>
	<property>
		<name>io.file.buffer.size</name>
		<value>4096</value>
	</property>
	<property>
    <name>io.compression.codecs</name>
    <value>org.apache.hadoop.io.compress.BZip2Codec,org.apache.hadoop.io.compress.GzipCodec</value>
  </property>

<!-- 暫時不需要設定, 有增加使用者再來設定, override 群組設定.
	<property>
    <name>hadoop.user.group.static.mapping.overrides</name>
    <value>hbase=bigboss;rbean=soup;gbean=soup,rice;ybean=rice</value>
  </property>
-->
	<!--
   以下是設定 HttpFs 服務, HttpFs 必須用 root 啟動

   WebHDFS vs HttpFs Major difference between WebHDFS and HttpFs: WebHDFS needs access
   to all nodes of the cluster and when some data is read it is transmitted from that node directly,
   whereas in HttpFs, a singe node will act similar to a "gateway" and will be a single point of data
   transfer to the client node. So, HttpFs could be choked during a large file transfer but the
   good thing is that we are minimizing the footprint required to access HDFS
 -->
 	<property>
    <name>hadoop.security.authorization</name>
    <value>true</value>
 	</property>

 	<property>
    <name>hadoop.proxyuser.root.groups</name>
    <value>*</value>
 	</property>

 	<property>
    <name>hadoop.proxyuser.root.hosts</name>
    <value>*</value>
	</property>
</configuration>
~~~
# 編輯vmhdp-mac/conf/hadoop/hdfs-site.xml
~~~
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>2</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/home/titus/nn</value>
  </property>
  <property>
    <name>dfs.namenode.checkpoint.dir</name>
    <value>file:/home/titus/sn</value>
  </property>
  <property>
    <name>dfs.namenode.checkpoint.period</name>
    <value>360</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/home/titus/dn</value>
  </property>
</configuration>
~~~
# 編輯vmhdp-mac/conf/hadoop/yarn-site.xml
~~~
<configuration>

<!-- Site specific YARN configuration properties -->
  <property>
    <name>yarn.resourcemanager.webapp.address</name>
    <value>dtm2:8088</value>
		<describe>{yarn.resourcemanager.hostname}:8088</describe>
  </property>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>dtm2</value>
  </property>
  <property>
    <name>yarn.nodemanager.local-dirs</name>
    <value>/home/titus/yarn</value>
  </property>
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce_shuffle</value>
	</property>

  <property>
    <name>yarn.nodemanager.vmem-check-enabled</name>
    <value>false</value>
  </property>
  <property>
    <name>yarn.nodemanager.pmem-check-enabled</name>
    <value>false</value>
  </property>
  <property>
    <name>yarn.scheduler.minimum-allocation-mb</name>
    <value>384</value>
  </property>
  <property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>896</value>
  </property>
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>2048</value>
  </property>
  <property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>2</value>
  </property>
  <property>
    <name>yarn.scheduler.maximum-allocation-vcores</name>
    <value>1</value>
  </property>
</configuration>
~~~
# 編輯vmhdp-mac/conf/hadoop/mapred-site.xml
~~~
<configuration>
  <property>
    <name>mapreduce.jobhistory.address</name>
    <value>dtm2:10020</value>
		<describe>default is 0.0.0.0:10020</describe>
  </property>
  <property>
     <name>mapreduce.framework.name</name>
     <value>yarn</value>
   </property>
  <property> 
      <name>mapreduce.application.classpath</name>
      <value>/opt/hadoop-3.3.4/share/hadoop/mapreduce/*,/opt/hadoop-3.3.4/share/hadoop/mapreduce/lib/*,/opt/hadoop-3.3.4/share/hadoop/common/*,/opt/hadoop-3.3.4/share/hadoop/common/lib/*,/opt/hadoop-3.3.4/share/hadoop/yarn/*,/opt/hadoop-3.3.4/share/hadoop/yarn/lib/*,/opt/hadoop-3.3.4/share/hadoop/hdfs/*,/opt/hadoop-3.3.4/share/hadoop/hdfs/lib/*</value>
   </property>

   <property>
      <name>yarn.app.mapreduce.am.resource.mb</name>
      <value>384</value>
   </property>
   <property>
      <name>yarn.app.mapreduce.am.command-opts</name>
      <value>-Xmx256m</value>
   </property>

   <property>
      <name>mapreduce.reduce.memory.mb</name>
      <value>512</value>
   </property>
   <property>
      <name>mapreduce.reduce.java.opts</name>
      <value>-Xmx384m</value>
   </property>
   <property>
      <name>mapreduce.map.memory.mb</name>
      <value>384</value>
   </property>
   <property>
      <name>mapreduce.map.java.opts</name>
      <value>-Xmx256m</value>
   </property>

</configuration>
~~~
# 執行ticonfig, 將vmhdp-mac/conf 參數送到各個虛擬機
~~~
ticonfig
~~~
# reboot All.









applying all changes by source command.
~~~
source ~/.bashrc
~~~
check up
~~~
echo $HADOOP_HOME
hadoop version
~~~





core-site.xml
<property>
 21     <name>fs.defaultFS</name>
 22     <value>hdfs://dtm1:8020</value>
 23   </property>
 24   <describe>hdfs master node serve port.</describe>

 hdfs-site








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

