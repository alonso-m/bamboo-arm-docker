FROM arm32v7/adoptopenjdk:8-jdk-hotspot-bionic

ARG BAMBOO_VERSION=8.0.0
ENV BAMBOO_USER=bamboo
ENV BAMBOO_GROUP=bamboo
ENV BAMBOO_USER_HOME=/home/${BAMBOO_USER}
ENV BAMBOO_JMS_CONNECTION_PORT=54663

ENV BAMBOO_SERVER_HOME          /var/atlassian/application-data/bamboo
ENV BAMBOO_SERVER_INSTALL_DIR   /opt/atlassian/bamboo

# Expose HTTP and AGENT JMS ports
EXPOSE 8085
EXPOSE $BAMBOO_JMS_CONNECTION_PORT

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl git bash procps openssl libtcnative-1 maven

RUN addgroup ${BAMBOO_GROUP} && \
     adduser ${BAMBOO_USER} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --home ${BAMBOO_USER_HOME} --ingroup ${BAMBOO_GROUP} --disabled-password

ARG DOWNLOAD_URL=https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

RUN mkdir -p ${BAMBOO_SERVER_INSTALL_DIR}/lib/native && \
    mkdir -p ${BAMBOO_SERVER_HOME} && \
    ln --symbolic "/usr/lib/arm-linux-gnueabihf/libtcnative-1.so" "${BAMBOO_SERVER_INSTALL_DIR}/lib/native/libtcnative-1.so";

RUN curl -L --silent ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$BAMBOO_SERVER_INSTALL_DIR"

RUN echo "bamboo.home=${BAMBOO_SERVER_HOME}" > $BAMBOO_SERVER_INSTALL_DIR/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties

RUN chown -R "${BAMBOO_USER}:${BAMBOO_GROUP}" "${BAMBOO_SERVER_INSTALL_DIR}"
RUN chown -R "${BAMBOO_USER}:${BAMBOO_GROUP}" "${BAMBOO_SERVER_HOME}"

COPY entrypoint.sh              /entrypoint.sh
RUN chown ${BAMBOO_USER}:${BAMBOO_GROUP} /entrypoint.sh
RUN chmod +x /entrypoint.sh
#create symlink to automate capability detection
RUN ln -s /usr/share/maven /usr/share/maven3

VOLUME ["${BAMBOO_SERVER_HOME}"]

USER ${BAMBOO_USER}
WORKDIR $BAMBOO_SERVER_HOME

ENTRYPOINT ["/entrypoint.sh"]
