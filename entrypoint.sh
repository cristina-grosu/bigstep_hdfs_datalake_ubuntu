#!/bin/bash

HADOOP_HOME="/opt/hadoop"
HADOOP_SBIN_DIR="/opt/hadoop/sbin"
HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
YARN_CONF_DIR="/opt/hadoop/etc/hadoop"

. "/root/.bashrc"
if [ "$HOSTNAME_MASTER" != "" ]; then
	sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml
	#sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/mapred-site.xml.template > /opt/hadoop/etc/hadoop/mapred-site.xml
	#sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/yarn-site.xml.template > /opt/hadoop/etc/hadoop/yarn-site.xml	
	sed "s/HOSTNAME_MASTER/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/slaves
elif [ "$HOSTNAME" = "" ]; then
  HOSTNAME=`hostname -f`
  sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml
  #sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/mapred-site.xml.template > /opt/hadoop/etc/hadoop/mapred-site.xml
  #sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/yarn-site.xml.template > /opt/hadoop/etc/hadoop/yarn-site.xml
fi

if [ "$HOSTNAME_SLAVE" != "" ]; then
	sed "s/HOSTNAME_SLAVE/$HOSTNAME_SLAVE/" /opt/hadoop/etc/hadoop/slaves
fi

if [ "$MODE" = "" ]; then
	MODE=$1
fi

if [ "$MODE" == "headnode" ]; then 
	/opt/hadoop/bin/hdfs namenode -format
	hadoop namenode
	#${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --hostnames "hdfsmaster.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	#yarn --config $YARN_CONF_DIR resourcemanager

elif [ "$MODE" == "datanode" ]; then
	#${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --script "/opt/hadoop/bin/hdfs" start datanode
	hadoop datanode
	#yarn --config $YARN_CONF_DIR nodemanager
else
	/opt/hadoop/bin/hdfs namenode -format
	hadoop namenode
	#${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --hostnames "hdfsmaster.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	#${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --script "/opt/hadoop/bin/hdfs" start datanode
	#yarn --config $YARN_CONF_DIR resourcemanager
fi
