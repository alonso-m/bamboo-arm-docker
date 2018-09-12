#!/bin/bash
set -euo pipefail

: ${JAVA_OPTS:=}

# Bamboo should not run Repository-stored Specs in Docker while being run in a Docker container itself.
# Only affects the installation phase. Has no effect once Bamboo is set up.
JAVA_OPTS="${JAVA_OPTS} -Dbamboo.setup.rss.in.docker=false"

export JAVA_OPTS="${JAVA_OPTS}"

# Start Bamboo as the correct user.
if [ "${UID}" -eq 0 ]; then
    echo "User is currently root. Will change directory ownership to ${BAMBOO_USER}:${BAMBOO_GROUP}, then downgrade permission to ${BAMBOO_USER}"
    PERMISSIONS_SIGNATURE=$(stat -c "%u:%U:%a" "${BAMBOO_SERVER_HOME}")
    EXPECTED_PERMISSIONS=$(id -u ${BAMBOO_USER}):${BAMBOO_GROUP}:700
    if [ "${PERMISSIONS_SIGNATURE}" != "${EXPECTED_PERMISSIONS}" ]; then
        echo "Updating permissions for BAMBOO_HOME"
        mkdir -p "${BAMBOO_SERVER_HOME}/lib" &&
            chmod -R 700 "${BAMBOO_SERVER_HOME}" &&
            chown -R "${BAMBOO_USER}:${BAMBOO_GROUP}" "${BAMBOO_SERVER_HOME}"
    fi

    # Now drop privileges.
    exec su -s /bin/bash "${BAMBOO_USER}" -c "${BAMBOO_SERVER_INSTALL_DIR}/bin/start-bamboo.sh -fg"
else
    exec "${BAMBOO_SERVER_INSTALL_DIR}/bin/start-bamboo.sh" "-fg"
fi
