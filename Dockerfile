FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /sd

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y libglib2.0-0 wget && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PREFIXLOCATION /opt/micromamba
RUN curl micro.mamba.pm/install.sh | bash
ENV PATH="${PATH}:/root/.local/bin"

# Install font for prompt matrix
COPY /data/DejaVuSans.ttf /usr/share/fonts/truetype/

EXPOSE 7860

COPY ./entrypoint.sh /sd/
ENTRYPOINT /sd/entrypoint.sh