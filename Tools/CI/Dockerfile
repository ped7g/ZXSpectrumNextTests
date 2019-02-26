# sjasmplus ("Next" variant supporting "ZX Spectrum Next" extensions) built with GCC 6
#
# Copyleft 2019 by Peter Ped Helcmanovsky <ped _a_t_ 7gods _d_o_t_ org>
# MIT licensed * Use at your own risk!
#
# based on https://ownyourbits.com/2017/06/20/c-build-environment-in-a-docker-container/

# base image is gcc:6
FROM gcc:6

# modified manually, when image rebuild is needed?
# (I'm just guessing this will allow me to update the docker image when the git of
# sjasmplus will contain new commits, which are worth of docker build, but this is
# my first attempt to use docker, so I may be wrong about cache significance of LABEL)
LABEL com.github.catpainblack.sjasmplus.version="1.10.3"

# clone latest sources of sjasmplus sources (from the Z80N fork by CatpainBlack),
# build sjasmplus and install it as part of this container
RUN git clone https://github.com/CatpainBlack/sjasmplus.git \
    && cd sjasmplus \
    && make clean \
    && make \
    && make install
