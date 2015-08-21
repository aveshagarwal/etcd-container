FROM rhel7

MAINTAINER Avesh Agarwal <avagarwa@redhat.com>

ENV container=docker \
    ETCD_NAME=default \
    ETCD_DATA_DIR=/var/lib/etcd/default.etcd \
    ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379,http://0.0.0.0:4001 \
    ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379,http://0.0.0.0:4001 \
    ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380,http://0.0.0.0:7001 \
    ETCD_INITIAL_ADVERTISE_PEER_URLS=http://0.0.0.0:2380,http://0.0.0.0:7001 \
    ETCD_INITIAL_CLUSTER=default=http://0.0.0.0:2380,default=http://0.0.0.0:7001

LABEL Vendor="Red Hat" \
      BZComponent="etcd-docker" \
      Name="rhel7/etcd" \
      Version="1.0" \
      Release="1" \
      Architecture="x86_64"

RUN yum -y update && \
    yum -y --enablerepo rhel-7-server-extras-rpms install etcd && \
    yum clean all

LABEL INSTALL /usr/bin/docker run --rm \$OPT1 --privileged -v /:/host -e HOST=/host -e NAME=\$NAME -e IMAGE=\$IMAGE \$IMAGE \$OPT2 /usr/bin/install.sh \$OPT3
LABEL UNINSTALL /usr/bin/docker run --rm \$OPT1 --privileged -v /:/host -e HOST=/host -e NAME=\$NAME -e IMAGE=\$IMAGE \$IMAGE \$OPT2 /usr/bin/uninstall.sh \$OPT3
LABEL RUN /usr/bin/docker run -d \$OPT1 -p 4001:4001 -p 7001:7001 -p 2379:2379 -p 2380:2380 --name \$NAME \$IMAGE \$OPT2 /usr/bin/etcd \$OPT3

ADD root /

EXPOSE 4001 7001 2379 2380

CMD ["/usr/bin/etcd"]
