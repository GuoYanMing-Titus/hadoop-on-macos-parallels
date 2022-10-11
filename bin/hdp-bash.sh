#!/bin/bash
# titus setting
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
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
# export LD_LIBRARY_PATH=/usr/local/lib
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
