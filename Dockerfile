FROM ubuntu:22.04

LABEL authors="Ken Mankoff"
LABEL maintainer="ken.mankoff@nasa.gov"

# system environment
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get install -y --no-install-recommends --no-install-suggests \
      gfortran \
      gdb \
      libopenmpi-dev \
      libnetcdf-dev \
      libpnetcdf-dev \
      libnetcdff-dev \
      make \
      wget \
  && apt-get autoremove -y \
  && apt-get clean -y \ 
  && rm -rf /var/lib/apt/lists/*

RUN echo LANG="en_US.UTF-8" > /etc/default/locale

ENV LANGUAGE=en_US.UTF-8
ENV LANG=C
ENV LC_ALL=C
ENV LC_CTYPE=C

ENV SHELL=/bin/bash

# create a user
RUN useradd --create-home user && chmod a+rwx /home/user
ENV HOME="/home/user"
WORKDIR /home/user

# switch the user
USER user

COPY --chown=user:user modelErc .
ENV MODELERC=/home/user/modelErc

# CMD ["/usr/bin/bash", "--version"]
CMD ["gfortran", "--version"]
