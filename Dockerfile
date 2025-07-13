ARG BITNAMI_TAG=16.6.0-debian-12-r3

FROM docker.io/bitnami/postgresql-repmgr:${BITNAMI_TAG}
ADD "https://github.com/tensorchord/VectorChord/releases/download/0.3.0/postgresql-13-vchord_0.3.0-1_arm64.deb" /tmp/vchord.deb
USER root
RUN apt-get install -y /tmp/vchord.deb && rm -f /tmp/vchord.deb && \
     mv /usr/lib/postgresql/*/lib/{vchord,vectors}.so /opt/bitnami/postgresql/lib/ && \
     mv usr/share/postgresql/*/extension/vchord* opt/bitnami/postgresql/share/extension/
USER 1001
ENV POSTGRESQL_EXTRA_FLAGS="-c shared_preload_libraries='vchord.so, vectors.so'"

