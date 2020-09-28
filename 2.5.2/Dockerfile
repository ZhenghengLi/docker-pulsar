FROM openjdk:8-jre-slim

ARG PS_VERSION=2.5.2
ARG DISTRO_NAME=apache-pulsar-${PS_VERSION}-bin
ARG DISTRO_URL=https://archive.apache.org/dist/pulsar/pulsar-${PS_VERSION}/${DISTRO_NAME}.tar.gz

ENV ZK_SERVERS=localhost:2181 \
    ZK_CHROOT=ledgers \
    PULSAR_LOG_DIR=/pulsar/logs \
    PULSAR_BROKER_CONF_DIR=/pulsar/conf \
    PULSAR_CLUSTER_NAME=pulsar-cluster \
    PULSAR_BROKER_SERVICE_PORT=6650 \
    PULSAR_WEB_SERVICE_PORT=6680 \
    PULSAR_ADVERTISED_ADDRESS=localhost \
    PULSAR_ALLOW_AUTO_TOPIC_CREATION=true \
    PULSAR_ALLOW_AUTO_TOPIC_CREATION_TYPE=non-partitioned \
    PULSAR_DEFAULT_NUM_PARTITIONS=1 \
    PULSAR_SUBSCRIPTION_EXPIRATION_MINUTES=5

RUN set -x \
# install dependencies
&& sed -i "s/deb.debian.org/mirrors.huaweicloud.com/g" /etc/apt/sources.list \
&& sed -i "s/security.debian.org/mirrors.huaweicloud.com/g" /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y --no-install-recommends ca-certificates netcat wget gnupg \
# download and check
&& mkdir -pv /opt/tmp\
&& cd /opt/tmp \
&& wget -q "${DISTRO_URL}" \
# && wget -q "${DISTRO_URL}.asc" \
&& wget -q "${DISTRO_URL}.sha512" \
&& sha512sum -c ${DISTRO_NAME}.tar.gz.sha512 \
# && wget -q https://dist.apache.org/repos/dist/release/pulsar/KEYS \
# && gpg --import KEYS \
# && gpg --batch --verify "${DISTRO_NAME}.tar.gz.asc" "${DISTRO_NAME}.tar.gz" \
# untar
&& tar -xzf "${DISTRO_NAME}.tar.gz" \
&& mv -v "apache-pulsar-${PS_VERSION}" .. \
&& cd .. \
&& rm -rf tmp \
# clean
&& apt-get autoremove -y wget gnupg \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
# set root password for runtime debug
&& echo "root:20180427" | chpasswd \
## add default work user
&& groupadd pulsar --gid=1000 \
&& useradd -m -g pulsar --uid=1000 pulsar \
# create data directories
&& mkdir -pv "${PULSAR_BROKER_CONF_DIR}" "${PULSAR_LOG_DIR}" \
# change owner
&& chown -R pulsar:pulsar "${PULSAR_BROKER_CONF_DIR}" "${PULSAR_LOG_DIR}" \
&& chmod 777 "${PULSAR_BROKER_CONF_DIR}" "${PULSAR_LOG_DIR}"

COPY entrypoint.sh check_cnxn_address.sh /scripts/

ENV PATH=/scripts:/opt/"apache-pulsar-${PS_VERSION}"/bin:$PATH \
    PULSAR_BROKER_CONF="${PULSAR_BROKER_CONF_DIR}/broker.conf"

USER pulsar

ENTRYPOINT [ "/bin/bash", "/scripts/entrypoint.sh" ]
CMD ["pulsar", "broker"]
