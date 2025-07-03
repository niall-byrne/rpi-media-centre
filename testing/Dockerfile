FROM ubuntu:latest

COPY testing/bin /testing/bin

ENV PATH="/testing/bin:${PATH}"

RUN \
  apt-get update \
  && apt-get install -y ca-certificates curl gettext mandoc rsync unzip \
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

RUN \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf ./aws \
  && rm awscliv2.zip

WORKDIR /mnt
