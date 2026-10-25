# PERIOD 复现项目 - 公共环境说明

**负责人：黄邦彦**

为了避免 WSL 环境的依赖冲突（如 Python 版本、LLVM、权限限制等），我们统一使用 Docker 镜像进行实验。

## 1. 准备 Docker 镜像（仅需执行一次）
请确保你的电脑上已安装并运行了 Docker Desktop。打开 WSL 终端，执行：
```bash
docker pull wcventure/period:stable

## 2. 一键启动器
项目根目录已提供 run.sh 脚本，首次使用前请先赋予执行权限：
```bash
chmod +x run.sh
之后每次需要运行实验，只需在项目根目录执行：
```bash
./run.sh

## 3. 环境验证（跑通 doubleFree）
进入容器后，**务必先加载环境变量**，然后复制以下命令完整执行一遍，用于验证你的环境是否正常：
```bash
cd /workspace
source tool/init_env.sh
cd test/doubleFree/
./cleanDIR.sh
clang -g -emit-llvm -c ./df.c -o df.bc
$ROOT_DIR/tool/staticAnalysis/staticAnalysis.sh df
export Con_PATH=$ROOT_DIR/test/doubleFree/ConConfig.df
$ROOT_DIR/tool/staticAnalysis/DBDS-INSTRU/dbds-clang-fast -g -fsanitize=address -c ./df.c -o df.o
clang++ ./df.o $ROOT_DIR/tool/staticAnalysis/DBDS-INSTRU/DBDSFunction.o -g -o df -lpthread -fsanitize=address -ldl
$ROOT_DIR/tool/DBDS/run_PDS.py ./df
