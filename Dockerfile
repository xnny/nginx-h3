FROM nginx AS build

WORKDIR /src
RUN apt-get update && apt-get -y upgrade && apt-get install -y apt-utils git gcc make autoconf libtool perl
RUN git clone -b v3.6.1 https://github.com/libressl-portable/portable.git libressl && \
    cd libressl && \
    ./autogen.sh && \
    ./configure && \
    make check && \
    make install

RUN apt-get install -y mercurial libperl-dev libpcre3-dev zlib1g-dev libxslt1-dev libgd-ocaml-dev libgeoip-dev
RUN hg clone -b quic https://hg.nginx.org/nginx-quic && \
    cd nginx-quic && \
    auto/configure `nginx -V 2>&1 | sed "s/ \-\-/ \\\ \n\t--/g" | grep "\-\-" | grep -ve opt= -e param= -e build=` \
      --with-http_v3_module --with-stream_quic_module \
      --with-debug --build=nginx-quic \
      --with-cc-opt="-I/src/libressl/build/include" --with-ld-opt="-L/src/libressl/build/lib" --with-ld-opt="-static" && \
    make

FROM nginx
COPY --from=build /src/nginx-quic/objs/nginx /usr/sbin
RUN /usr/sbin/nginx
EXPOSE 80 443 443/udp