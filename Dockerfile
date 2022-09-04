FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /sd

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y libglib2.0-0 wget && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install mamba
ENV MAMBA_ROOT_PREFIX /opt/micromamba
# RUN curl micro.mamba.pm/install.sh | bash
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
RUN eval "$(./bin/micromamba shell hook -s posix)"
RUN ./bin/micromamba shell init -s bash -p ~/micromamba

# Install font for prompt matrix
COPY /data/DejaVuSans.ttf /usr/share/fonts/truetype/

EXPOSE 7860

COPY ./entrypoint.sh /sd/
ENTRYPOINT /sd/entrypoint.sh
