# docker build . --tag "harbour-runtime"
# docker run -it harbour-runtime /bin/bash
FROM --platform=linux/amd64 debian

# RUN apt update && apt install -y libgpm2\ libncurses5\ libslang2\ libtinfo5\ libx11-6
RUN apt update && apt install -y libgpm2
RUN apt install -y libncurses5
RUN apt install -y libslang2
RUN apt install -y libtinfo5
RUN apt install -y libx11-6

RUN apt install -y build-essential

# TODO try dpkg -i /tmp/libpng12.deb from https://gist.github.com/prsanjay/f994e313df665bebcffbd0465b4ff653
COPY install.sh /
#debdir is a directory
COPY debdir /debdir
RUN chmod +x /install.sh
CMD ["/install.sh"]

# RUN git clone XYZ 
COPY core /core
WORKDIR "/core"
RUN make install

# from https://groups.google.com/g/harbour-users/c/eA6AbjJMELs?pli=1
WORKDIR "/etc/ld.so.conf.d"
RUN echo "/usr/local/lib/harbour" >> harbour
RUN ldconfig

WORKDIR "/core"