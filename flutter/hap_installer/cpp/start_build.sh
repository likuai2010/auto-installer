#!/bin/bash

#macos 
if [ "$1" = "macos" ]; then
cmake --build . 
fi
#windows  use MSYS2 build
if [ "$1" = "windows" ]; then
cmake --build . 
fi

#android
if [ "$1" = "android" ]; then
export ANDROID_NDK_HOME=/Users/fiber/Library/Android/sdk/ndk/23.1.7779620
export PATH=$ANDROID_NDK_HOME:$PATH
cmake  -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
  -DCMAKE_SYSROOT=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/sysroot \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-23 \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -B build \
  -S .
pushd build
ninja 
popd
fi
