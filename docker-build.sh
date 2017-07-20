#!/bin/sh
#
#  docker-build.sh
#  docker-openresty
#

set -e

apk --no-cache --no-progress update

# ===============
# = build tools =
# ===============
apk add   curl \
          gcc \
          make \
          musl-dev \
          openssl-dev \
          zlib-dev \
          pcre-dev \
          perl \
          git

# =============
# = openresty =
# =============
openresty_url="https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz"
curl --head "$openresty_url"
curl -sSL "$openresty_url" | tar zx
cd openresty-* \
  && ./configure \
    --with-pcre-jit \
    --with-http_realip_module \
    --add-module=/nginx-http-concat \
  && make && make install \
  && cd .. && rm -rf openresty-*

apk add libgcc libssl1.0 pcre

ln -sf "${LUAJIT_PREFIX}/bin/luajit" "/usr/local/bin/lua"
ln -sf /dev/stdout "${NGINX_PREFIX}/logs/access.log"
ln -sf /dev/stderr "${NGINX_PREFIX}/logs/error.log"

# ============
# = luarocks =
# ============
curl -sSL "http://keplerproject.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" | tar zx
cd luarocks-* \
  && ./configure \
    --prefix="${LUAJIT_PREFIX}" \
    --with-lua="${LUAJIT_PREFIX}" \
    --with-lua-include="${LUAJIT_PREFIX}/include/luajit-2.1" \
    --lua-suffix=jit \
  && make && make install \
  && cd .. && rm -rf luarocks-*

"${LUAJIT_PREFIX}/bin/luarocks" install stringy

# ===========
# = cleanup =
# ===========
apk del \
  gcc \
  make \
  musl-dev \
  openssl-dev \
  zlib-dev \
  pcre-dev

rm -rf /var/cache/apk/*