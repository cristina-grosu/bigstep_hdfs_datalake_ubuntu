FROM mcristinagrosu/bigstep_java

RUN apk add --no-cache wget tar

RUN source ~/.bashrc
# Install Hadoop 2.7.1
RUN cd /opt && wget https://www.apache.org/dist/hadoop/core/hadoop-2.7.1/hadoop-2.7.1.tar.gz && \
    tar xzvf hadoop-2.7.1.tar.gz && rm ./hadoop-2.7.1.tar.gz &&  mv hadoop-2.7.1/ /opt/hadoop

RUN mkdir -p /dfs && mkdir -p /dfs/nn && mkdir -p /dfs/dn 

ADD core-site.xml /opt/hadoop/etc/hadoop/core-site.xml.template
ADD krb5.conf /etc/krb5.conf

# NameNode                      Secondary NameNode  DataNode                     JournalNode  NFS Gateway    HttpFS         ZKFC  YARN    Spark
EXPOSE 8020 8031 8032 8033 8042 50070 50470   50090 50495    19888     50010 1004 50075 1006 50020  8485 8480    2049 4242 111  14000 14001    8019  8088    7077

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod 777 /opt/entrypoint.sh

RUN rm -rf /var/cache/apk/* && apk del wget tar

ENTRYPOINT ["/opt/entrypoint.sh"]
