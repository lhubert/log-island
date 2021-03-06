#!/bin/bash

:

rm /tmp/*.pid

# altering the core-site configuration
#sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml


/etc/init.d/nginx start
service sshd start

echo "starting kafka"
cd $KAFKA_HOME
#echo "host.name=sandbox" >> config/server.properties
nohup bin/zookeeper-server-start.sh config/zookeeper.properties > zookeeper.log 2>&1 &
JMX_PORT=10101 nohup bin/kafka-server-start.sh config/server.properties > kafka.log 2>&1 &

echo "starting kafka-manager"
cd $KAFKA_MGR_HOME
nohup bin/kafka-manager > kafka-manager.log 2>&1 &

echo "starting kibana"
cd $KIBANA_HOME
nohup bin/kibana > kibana.log 2>&1 &



#echo "create a kafka topic for log-island"
#sleep 5
#$KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic log-island


echo "to start go to /usr/local/log-island"
#cd $BOTSEARCH_HOME
#nohup bin/logindexer > log/logindexer.log 2>&1 &


echo "starting elasticsearch"
runuser -l  elastic -c '/usr/local/elasticsearch/bin/elasticsearch -d'




cd $BOTSEARCH_HOME


CMD=${1:-"exit 0"}
if [[ "$CMD" == "-d" ]];
then
	service sshd stop
	/usr/sbin/sshd -D -d
else
	/bin/bash -c "$*"
fi