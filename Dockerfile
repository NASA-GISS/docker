FROM ubuntu:22.04

LABEL authors="Ken Mankoff"
LABEL maintainer="ken.mankoff@nasa.gov"

# system environment
ENV DEBIAN_FRONTEND noninteractive

 
RUN apt-get -y update && apt-get install -y --no-install-recommends --no-install-suggests \
      coreutils \
      cmake \
      g++ \
      gcc \
      gdb \
      gfortran \
      git \
      libopenmpi-dev \
      libnetcdf-dev \
      libnetcdff-dev \
      make \
      nano \
      python3 \
      python3-dev \
      python3-pip \
      vim \
      wget
#  && apt-get autoremove -y \ 
#  && apt-get clean -y \ 
#  && rm -rf /var/lib/apt/lists/*

RUN echo LANG="en_US.UTF-8" > /etc/default/locale

ENV LANGUAGE en_US.UTF-8
ENV LANG C
ENV LC_ALL C
ENV LC_CTYPE C

ENV SHELL /bin/bash

RUN ln -s /usr/bin/python3 /usr/bin/python

# create a user
RUN useradd --create-home user && chmod a+rwx /home/user
ENV HOME "/home/user"
WORKDIR /home/user

# switch the user
USER user

RUN pip3 install cffi numpy

RUN git clone https://github.com/Goddard-Fortran-Ecosystem/pFUnit.git \
  && cd pFUnit \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make -j tests \
  && make -j install \
  && cd

#      -D PYTHON_INCLUDE_DIR=$(python -c "import sysconfig; print(sysconfig.get_path('include'))")  \
#      -D PYTHON_LIBRARY=$(python -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
#      -D Python_EXECUTABLE:FILEPATH=$(which python) \

RUN git clone https://github.com/nbren12/call_py_fort.git \
  && cd call_py_fort \
  && cmake -B build . \
      -D CMAKE_INSTALL_PREFIX=./opt/ \
      -D PYTHON_INCLUDE_DIR=/usr/include/python3.10 \
      -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu \
      -D CMAKE_PREFIX_PATH=../pFUnit/build/installed \
      -D Python_EXECUTABLE:FILEPATH=/usr/bin/python \
  && make -C build \
  && make -C build install \
  && cd

# RUN export PYTHONPATH=./call_py_fort/examples
# ./call_py_fort/build/examples/hello_world # works!

RUN echo "PS1='docker \h:\w\$ '" >> .bashrc

# CMD ["/usr/bin/bash", "--version"]
CMD ["gfortran", "--version"]
