#!/bin/bash


HADOOP_HOME="/opt/hadoop"
HADOOP_SBIN_DIR="/opt/hadoop/sbin"
HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"

. "/root/.bashrc"

if [ "$HOSTNAME" = "" ]; then
  HOSTNAME=`hostname -f`
fi

sed s/HOSTNAME/$HOSTNAME/ /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml

if [ "$MODE" = "" ]; then
MODE=$1
fi

if [ "$MODE" == "headnode" ]; then 
	
	/opt/hadoop/bin/hdfs namenode -format
	#${HADOOP_SBIN_DIR}/hadoop-daemons.sh --config "$HADOOP_CONF_DIR" --hostnames "spark.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --hostnames "hdfsmaster.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	
elif [ "$MODE" == "datanode" ]; then
	
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --script "/opt/hadoop/bin/hdfs" start datanode
	
else
	/opt/hadoop/bin/hdfs namenode -format
	#${HADOOP_SBIN_DIR}/hadoop-daemons.sh --config "$HADOOP_CONF_DIR" --hostnames "spark.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --hostnames "hdfsmaster.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --script "/opt/hadoop/bin/hdfs" start datanode
fi
Status 
