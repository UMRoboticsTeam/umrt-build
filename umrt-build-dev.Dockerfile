ARG UMRT_BUILD_IMAGE_ID=ghcr.io/umroboticsteam/umrt-build:latest
FROM ${UMRT_BUILD_IMAGE_ID}

RUN sudo apt update -y --no-install-recommends -o Dpkg::Options::="--force-overwrite" \
    && sudo apt install -y \
        ssh \
        rsync \
        nano \
        can-utils \
    && rm -rf /var/lib/apt/lists/*

# Setup user for SSH
RUN --mount=type=secret,id=DEV_USER_NAME --mount=type=secret,id=DEV_USER_PASS \
        groupadd --system "$(cat /run/secrets/DEV_USER_NAME)" \
        && useradd \
                --system \
                --create-home \
                --gid "$(cat /run/secrets/DEV_USER_NAME)" \
                "$(cat /run/secrets/DEV_USER_NAME)" \
        && yes "$(cat /run/secrets/DEV_USER_PASS)" | passwd "$(cat /run/secrets/DEV_USER_NAME)"

# Copy SSH config
COPY ./files/umrt-buid-dev-ssh.conf /etc/ssh/sshd_config.d/
RUN mkdir /run/sshd

VOLUME /workspace
ENTRYPOINT /usr/sbin/sshd && /bin/bash
