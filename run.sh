#!/bin/bash

# 检查当前目录是否是 PERIOD 根目录
if [ ! -d "tool" ] || [ ! -d "test" ]; then
    echo "|错误：请在 PERIOD 项目根目录下运行此脚本|"
    exit 1
fi

echo " 正在启动 PERIOD Docker 环境..."

# 启动容器，挂载目录，注入 PATH 环境变量并赋予权限
docker run -it --rm \
  --cap-add=SYS_NICE \
  --security-opt seccomp=unconfined \
  -e "PATH=/workspace/tool/SVF/Release-build/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
  -v "$(pwd)":/workspace \
  wcventure/period:stable /bin/bash

echo " 已退出 PERIOD 容器da⭐ze"
