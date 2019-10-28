FROM alpine:3.6 AS build-env
RUN apk add --no-cache build-base ucl-dev zlib-dev git
RUN git clone --single-branch -b devel https://github.com/upx/upx.git /upx && \
    cd /upx && \
    git submodule update --init --recursive
RUN cd /upx/src && \
    LDFLAGS=-static make -j2 upx.out CHECK_WHITESPACE=
RUN /upx/src/upx.out --brute -o /usr/bin/upx /upx/src/upx.out

FROM scratch
COPY --from=build-env /usr/bin/upx /usr/bin/upx
ENTRYPOINT ["/usr/bin/upx"]
