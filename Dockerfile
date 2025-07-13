ARG BITNAMI_TAG=16.6.0-debian-12-r3

FROM docker.io/bitnami/postgresql-repmgr:${BITNAMI_TAG}
USER root
ADD "https://github.com/tensorchord/pgvecto.rs/releases/download/v0.3.0/vectors-pg16_0.3.0_arm64.deb" /tmp/vectors.deb
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && \
     mv /usr/lib/postgresql/*/lib/vectors.so /opt/bitnami/postgresql/lib/ && \
     mv usr/share/postgresql/*/extension/vectors* opt/bitnami/postgresql/share/extension/
ADD "https://apt.postgresql.org/pub/repos/apt/pool/main/p/pgvector/postgresql-16-pgvector_0.8.0-1.pgdg20.04%2B1_arm64.deb" /tmp/pgvector.deb
RUN dpkg -x /tmp/pgvector.deb pgvector && rm -f /tmp/pgvector.deb && \
     mv pgvector/usr/lib/postgresql/*/lib/vector.so /opt/bitnami/postgresql/lib/ && \
     mv pgvector/usr/share/postgresql/*/extension/* opt/bitnami/postgresql/share/extension/ && \
     rm -rf pgvector
ADD "https://github.com/tensorchord/VectorChord/releases/download/0.3.0/postgresql-16-vchord_0.3.0-1_arm64.deb" /tmp/vchord.deb
RUN apt-get install -y /tmp/vchord.deb && rm -f /tmp/vchord.deb && \
     mv /usr/lib/postgresql/*/lib/vchord.so /opt/bitnami/postgresql/lib/ && \
     mv usr/share/postgresql/*/extension/vchord* opt/bitnami/postgresql/share/extension/
USER 1001
ENV POSTGRESQL_EXTRA_FLAGS="-c shared_preload_libraries='vchord.so, vectors.so, vector.so'"

