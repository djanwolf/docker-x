ARG BASE=ubuntu:18.04

FROM ${BASE}

ARG GID=1000
ARG UID=1000
ARG USER=user

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
        build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping libsdl1.2-dev xterm \
        locales nano sudo tree curl
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir git-lfs
RUN wget https://github.com/git-lfs/git-lfs/releases/download/v2.13.3/git-lfs-linux-arm64-v2.13.3.tar.gz
RUN tar zxvf git-lfs-linux-arm64-v2.13.3.tar.gz
RUN cp git-lfs $(git --exec-path)
RUN ln -s $(git --exec-path)/git-lfs /usr/local/bin/git-lfs

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

RUN mkdir -p /home/${USER} && \
    echo "${USER}:x:${UID}:${GID}:${USER},,,:/home/${USER}:/bin/bash" >> /etc/passwd && \
    echo "${USER}:x:${UID}:" >> /etc/group && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} && \
    chown ${UID}:${GID} -R /home/${USER}

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV HOME /home/${USER}
ENV USER ${USER}
USER ${UID}:${GID}
WORKDIR /home/${USER}
