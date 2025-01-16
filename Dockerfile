FROM ros:humble-ros-base

RUN echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/umrt.asc] https://raw.githubusercontent.com/UMRoboticsTeam/umrt-apt-repo/testing-ci-cd/ humble main" > /etc/apt/sources.list.d/umrt_source.list

RUN --mount=type=secret,id=apt_auth_conf,target=/etc/apt/auth.conf.d/umrt.conf --mount=type=secret,id=apt_pubkey,target=/etc/apt/keyrings/umrt.asc,mode=0644 \
    sudo apt update && sudo apt install -y \
        ros-humble-ros2-control \
        ros-humble-ros2-controllers \
        gdb \
        gdbserver \
        libboost-all-dev \
        ros-humble-xacro \
        less \
        python3-curtsies \
        python-is-python3 \
        python3-bloom \
        fakeroot \
        dpkg-dev \
        debhelper \
        arm-firmware-lib \
    && rm -rf /var/lib/apt/lists/*

RUN sudo rm -f /etc/apt/sources.list.d/umrt_source.list