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
  && cat /etc/ssh/sshd_config | sed -E 's/Subsystem\s+sftp/# Subsystem sftp/g' > /etc/ssh/sshd_config \
  && mkdir /run/sshd
# sed command fixes "Subsystem 'sftp' already defined" error caused by an oddity in OpenSSH where subsytem entries in
#   /etc/ssh/sshd_config.d/ do not override the defaults
# This may fixed in OpenSSH 9.5, see https://bugzilla.mindrot.org/show_bug.cgi?id=3236

ENTRYPOINT /usr/sbin/sshd && /bin/bash
