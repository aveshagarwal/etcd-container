FROM rhel

MAINTAINER Avesh Agarwal <avagarwa@redhat.com>

ENV container=docker

LABEL Vendor="Red Hat" \
      BZComponent="etcd-docker" \
      Name="rhel7/etcd" \
      Version="2.3.7" \
      Release="5" \
      Architecture="x86_64" \
      Summary="A highly-available key value store for shared configuration"

RUN yum-config-manager --add-repo=http://download.eng.rdu2.redhat.com/nightly/latest-EXTRAS-7-RHEL-7/compose/Server/x86_64/os/ &&\
yum-config-manager --add-repo=http://download.eng.rdu2.redhat.com/nightly/latest-RHEL-7/compose/Server/x86_64/os/ &&\
yum -y --nogpgcheck install etcd hostname &&\
yum clean all

LABEL INSTALL /usr/bin/docker run --rm \$OPT1 --privileged -v /:/host -e HOST=/host -e NAME=\$NAME -e IMAGE=\$IMAGE \$IMAGE \$OPT2 /usr/bin/install.sh  \$OPT3
LABEL UNINSTALL /usr/bin/docker run --rm \$OPT1 --privileged -v /:/host -e HOST=/host -e NAME=\$NAME -e IMAGE=\$IMAGE \$IMAGE \$OPT2 /usr/bin/uninstall.sh \$OPT3
LABEL RUN /usr/bin/docker run -d \$OPT1 -p 4001:4001 -p 7001:7001 -p 2379:2379 -p 2380:2380 --name \$NAME \$IMAGE \$OPT2 \$OPT3

ADD etcd_container_template.service /etc/systemd/system/etcd_container_template.service
ADD etcd-env.sh /usr/bin/etcd-env.sh
ADD install.sh  /usr/bin/install.sh
ADD uninstall.sh /usr/bin/uninstall.sh

EXPOSE 4001 7001 2379 2380

ADD tmpfiles.template config.json.template service.template manifest.json /exports/

CMD ["/usr/bin/etcd-env.sh", "/usr/bin/etcd"]
