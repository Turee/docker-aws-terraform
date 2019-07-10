FROM alpine:3.10

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN apk update \
 && apk add \
   bash \
   curl \
   openssh \
   git \
   less \
   python \
   py-pip \
 && pip install awscli \
 && apk --purge -v del py-pip \
 && rm /var/cache/apk/*

ARG DOCKER_CLI_VERSION="18.06.3-ce"
ENV DOCKER_DOWNLOAD_URL="https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz"

RUN mkdir -p /tmp/download \
    && curl -L $DOCKER_DOWNLOAD_URL | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && chmod +x /usr/local/bin/docker \
    && rm -rf /tmp/download

ARG TERRAFORM_VERSION="0.12.3"
ENV TERRAFORM_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

RUN mkdir -p /tmp/download \
    && cd /tmp/download \
    && curl -L $TERRAFORM_DOWNLOAD_URL | unzip - \
    && mv terraform /usr/local/bin/ \
    && chmod +x /usr/local/bin/terraform \
    && rm -rf /tmp/download

CMD ["/bin/bash"]
