# docker build . --tag "harbour-runtime"
FROM --platform=linux/amd64 debian

# RUN apt update && apt install -y libgpm2\ libncurses5\ libslang2\ libtinfo5\ libx11-6
RUN apt update && apt install -y libgpm2
RUN apt install -y libncurses5
RUN apt install -y libslang2
RUN apt install -y libtinfo5
RUN apt install -y libx11-6

RUN apt install -y build-essential

# TODO try from https://gist.github.com/prsanjay/f994e313df665bebcffbd0465b4ff653
COPY /debdir/r2017-12-15-18_53_harbour_3.2.0-1_amd64.deb /tmp/r2017-12-15-18_53_harbour_3.2.0-1_amd64.deb
RUN dpkg -i /tmp/r2017-12-15-18_53_harbour_3.2.0-1_amd64.deb

# tools convenient for command line
RUN apt install -y git
RUN git config --global user.email "user@harbour-runtime"
RUN git config --global user.name "user@harbour-runtime"

RUN apt install -y vim

## decomment following lines to install and compile compiler
# git clone git@github.com:harbour/core.git
# WORKDIR "/core"
# RUN make install

# from https://groups.google.com/g/harbour-users/c/eA6AbjJMELs?pli=1
WORKDIR "/etc/ld.so.conf.d"
RUN echo "/usr/local/lib/harbour" >> harbour
RUN ldconfig

WORKDIR "/host/FAKT2"