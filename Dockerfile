FROM ros:humble-ros-base

RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.eclipse.org/zenoh/debian-repo/zenoh-public-key | gpg --dearmor --yes --output /etc/apt/keyrings/zenoh-public-key.gpg \
    && echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/zenoh-public-key.gpg] https://download.eclipse.org/zenoh/debian-repo/ /" > /etc/apt/sources.list.d/zenoh.list \
    && echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/umrt.asc] https://raw.githubusercontent.com/UMRoboticsTeam/umrt-apt-repo/main/ humble main" > /etc/apt/sources.list.d/umrt_source.list \
    && echo '#!/bin/sh\nexit 0' > /usr/local/bin/systemctl && chmod +x /usr/local/bin/systemctl \
    && echo 'Acquire::Queue-Mode "host";' > /etc/apt/apt.conf.d/99parallel \
    && echo 'Acquire::http::Pipeline-Depth "5";' >> /etc/apt/apt.conf.d/99parallel

RUN --mount=type=secret,id=apt_auth_conf,target=/etc/apt/auth.conf.d/umrt.conf \
    --mount=type=secret,id=apt_pubkey,target=/etc/apt/keyrings/umrt.asc,mode=0644 \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-overwrite" \
        gdb gdbserver libboost-all-dev less iproute2 \
        python3-curtsies python-is-python3 python3-bloom python3-pip python3-doxypypy \
        fakeroot dpkg-dev debhelper doxygen doxygen-awesome-css libi2c-dev \
        ffmpeg libopenblas-dev ros-humble-ros2-socketcan ros-humble-ros2-control \
        ros-humble-realtime-tools ros-humble-ros2-controllers ros-humble-moveit ros-humble-moveit-servo ros-humble-ublox-dgnss \
        ros-humble-foxglove-msgs ros-humble-foxglove-compressed-video-transport ros-humble-depthai-v3 ros-humble-depthai-ros-msgs-v3 ros-humble-depthai-bridge-v3 \
        ros-humble-depthai-descriptions ros-humble-vision-msgs ros-humble-depth-image-proc ros-humble-xacro ros-humble-rmw-fastrtps-cpp ros-humble-v4l2-camera \
        ros-humble-image-transport ros-humble-image-transport-plugins ros-humble-ffmpeg-image-transport ros-humble-ffmpeg-image-transport-msgs ros-humble-joint-state-publisher \
        ros-humble-joy ros-humble-aruco-opencv ros-humble-libstatistics-collector openframeworksarduino=0.0.3 umrt-imu-interface=0.0.4 \
        umrt-geiger-interface=0.1.3 umrt-arm-firmware-lib=0.5.0 ros-humble-umrt-project-perry-description=0.0.9-0jammy umrt-arm-encoder-driver=2.0.0 \
        ros-humble-umrt-ros-poe-cam zenoh-bridge-ros2dds=1.3.4 ros-humble-teleop-twist-joy ros-humble-foxglove-bridge \
    && rm -rf /var/lib/apt/lists/*
RUN sudo rm -rf /src
RUN sudo rm -f /etc/apt/sources.list.d/umrt_source.list

RUN sudo pip3 install cantools

RUN mkdir -p /ws/src

COPY . /ws

RUN cd /ws/src && ./build_scripts.sh
