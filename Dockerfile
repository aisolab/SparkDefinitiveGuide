FROM ubuntu:18.04
LABEL maintainer="bsk0130@gmail.com"

# Set the ARGs
ARG PYTHON_VER=3.7.9
ARG SPARK_VER=2.4.7

ENV USER user
ENV UID 1000
ENV HOME /home/${USER}

RUN apt-get update && apt-get install -y \
    sudo \
    apt-utils \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    git \
    libffi-dev \
    liblzma-dev \
    locales \
    g++ \
    libpcre3-dev \
    tar \
    bash \
    rsync \
    gcc \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libpng-dev \
    libzmq3-dev \
    unzip \
    pkg-config \
    software-properties-common \
    graphviz

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setting user
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${UID} \
    ${USER}

RUN adduser ${USER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Python
USER ${USER}
WORKDIR ${HOME}

ENV PYENV_ROOT ${HOME}/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN git clone https://github.com/pyenv/pyenv.git .pyenv

RUN pyenv install ${PYTHON_VER} && \
    pyenv global ${PYTHON_VER}

ENV PYSPARK_PYTHON=python
ENV PYSPARK_DRIVER_PYTHON=python

RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir notebook==5.* pyspark==${SPARK_VER} spylon-kernel==0.4.* && \
    python -m spylon_kernel install --sys-prefix

# Setuo pyenv 
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> ~/.bashrc
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER root
RUN chown -R ${UID} ${HOME}

USER ${USER}
WORKDIR ${HOME}/workspace