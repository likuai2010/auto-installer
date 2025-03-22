#!/bin/bash

#macos 
if [ "$1" = "macos" ]; then
cmake  -G Ninja \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -B build_macos \
  -S .
pushd build_macos
ninja
cp -f hdctools/libhdc_z.a ../../plugins/native_core/macos/Classes/libs/libhdc_z.a
cp -f hapsigner/libsigntool.a ../../plugins/native_core/macos/Classes/libs/libsigntool.a
popd
fi

if [ "$1" = "linux" ]; then
cmake  -G Ninja \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -B build_linux \
  -S .
pushd build_linux
ninja
cp -rf unhap/libunhap.a ../../plugins/native_core/libs/linux/x86-64/libunhap.a
popd
fi
#windows  use MSYS2 build
if [ "$1" = "windows" ]; then
cmake  -G Ninja \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -B build_windows \
  -S .
pushd build_windows
ninja 
cp -f unhap/libunhap.dll.a ../../plugins/native_core/libs/windows/x86-64/libunhap.dll.a
cp -f unhap/libunhap.dll ../../plugins/native_core/libs/windows/x86-64/libunhap.dll
popd
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
