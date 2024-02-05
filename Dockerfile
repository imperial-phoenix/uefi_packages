FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

# Установка обновлений для OS и требуемого софта
RUN apt-get update && apt-get upgrade -y && \
   apt-get install -y \
   build-essential \
   uuid-dev \
   iasl \
   git \
   nasm \
   python-is-python3 \
   gcc \
   g++ \
   make \
   cmake \
   wget \
   vim
   rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/tianocore/edk2 /edk2
RUN git -C /edk2 submodule update --init

RUN make -C /edk2/BaseTools

WORKDIR /edk2
ENTRYPOINT ["/bin/bash", "-c", "source /edk2/edksetup.sh BaseTools && build -a X64 -t GCC5 -DSECURE_BOOT_ENABLE=1 -p /edk2/BootLoaderPkg/BootLoaderPkg.dsc -b RELEASE"]
