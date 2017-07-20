FROM soulteary/alpine-base:3.4

MAINTAINER soulteary <soulteary@gmail.com>

# https://openresty.org/#Download
ENV OPENRESTY_VERSION 1.11.2.1
# https://github.com/keplerproject/luarocks/wiki/Release-history
ENV LUAROCKS_VERSION 2.4.0

ENV OPENRESTY_PREFIX /usr/local/openresty
ENV NGINX_PREFIX ${OPENRESTY_PREFIX}/nginx
ENV LUAJIT_PREFIX ${OPENRESTY_PREFIX}/luajit

ENV PATH "${NGINX_PREFIX}/sbin:${LUAJIT_PREFIX}/bin:${OPENRESTY_PREFIX}/bin:${PATH}"

RUN apk --no-cache --no-progress update && \
    apk add curl gcc make musl-dev openssl-dev zlib-dev pcre-dev perl git

RUN cd / && \
    git clone https://github.com/soulteary/nginx-http-concat.git

RUN openresty_url="https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz" && \
    curl --head "$openresty_url" && \
    curl -sSL "$openresty_url" | tar zx && \
    cd openresty-* && \
    ./configure \
    --with-pcre-jit \
    --with-http_realip_module \
    --add-module=/nginx-http-concat && \
    make && \
    make install && cd .. && rm -rf openresty-*

RUN apk add libgcc libssl1.0 pcre && \
    ln -sf "${LUAJIT_PREFIX}/bin/luajit" "/usr/local/bin/lua" && \
    ln -sf /dev/stdout "${NGINX_PREFIX}/logs/access.log" && \
    ln -sf /dev/stderr "${NGINX_PREFIX}/logs/error.log"

RUN curl -sSL "http://keplerproject.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" | tar zx && \
    cd luarocks-* && ./configure \
    --prefix="${LUAJIT_PREFIX}" \
    --with-lua="${LUAJIT_PREFIX}" \
    --with-lua-include="${LUAJIT_PREFIX}/include/luajit-2.1" \
    --lua-suffix=jit && \
    make && make install && cd .. && rm -rf luarocks-*

RUN "${LUAJIT_PREFIX}/bin/luarocks" install stringy

# ===========
# = cleanup =
# ===========
RUN apk del gcc make musl-dev openssl-dev zlib-dev pcre-dev
RUN rm -rf /var/cache/apk/*


EXPOSE 80 443

CMD ["nginx", "-g", "daemon off; error_log logs/error.log info;"]