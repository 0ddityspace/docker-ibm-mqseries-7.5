FROM ubuntu:16.04

MAINTAINER  0ddity.space

ARG MQ_URL=https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev75_linux_x86-64.tar.gz

COPY *.sh /usr/local/bin/

RUN export DEBIAN_FRONTEND=noninteractive \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
                wget \
                bash \
                bc \
                ca-certificates \
                coreutils \
                debianutils \
                file \
                findutils \
                gawk \
                grep \
                libc-bin \
                lsb-release \
                mount \
                passwd \
                procps \
                sed \
                tar \
                util-linux \
                rpm \
        && cd /tmp \
        && wget $MQ_URL --no-check-certificate \
        && groupadd --gid 1000 mqm \
        && useradd --uid 1000 --gid mqm --home-dir /var/mqm mqm \
        && usermod -G mqm root \
        && chmod +x /usr/local/bin/*.sh \
        && tar xf *.tar.gz \
        && ./mqlicense.sh -text_only -accept \
        && rpm -ivh --nodeps --force-debian MQSeriesRuntime-*.rpm \
        && rpm -ivh --nodeps --force-debian MQSeriesServer-*.rpm \
        && ln -s /lib64 /usr/ \
        && /opt/mqm/bin/setmqinst -p /opt/mqm -i \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY *.mqsc /etc/mqm/

EXPOSE 1414 9443

CMD export LICENSE=accept && mq.sh
