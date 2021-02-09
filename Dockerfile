FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

RUN yum -y update all
RUN yum -y install g++ cmake libboost-all-dev libeigen3-dev libgmp-dev libmpfr-dev libgsl0-dev default-jdk jblas
RUN yum -y install cmake eigen3-devel python3

RUN cd /home && wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz \
  && tar xfz boost_1_60_0.tar.gz \
  && rm boost_1_60_0.tar.gz \
  && cd boost_1_60_0 \
  && ./bootstrap.sh --prefix=/usr/local \
  && ./b2 install \
  && cd /home \
  && rm -rf boost_1_60_0
  
 RUN cd /home && wget https://github.com/PalamaraLab/FastSMC/archive/v1.1.tar.gz \
  &&  tar xvfpz v1.1.tar.gz \
  && cd FastSMC-1.1 \
  && mkdir FASTSMC_BUILD_DIR \
  && cd FASTSMC_BUILD_DIR \
  && cmake ..
  && cmake --build .
  && mv * /usr/bin
  
  
  
