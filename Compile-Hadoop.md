# Ubuntu22.04.1 LTS,  Compiling hadoop src
# 安裝 openjdk-8-jdk和compile依賴
~~~
sudo apt update
sudo apt upgrade
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
sudo apt install libsnappy-dev
sudo apt install zstd
sudo apt install bzip2
sudo apt install openssl
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
sudo apt install bzip2 libbz2-dev
sudo apt install fuse libfuse-dev
sudo apt install libzstd-dev
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
