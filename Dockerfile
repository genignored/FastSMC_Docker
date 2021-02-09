# This is a test Dockerfile.

FROM ubuntu:18.04

MAINTAINER Matthew Scholz <mscholz@signaturescience.com>

# Get g++ for compiling, wget to download Boost, git to clone source code repo,
# and make to automate program compilation with Makefile provided
#RUN apt-get update \
#  && apt-get install -y git \
#			libeigen3-dev \
#                        g++ \
##			build-essential \
#                        make \
#                        wget \
#			libboost-all-dev \
#			zlib1g-dev \
#			libgmp-dev \
#			libmpfr-dev \
#			libgsl0-dev \
#			default-jdk \
#			jblas \
#			python3-dev \
#			python3-pip

RUN    apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common \
	&& add-apt-repository ppa:ubuntu-toolchain-r/test \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		build-essential \
		gcc-9 \
		g++-9 \
		gcc-9-multilib \
		g++-9-multilib \
		xutils-dev \
		patch \
		git \
		python3 \
		python3-pip \
		libpulse-dev \
                make \
                wget \
                libboost-all-dev \
                zlib1g-dev \
                libgmp-dev \
                libmpfr-dev \
                libgsl0-dev \
                jblas \
                python3-dev \ 
                python3-pip \
		libeigen3-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 10 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 20 \
	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 10 \
	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 20


ADD https://github.com/Kitware/CMake/releases/download/v3.19.4/cmake-3.19.4-Linux-x86_64.sh /cmake-3.19.4.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.19.4.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version
RUN gcc --version
RUN g++ --version




RUN pip3 install pytest
RUN git clone https://github.com/pybind/pybind11.git && \ 
cd pybind11 && \
mkdir build && \
cd build && \
cmake .. && \
make install 

# Download boost, untar, setup install with bootstrap and only do the Program Options library,
# and then install
#RUN cd /home && wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz \
#  && tar xfz boost_1_60_0.tar.gz \
#  && rm boost_1_60_0.tar.gz \
#  && cd boost_1_60_0 \
#  && ./bootstrap.sh --prefix=/usr/local --with-libraries=program_options \
#  && ./b2 install \
#  && cd /home \
#  && rm -rf boost_1_60_0

# Clone git repository with dummy C++ program, use make to compile, install it, then remove the repo
#RUN cd /home \
#  && git clone https://github.com/pblischak/boost-docker-test.git \
#  && cd /home/boost-docker-test \
#  && make linux \
#  && make install \
#  && cd .. \
#  && rm -rf boost-docker-test

RUN cd /home && wget https://github.com/PalamaraLab/FastSMC/archive/v1.1.tar.gz \
  &&  tar xvfpz v1.1.tar.gz \
  && cd FastSMC-1.1 \
  && mkdir FASTSMC_BUILD_DIR \
  && cd FASTSMC_BUILD_DIR \
  && cmake .. \
  && cmake --build . \
  && cmake --install /usr/local/bin \
  && mv * /usr/bin




CMD ["bash"]

