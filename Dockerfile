FROM homebrew/ubuntu20.04 AS brew-base

ENV REPO_DIR=/home/linuxbrew/repo
ENV BUILD_DIR=/home/linuxbrew/build
ENV INSTALL_DIR=/home/linuxbrew/install
ENV SCRATCH_DIR=/home/linuxbrew/scratch

RUN mkdir -p $REPO_DIR \
    && mkdir -p $BUILD_DIR \
    && mkdir -p $INSTALL_DIR \
    && mkdir -p $SCRATCH_DIR

ENV PATH=$INSTALL_DIR/bin:$INSTALL_DIR/sbin:$PATH
ENV LD_LIBRARY_PATH=$INSTALL_DIR/lib64:$INSTALL_DIR/lib64:$LD_LIBRARY_PATH

USER root

# dependencies for root that cannot be picked up from brew
RUN apt-get update -y &&\    
    apt-get install -y libx11-dev libxpm-dev libxft-dev libxext-dev libblas-dev liblapack-dev


USER linuxbrew

ENV LANG=en_US.UTF-8 \
	PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
    LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH \
	SHELL=/bin/bash


RUN brew update && brew upgrade
# Morpho dependencies for options build
# ROOT 6.24.02 needs python 3.8
RUN brew install wget vim cmake python@3.8 
 
# RUN echo ". /home/linuxbrew/.linuxbrew/bin/thisroot.sh" >> ~/.bash_profile

RUN cd $INSTALL_DIR &&\
    wget --quiet https://root.cern/download/root_v6.24.02.Linux-ubuntu20-x86_64-gcc9.3.tar.gz &&\
    tar -xzf root_v6.24.02.Linux-ubuntu20-x86_64-gcc9.3.tar.gz &&\
    cd $HOME &&\
    rm -rf $INSTALL_DIR/root_v6.24.02.Linux-ubuntu20-x86_64-gcc9.3.tar.gz

SHELL ["/bin/bash", "-c"]
RUN echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/python@3.8/bin:$PATH"' >> /home/linuxbrew/.bash_profile &&\
    echo ". $INSTALL_DIR/root/bin/thisroot.sh" >> /home/linuxbrew/.bash_profile

