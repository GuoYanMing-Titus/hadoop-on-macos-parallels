# hadoop-on-ubuntu-based-on-Parallels-Desktop
1. install Linux
2. install JAVA JDK 8
~~~
sudo apt-get update
sudo apt install openjdk-8-jdk
~~~
3. insert $JAVA_HOME into enveronment
~~~
sudo vi /etc/environment
~~~
~~~
JAVA_HOME="/usr/lib/jvm/java-8-openjdk-arm64/jre/bin/java"
~~~
4. reload env
~~~
source /etc/environment
~~~
5. check up
~~~
echo $JAVA_HOME
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


