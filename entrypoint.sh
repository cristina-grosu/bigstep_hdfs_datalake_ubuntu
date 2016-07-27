#!/bin/bash

HADOOP_HOME="/opt/hadoop"
HADOOP_SBIN_DIR="/opt/hadoop/sbin"
HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
YARN_CONF_DIR="/opt/hadoop/etc/hadoop"

. "/root/.bashrc"
if [ "$HOSTNAME_MASTER" != "" ]; then
	sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml
	sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/mapred-site.xml.template > /opt/hadoop/etc/hadoop/mapred-site.xml
	sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/yarn-site.xml.template > /opt/hadoop/etc/hadoop/yarn-site.xml	
elif [ "$HOSTNAME" = "" ]; then
  HOSTNAME=`hostname -f`
  sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml
  sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/mapred-site.xml.template > /opt/hadoop/etc/hadoop/mapred-site.xml
  sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/yarn-site.xml.template > /opt/hadoop/etc/hadoop/yarn-site.xml
fi

#if [ -z $CLUSTER_NAME ]; then
#  CLUSTER_NAME="cluster"
#  export CLUSTER_NAME
#fi

#if [ -z $NNODE1_IP ] || [ -z $NNODE2_IP ]  || [ -z $ZK_IPS ] || [ -z $JN_IPS ]; then
#  echo NNODE1_IP, NNODE2_IP, JN_IPS and ZK_IPS needs to be set as environment addresses to be able to run.
#  exit;
#fi

#JNODES=$(echo $JN_IPS | tr "," ";")

#sed "s/CLUSTER_NAME/$CLUSTER_NAME/" /opt/hadoop/etc/hadoop/hdfs-site.xml.template \
#| sed "s/NNODE1_IP/$NNODE1_IP/" \
#| sed "s/NNODE2_IP/$NNODE2_IP/" \
#| sed "s/ZKNODES/$ZK_IPS/" \
#| sed "s/JNODES/$JNODES/" \
#> /opt/hadoop/etc/hadoop/hdfs-site.xml

####sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml
####sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/mapred-site.xml.template > /opt/hadoop/etc/hadoop/mapred-site.xml
####sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/yarn-site.xml.template > /opt/hadoop/etc/hadoop/yarn-site.xml

#echo CLUSTER_NAME=$CLUSTER_NAME NNODE1_IP=$NNODE1_IP NNODE2_IP=$NNODE2_IP JNODES=$JNODES ZK_IPS=$ZK_IPS

if [ "$MODE" = "" ]; then
	MODE=$1
fi

if [ "$MODE" == "headnode" ]; then 
	
	/opt/hadoop/bin/hdfs namenode -format
#	$HADOOP_PREFIX/sbin/hadoop-daemon.sh start zkfc
	#${HADOOP_SBIN_DIR}/hadoop-daemons.sh --config "$HADOOP_CONF_DIR" --hostnames "spark.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --hostnames "hdfsmaster.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	yarn --config $YARN_CONF_DIR resourcemanager
	
#elif [ "$MODE" == "standby" ]; then
#	$HADOOP_PREFIX/bin/hadoop namenode -bootstrapStandby
	
elif [ "$MODE" == "datanode" ]; then
	
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --script "/opt/hadoop/bin/hdfs" start datanode
	yarn --config $YARN_CONF_DIR nodemanager
else
	/opt/hadoop/bin/hdfs namenode -format
	#${HADOOP_SBIN_DIR}/hadoop-daemons.sh --config "$HADOOP_CONF_DIR" --hostnames "spark.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --hostnames "hdfsmaster.marathon.mesos" --script "/opt/hadoop/bin/hdfs" start namenode
	${HADOOP_SBIN_DIR}/hadoop-daemon.sh --config "$HADOOP_CONF_DIR" --script "/opt/hadoop/bin/hdfs" start datanode
	#hadoop --config "$HADOOP_CONF_DIR" datanode
	yarn --config $YARN_CONF_DIR resourcemanager
fi
