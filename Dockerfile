FROM ros:humble-ros-base

# Public key has been downloaded using
#   curl -fsSL https://download.eclipse.org/zenoh/debian-repo/zenoh-public-key | gpg --dearmor --yes --output ./files/zenoh-public-key.gpg
# on October 31st, 2026
COPY ./files/zenoh-public-key.gpg /etc/apt/keyrings/zenoh-public-key.gpg

# Copy APT configuration files
COPY ./files/zenoh.list /etc/apt/sources.list.d/zenoh.list
COPY ./files/99parallel /etc/apt/apt.conf.d/99parallel

# Install necessary packages from public repos
# Please retain alphabetical ordering
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-overwrite" \
        debhelper \
        doxygen \
        dpkg-dev \
        fakeroot \
        ffmpeg \
        gdb \
        gdbserver \
        iproute2 \
        less \
        libboost-all-dev \
        libi2c-dev \
        libopenblas-dev \
        python-is-python3 \
        python3-bloom \
        python3-curtsies \
        python3-doxypypy \
        python3-pip \
        ros-humble-aruco-opencv \
        ros-humble-depth-image-proc \
        ros-humble-depthai-bridge-v3 \
        ros-humble-depthai-descriptions \
        ros-humble-depthai-ros-msgs-v3 \
        ros-humble-depthai-v3 \
        ros-humble-ffmpeg-image-transport \
        ros-humble-ffmpeg-image-transport-msgs \
        ros-humble-foxglove-bridge \
        ros-humble-foxglove-compressed-video-transport \
        ros-humble-foxglove-msgs \
        ros-humble-image-transport \
        ros-humble-image-transport-plugins \
        ros-humble-joint-state-publisher \
        ros-humble-joy \
        ros-humble-libstatistics-collector \
        ros-humble-moveit \
        ros-humble-moveit-servo \
        ros-humble-realtime-tools \
        ros-humble-rmw-fastrtps-cpp \
        ros-humble-ros-babel-fish \
        ros-humble-ros2-control \
        ros-humble-ros2-controllers \
        ros-humble-ros2-socketcan \
        ros-humble-teleop-twist-joy \
        ros-humble-ublox-dgnss \
        ros-humble-usb-cam \
        ros-humble-v4l2-camera \
        ros-humble-vision-msgs \
        ros-humble-xacro \
        zenoh-bridge-ros2dds=1.3.4

# Install packages from UMRT's apt repo
# This step won't work locally.
COPY ./files/umrt_source.list /etc/apt/sources.list.d/umrt_source.list
RUN --mount=type=secret,id=apt_auth_conf,target=/etc/apt/auth.conf.d/umrt.conf \
    --mount=type=secret,id=apt_pubkey,target=/etc/apt/keyrings/umrt.asc,mode=0644 \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
        apt-get update \
        && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-overwrite" \
            doxygen-awesome-css \
            openframeworksarduino=0.0.3 \
            ros-humble-umrt-project-perry-description=0.0.9-0jammy \
            ros-humble-umrt-ros-poe-cam \
            umrt-arm-encoder-driver=2.0.0 \
            umrt-arm-firmware-lib=0.5.0 \
            umrt-geiger-interface=0.1.3 \
            umrt-imu-interface=0.0.4 \
        && rm -f /etc/apt/sources.list.d/umrt_source.list

# Delete apt list so people don't install outdated packages if the image was built a while ago.
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/apt/*

# Install dependencies, and copy and run build script
RUN sudo pip3 install cantools
COPY src /ws/src

# These files are referenced in symlinks, so they also have to be copied.
COPY ./version /ws
COPY ./Messages.sym /ws

RUN git clone https://github.com/UMRoboticsTeam/ros2_j1939_babbler.git /ws/src/ros2_j1939_babbler \
    && git -C /ws/src/ros2_j1939_babbler checkout v0.2.4
RUN cd /ws/src && ./build_scripts.sh
RUN sudo rm -rf /ws
