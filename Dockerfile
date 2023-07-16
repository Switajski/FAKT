# docker build . --tag "harbour-runtime"
# docker run -it harbour-runtime /FAKT2/PRG/ARTYKULY
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

## decomment following lines to install and compile compiler
# RUN apt install -y git
# git clone git@github.com:harbour/core.git
# WORKDIR "/core"
# RUN make install

# from https://groups.google.com/g/harbour-users/c/eA6AbjJMELs?pli=1
WORKDIR "/etc/ld.so.conf.d"
RUN echo "/usr/local/lib/harbour" >> harbour
RUN ldconfig

COPY FAKT2 /FAKT2
WORKDIR "/FAKT2/PRG"
RUN hbmk2 FAKT.PRG