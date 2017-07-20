#!/usr/bin/env bash

## 如果需要更新NGINX配置。
echo '更新nginx配置:'
cp /YOUR_PATH/nginx.conf /TARGET_PATH/nginx/conf/

echo '推送前端demo:'
mkdir -p /TARGET_RELEASE_ROOT_DIR/release/
cp -r /YOUR_WORK_DIR/deploy/demo/ /TARGET_RELEASE_ROOT_DIR/release/

## 防止因编译三方插件，简单重载无法达到目的
echo '重启Nginx进程:'
/usr/local/openresty/nginx/sbin/nginx -s stop
/usr/local/openresty/nginx/sbin/nginx
/usr/local/openresty/nginx/sbin/nginx -s reload

## 清理当前服务器上的缓存
echo '清理缓存:'
curl http://localhost:PORT/YOUR_FLUSH_CMD
