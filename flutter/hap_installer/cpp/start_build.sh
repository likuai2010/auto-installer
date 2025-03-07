#!/bin/bash

#macos 
if [ "$1" = "macos" ]; then
cmake  -G Ninja \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -B build_macos \
  -S .
pushd build_macos
ninja 
popd
fi
#windows  use MSYS2 build
if [ "$1" = "windows" ]; then
cmake --build . 
fi

#android
if [ "$1" = "android" ]; then
export ANDROID_NDK_ROOT=/Users/fiber/Library/Android/sdk/ndk/23.1.7779620
export TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64
export SYSROOT=$TOOLCHAIN/sysroot
export PATH=$TOOLCHAIN/bin:$PATH
cmake  -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
  -DCMAKE_SYSROOT=$SYSROOT \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-24 \
  -D_GNU_SOURCE \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -B build_android \
  -S .
pushd build_android
ninja 
popd
fi
