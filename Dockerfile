FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /sd

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y libglib2.0-0 wget && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Based on https://gist.github.com/wolfv/fe1ea521979973ab1d016d95a589dcde?permalink_comment_id=3525280#gistcomment-3525280

# Install basic commands and mamba
RUN apt-get update && \
    apt-get install -y ca-certificates wget bash bzip2 && \
    wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba --strip-components=1 && \
    ./micromamba shell init -s bash -p ~/micromamba && \
    apt-get clean autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

RUN micromamba activate && \
    micromamba install -y -n base python=3.8.6 pip -c conda-forge && \
    rm /root/micromamba/lib/*.a && \
    rm -rf /root/micromamba/pkgs/

# Install font for prompt matrix
COPY /data/DejaVuSans.ttf /usr/share/fonts/truetype/

EXPOSE 7860

COPY ./entrypoint.sh /sd/
ENTRYPOINT /sd/entrypoint.sh