FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04

# Tools I find useful during development
RUN apt-get update \
 && apt-get install -y \
    build-essential \
    lsb-release \
    sudo \
    wget \
 && apt-get clean

RUN /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
#  && /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list \
#  && wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -' \
 && apt-get update \
 && apt-get install -y \
    ros-kinetic-desktop-full \
    gazebo7 \
    libgazebo7-dev \
    python-catkin-tools \
    python-rosinstall \
 && rosdep init \
 && apt-get clean

RUN rosdep update

RUN /bin/sh -c 'echo ". /opt/ros/kinetic/setup.bash" >> ~/.bashrc' \
 && /bin/sh -c 'echo ". /usr/share/gazebo/setup.sh" >> ~/.bashrc'

# Optimizing for build time preinstalling dependencies
RUN apt-get update \
 && apt-get install -y \
    ros-kinetic-mavros \
    unzip \
    python-toml \
 && apt-get clean

# workspace development helpers
RUN apt-get update \
 && apt-get install -y \
    byobu \
    emacs \
 && apt-get clean





RUN mkdir /tmp/drone_demo/src     -p
WORKDIR /tmp/drone_demo/src
RUN git clone https://github.com/osrf/drone_demo.git -b updates
RUN git clone https://github.com/PX4/sitl_gazebo.git --recursive
WORKDIR /tmp/drone_demo
RUN . /opt/ros/kinetic/setup.sh && rosdep update && rosdep install --from-path src -iy
RUN . /opt/ros/kinetic/setup.sh && catkin config --install
RUN . /opt/ros/kinetic/setup.sh && catkin build
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD roslaunch sitl_launcher demo.launch gui:=false