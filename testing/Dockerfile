FROM ubuntu:latest

ARG UNAME1=pi1
ARG UID1=1000
ARG GID1=1000

ARG UNAME2=pi2
ARG UID2=1001
ARG GID2=1001


ENV PATH="/testing/bin:${PATH}"

RUN \
  apt-get update \
  && apt-get install -y ca-certificates curl gettext mandoc rsync sudo unzip vim \
  && install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
  && chmod a+r /etc/apt/keyrings/docker.asc \
  && echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
       tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get install -y docker-ce-cli \
  && rm -rf /var/cache/apt/lists

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    sed -i \
    's,/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin,/testing/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin,g' \
    /etc/sudoers

RUN groupadd -g $GID1 -o $UNAME1 \
    && useradd -m -u $UID1 -g $UNAME1 -s /bin/bash $UNAME1 \
    && usermod -aG sudo $UNAME1

RUN groupadd -g $GID2 -o $UNAME2 \
    && useradd -m -u $UID2 -g $UNAME2 -s /bin/bash $UNAME2 \
    && usermod -aG sudo $UNAME2

RUN \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf ./aws \
  && rm awscliv2.zip

COPY testing/bin /testing/bin

WORKDIR /home/$UNAME1/rpi-media-centre

USER $UNAME1
WORKDIR /home/$UNAME1
