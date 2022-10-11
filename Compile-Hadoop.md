# Ubuntu22.04.1 LTS,  Compiling hadoop src
# 安裝 openjdk-8-jdk和compile依賴
~~~
sudo apt update
sudo apt-get purge openjdk*
~~~
~~~
sudo apt -y install openjdk-8-jdk
~~~
~~~
sudo apt -y install maven
~~~
~~~
sudo apt -y install build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev libsasl2-dev
~~~
指定特別版本, protobuf
~~~
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.7/protobuf-java-3.21.7.tar.gz
~~~
~~~
tar zxvf protobuf-java-3.21.7.tar.gz
~~~
~~~
cd protobuf-3.21.7
~~~
~~~
./configure
~~~
~~~
make -j$(nproc)
~~~
~~~
sudo make install
~~~

~~~
sudo apt -y install snapd
sudo apt -y install libsnappy-dev
sudo apt -y install zstd
sudo apt -y install bzip2
~~~
~~~
git clone https://github.com/intel/isa-l.git
cd isa-l/
~~~
~~~
./autogen.sh
./configure
make
sudo make install
~~~
~~~
sudo apt -y install bzip2 libbz2-dev
sudo apt -y install fuse libfuse-dev
sudo apt -y install libzstd-dev
sudo apt -y install libssl-dev
~~~
openssl 降版本
~~~
openssl version
wget https://ftp.openssl.org/source/openssl-1.1.1q.tar.gz
tar zxvf openssl-1.1.1q.tar.gz
cd openssl-1.1.1q
sudo ./config --prefix=/usr/local/ssl
sudo make
sudo make install
~~~
將原本的openssl重新命名
~~~
sudo mv -f /usr/bin/openssl /usr/bin/openssl.old
sudo mv -f /usr/include/openssl /usr/include/openssl.old
~~~
修改資源庫 link
~~~
sudo ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl 
sudo ln -s /usr/local/ssl/include/openssl /usr/include/openssl
~~~
修改conf
~~~
sudo vim /etc/ld.so.conf
~~~
加入
~~~
"/usr/local/ssl/lib"
~~~
~~~
sudo ldconfig -v
~~~
~~~
openssl version
~~~


# 設定環境變數
~~~
sudo vim /etc/profile
~~~
~~~
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
export LD_LIBRARY_PATH=/usr/local/lib
~~~
~~~
source /etc/profile
~~~
~~~
echo $JAVA_HOME
echo $LD_LIBRARY_PATH
~~~

# download hadoop-3.3.4-src
~~~
wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.4/hadoop-3.3.4-src.tar.gz
~~~
~~~
tar zxvf hadoop-3.3.4-src.tar.gz
~~~
~~~
cd hadoop-3.3.4-src/
~~~
~~~
mvn package -Pdist,native -DskipTests -Dtar
~~~
~~~
mvn clean package -Pdist,native -DskipTests -Dtar
~~~
