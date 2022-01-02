FROM homebrew/ubuntu20.04 AS brew-base

USER root

ENV REPO_DIR=/work/repo
ENV BUILD_DIR=/work/build
ENV INSTALL_DIR=/work/install
ENV SCRATCH_DIR=/work/scratch

RUN mkdir -p $REPO_DIR \
    && mkdir -p $BUILD_DIR \
    && mkdir -p $INSTALL_DIR \
    && mkdir -p $SCRATCH_DIR

ENV PATH=$INSTALL_DIR/bin:$INSTALL_DIR/sbin:$PATH
ENV LD_LIBRARY_PATH=$INSTALL_DIR/lib64:$INSTALL_DIR/lib64:$LD_LIBRARY_PATH

# dependencies for root that cannot be picked up from brew
RUN apt-get update -y &&\
    apt-get install -y libx11-dev libxft-dev libxext-dev liblapack-dev

ENV LANG=en_US.UTF-8 \
	PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
    LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH \
	SHELL=/bin/bash

USER linuxbrew

RUN brew update && brew upgrade
# Morpho dependencies for options build
RUN brew install wget vim cmake root

# RUN echo ". /home/linuxbrew/.linuxbrew/bin/thisroot.sh" >> ~/.bash_profile

# RUN cd $INSTALL_DIR &&\
#     wget --quiet https://root.cern/download/root_v6.24.02.Linux-ubuntu20-x86_64-gcc9.3.tar.gz &&\
#     tar -xzf root_v6.24.02.Linux-ubuntu20-x86_64-gcc9.3.tar.gz &&\
#     cd $HOME &&\
#     rm -rf $INSTALL_DIR/root_v6.24.02.Linux-ubuntu20-x86_64-gcc9.3.tar.gz

