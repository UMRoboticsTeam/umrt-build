ARG UMRT_BUILD_IMAGE_ID=ghcr.io/umroboticsteam/umrt-build:latest
FROM ${UMRT_BUILD_IMAGE_ID}

RUN sudo apt update && sudo apt install -y \
	gdb \
	gdbserver \
	ssh \
	rsync \
    nano \
    can-utils \
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
    echo 'Port 50000'; \
  ) > /etc/ssh/sshd_config.d/umrt.conf \
  && mkdir /run/sshd

# Automagically source the ros environment for root and user
RUN --mount=type=secret,id=DEV_USER_NAME ( \
    echo 'source /opt/ros/humble/setup.bash' \
    echo 'if [ -f /workspace/install/setup.bash ]; then source /workspace/install/setup.bash; fi' \
  ) | tee /home/"$(cat /run/secrets/DEV_USER_NAME)"/.bashrc >> /root/.bashrc

# Add user to sudo group
RUN --mount=type=secret,id=DEV_USER_NAME usermod -aG sudo "$(cat /run/secrets/DEV_USER_NAME)"

ENTRYPOINT /usr/sbin/sshd && /bin/bash
