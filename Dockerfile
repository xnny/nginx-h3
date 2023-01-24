FROM nginx:1.23.3 AS build

WORKDIR /src
RUN apt-get update && \
    apt-get install -y git gcc make g++ cmake perl libunwind-dev golang && \
    git clone https://boringssl.googlesource.com/boringssl && \
    mkdir boringssl/build && \
    cd boringssl/build && \
    cmake .. && \
    make

RUN apt-get install -y mercurial libperl-dev libpcre3-dev zlib1g-dev libxslt1-dev libgd-ocaml-dev libgeoip-dev && \
    hg clone https://hg.nginx.org/nginx-quic   && \
    hg clone https://hg.nginx.org/njs -r "0.7.9" && \
    cd nginx-quic && \
    hg update quic && \
    auto/configure `nginx -V 2>&1 | sed "s/ \-\-/ \\\ \n\t--/g" | grep "\-\-" | grep -ve opt= -e param= -e build=` \
                   --build=nginx-quic --with-debug  \
                   --with-http_v3_module --with-stream_quic_module \
                   --with-cc-opt="-I/src/boringssl/include" --with-ld-opt="-L/src/boringssl/build/ssl -L/src/boringssl/build/crypto" && \
    make

FROM nginx:1.23.3
COPY --from=build /src/nginx-quic/objs/nginx /usr/sbin
RUN /usr/sbin/nginx -V > /dev/stderr