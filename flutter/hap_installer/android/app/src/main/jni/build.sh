#!/bin/bash
# 设置 Go 的编译目标
export GOOS=android
export GOARCH=arm64
export CGO_ENABLED=1
target="aarch64-linux-android"
API_LEVEL="27"
# 告诉 CGO 使用 Android NDK 的工具链
# 你需要设置 NDK 的路径
export NDK_HOME="/Users/xiaobai/Library/Android/sdk/ndk/27.0.12077973"

export TOOLCHAIN="$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64"  # macOS
export CC="$TOOLCHAIN/bin/${target}${API_LEVEL}-clang"
export CXX="$TOOLCHAIN/bin/${target}${API_LEVEL}-clang++"
# 编译为共享库
go build -buildmode=c-shared -o libmylib.so mylib.go