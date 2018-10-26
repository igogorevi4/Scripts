#!/bin/bash

# Run kafka server for test environment
# Official kafka documentation
# https://kafka.apache.org/quickstart

# get kafka from kafka-mirror
cd /usr/local/bin/ && wget http://mirror.linux-ia64.org/apache/kafka/2.0.0/kafka_2.11-2.0.0.tgz && \
tar -xzf kafka_2.11-2.0.0.tgz && \
# remove tmp file
rm kafka_2.11-2.0.0.tgz && \
cd kafka_2.11-2.0.0

# At first you should run zookeeper-server
bin/zookeeper-server-start.sh config/zookeeper.properties 2>&1 > /var/log/zookeeper-server.log &

# ... and then kafka-server 
bin/kafka-server-start.sh config/server.properties 2>&1 > /var/log/kafka-server.log &

# Create first topic with 3 partitions and TTL=1 day 
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 3 --topic teskKafka retention.ms=86400000

# Check if topic has been created
bin/kafka-topics.sh --list --zookeeper localhost:2181