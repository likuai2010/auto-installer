#!/usr/bin/env bash
# Copyright (c) 2023 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
pushd source
#build macos
# ./Configure darwin64-x86_64 --prefix=/opt/openssl --openssldir=/opt/openssl no-shared no-tests
# make -j$(nproc)

./Configure linux-x86_64-clang --prefix=/opt/openssl --openssldir=/opt/openssl no-shared no-tests
make -j$(nproc)


# export CROSS_COMPILE=aarch64-linux-gnu-
# pushd source
# ./Configure linux-aarch64 --cross-compile-prefix=${CROSS_COMPILE} --prefix=/path/to/output no-shared \
#     no-dso \
#     no-async 
# make -j
# popd
#export ANDROID_NDK_ROOT=G:/android/sdk/ndk/27.0.12077973
# export ANDROID_NDK_ROOT=/Users/fiber/Library/Android/sdk/ndk/23.1.7779620
# export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64
# export SYSROOT=$TOOLCHAIN/sysroot
# export CC=$TOOLCHAIN/bin/aarch64-linux-android27-clang
# export PATH=$TOOLCHAIN/bin:$PATH
# pushd source
# ./Configure android-arm64  --prefix=/openssl   no-shared \
#     no-dso \
#     no-async 
# make -j
# popd
