#!/bin/bash

export JAVA_HOME="/opt/jdk"                                                                                                                               
export PATH="$PATH:/opt/jdk/bin:/opt/jdk/jre/bin"
export HADOOP_HOME="/opt/hadoop"
export PATH="$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin"
export HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"
export HADOOP_PREFIX="$HADOOP_HOME"
export HADOOP_SBIN_DIR="$HADOOP_HOME/sbin"
export HADOOP_SBIN_DIR="$HADOOP_HOME/bin"
export HADOOP_CLASSPATH="$HADOOP_CLASSPATH:$HADOOP_HOME/share/hadoop/common/"
export JAVA_CLASSPATH="$JAVA_CLASSPATH:$JAVA_HOME/jre/lib/"
export JAVA_OPTS="-Dsun.security.krb5.debug=true"

rm -rf /opt/hadoop/etc/hadoop/core-site.xml

if [ "$HOSTNAME_MASTER" != "" ]; then
	sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/core-site.xml.template >> /opt/hadoop/etc/hadoop/core-site.xml
else
  	HOSTNAME=$(hostname -f)
	sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/core-site.xml.template >> /opt/hadoop/etc/hadoop/core-site.xml
fi

if [ "$DATALAKE_USER" != "" ]; then
	sed "s/DATALAKE_USER/$DATALAKE_USER/" /opt/hadoop/etc/hadoop/core-site.xml >> /opt/hadoop/etc/hadoop/core-site.xml.tmp && \
	mv /opt/hadoop/etc/hadoop/core-site.xml.tmp /opt/hadoop/etc/hadoop/core-site.xml
fi

if [ "$KEYTAB_PATH" != "" ]; then
	sed "s/KEYTAB_PATH/${KEYTAB_PATH}/" /opt/hadoop/etc/hadoop/core-site.xml >> /opt/hadoop/etc/hadoop/core-site.xml.tmp && \
	mv /opt/hadoop/etc/hadoop/core-site.xml.tmp /opt/hadoop/etc/hadoop/core-site.xml
fi

if [ "$USER_HOME_DIR" != "" ]; then
	sed "s/USER_HOME_DIR/$USER_HOME_DIR/" /opt/hadoop/etc/hadoop/core-site.xml >> /opt/hadoop/etc/hadoop/core-site.xml.tmp && \
	mv /opt/hadoop/etc/hadoop/core-site.xml.tmp /opt/hadoop/etc/hadoop/core-site.xml
fi

if [ "$CONTAINER_DIR" != "" ]; then
	cp $CONTAINER_DIR/datalake-1.1-SNAPSHOT.jar $HADOOP_CLASSPATH 
    	cp $CONTAINER_DIR/datalake-1.1-SNAPSHOT.jar $JAVA_CLASSPATH
    	cp $CONTAINER_DIR/.k5keytab $KEYTAB_PATH
fi

if [ "$MODE" = "" ]; then
	MODE=$1
fi

if [ "$MODE" == "headnode" ]; then 
	/opt/hadoop/bin/hdfs namenode -format
	/opt/hadoop/bin/hadoop namenode

elif [ "$MODE" == "datanode" ]; then
	/opt/hadoop/bin/hadoop datanode

else
	/opt/hadoop/bin/hdfs namenode -format
	/opt/hadoop/bin/hadoop namenode
fi
