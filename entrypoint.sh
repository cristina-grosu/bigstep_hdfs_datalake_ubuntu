#!/bin/bash

. "/root/.bashrc"
if [ "$HOSTNAME_MASTER" != "" ]; then
	sed "s/HOSTNAME/$HOSTNAME_MASTER/" /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml
elif [ "$HOSTNAME" = "" ]; then
  	HOSTNAME=`hostname -f`
  	sed "s/HOSTNAME/$HOSTNAME/" /opt/hadoop/etc/hadoop/core-site.xml.template > /opt/hadoop/etc/hadoop/core-site.xml
fi

if ["$DATALAKE_USER" != ""]; then
	sed "s/DATALAKE_USER/$DATALAKE_USER/" /opt/hadoop/etc/hadoop/core-site.xml > /opt/hadoop/etc/hadoop/core-site.xml
fi

if ["$KEYTAB_PATH" != ""]; then
	sed "s/KEYTAB_PATH/$KEYTAB_PATH/" /opt/hadoop/etc/hadoop/core-site.xml > /opt/hadoop/etc/hadoop/core-site.xml
fi

if ["$USER_HOME_DIR" != ""]; then
	sed "s/USER_HOME_DIR/$USER_HOME_DIR/" /opt/hadoop/etc/hadoop/core-site.xml > /opt/hadoop/etc/hadoop/core-site.xml
fi

if ["$CONTAINER_DIR" != ""]; then
	cp $CONTAINER_DIR/datalake-1.1-SNAPSHOT.jar $HADOOP_CLASSPATH 
    	cp $CONTAINER_DIR/datalake-1.1-SNAPSHOT.jar $JAVA_CLASSPATH
fi

if [ "$MODE" = "" ]; then
	MODE=$1
fi

if [ "$MODE" == "headnode" ]; then 
	/opt/hadoop/bin/hdfs namenode -format
	hadoop namenode
elif [ "$MODE" == "datanode" ]; then
	hadoop datanode
else
	/opt/hadoop/bin/hdfs namenode -format
	hadoop namenode
fi
