#!/bin/bash

# Generate the config only if it doesn't exist
if [[ ! -f "$PULSAR_BROKER_CONF" ]]; then
    {
        echo "zookeeperServers=$ZK_SERVERS/$ZK_CHROOT"
        echo "configurationStoreServers=$ZK_SERVERS/$ZK_CHROOT"
        echo "clusterName=$PULSAR_CLUSTER_NAME"
        echo "brokerServicePort=$PULSAR_BROKER_SERVICE_PORT"
        echo "webServicePort=$PULSAR_WEB_SERVICE_PORT"
        echo "advertisedAddress=$PULSAR_ADVERTISED_ADDRESS"
        echo "allowAutoTopicCreation=$PULSAR_ALLOW_AUTO_TOPIC_CREATION"
        echo "allowAutoTopicCreationType=$PULSAR_ALLOW_AUTO_TOPIC_CREATION_TYPE"
        echo "defaultNumPartitions=$PULSAR_DEFAULT_NUM_PARTITIONS"
        echo "managedLedgerDefaultEnsembleSize=3"
        echo "managedLedgerDefaultWriteQuorum=2"
        echo "managedLedgerDefaultAckQuorum=2"
    } >> "$PULSAR_BROKER_CONF"
fi

exec "$@"
