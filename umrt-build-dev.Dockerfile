ARG UMRT_BUILD_IMAGE_ID=ghcr.io/umroboticsteam/umrt-build:latest
FROM ${UMRT_BUILD_IMAGE_ID}

RUN sudo apt update && sudo apt install -y \
	gdb \
	gdbserver \
	ssh \
	rsync \
    nano \
 && rm -rf /var/lib/apt/lists/*

# Setup user for SSH
RUN --mount=type=secret,id=DEV_USER_NAME --mount=type=secret,id=DEV_USER_PASS \
    groupadd --system "$(cat /run/secrets/DEV_USER_NAME)" && \
	useradd \
      --system \
      --create-home \
      --gid "$(cat /run/secrets/DEV_USER_NAME)" \
      "$(cat /run/secrets/DEV_USER_NAME)" && \
    yes "$(cat /run/secrets/DEV_USER_PASS)" | passwd "$(cat /run/secrets/DEV_USER_NAME)"

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin no'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
    echo 'Port 50000'; \
  ) > /etc/ssh/sshd_config.d/umrt.conf \
  && mkdir /run/sshd

ENTRYPOINT /usr/sbin/sshd && /bin/bash
