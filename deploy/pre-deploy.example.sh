#!/usr/bin/env bash

## 添加需要执行的编译命令，例如：
#BUILD ARGV...

## 移动构建完毕的代码到指定目录
mkdir -p release/{stable,dev}
rm -rf release/stable/1.0.0
mv dest release/stable/1.0.0
rm -rf lastest && ln -s 1.0.0 lastest

## 添加需要执行的清理命令，例如(如处理后的nginx配置存放于deploy目录，请勿添加此目录)：
rm -rf FILE_OR_DIR_NEED_BE_KILLED
