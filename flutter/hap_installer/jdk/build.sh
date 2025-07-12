
#!/bin/bash

# /opt/ohos-sdk/linux/native/llvm/bin
# cp $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-ohos-clang $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-clang
# cp $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-ohos-clang++ $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-clang++
# cp $OHOS_SDK_HOME/native/llvm/bin/lld $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-ld
# cp $OHOS_SDK_HOME/native/llvm/bin/llvm-nm $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-nm
# cp $OHOS_SDK_HOME/native/llvm/bin/llvm-strip $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-strip
# cp $OHOS_SDK_HOME/native/llvm/bin/llvm-ar $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-ar
# cp $OHOS_SDK_HOME/native/llvm/bin/llvm-objcopy $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-objcopy
# cp $OHOS_SDK_HOME/native/llvm/bin/llvm-objdump $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-objdump
# cp $OHOS_SDK_HOME/native/llvm/bin/llvm-cxxfilt $OHOS_SDK_HOME/native/llvm/bin/aarch64-unknown-linux-musl-c++filt

# mkdir -p sysroot/aarch64-unknown-linux-musl/lib
# cp $OHOS_SDK_HOME/native/sysroot/usr/lib/aarch64-linux-ohos/crt1.o sysroot/aarch64-unknown-linux-musl/lib/crt1.o
# cp $OHOS_SDK_HOME/native/sysroot/usr/lib/aarch64-linux-ohos/crti.o sysroot/aarch64-unknown-linux-musl/lib/crti.o
# cp $OHOS_SDK_HOME/native/sysroot/usr/lib/aarch64-linux-ohos/crtn.o sysroot/aarch64-unknown-linux-musl/lib/crtn.o
# cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/clang_rt.crtbegin.o sysroot/aarch64-unknown-linux-musl/lib/crtbegin.o
# cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/clang_rt.crtend.o sysroot/aarch64-unknown-linux-musl/lib/crtend.o
# cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/libclang_rt.builtins.a sysroot/aarch64-unknown-linux-musl/lib/libgcc.a
# cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/libclang_rt.builtins.a sysroot/aarch64-unknown-linux-musl/lib/libgcc_s.a


export NDK_HOME=$OHOS_SDK_HOME/native
export TOOLCHAIN=$NDK_HOME/llvm
export SYSROOT=$TOOLCHAIN/sysroot
export PATH=$TOOLCHAIN/bin:$PATH


export CC="$TOOLCHAIN/bin/clang"
export CXX="$TOOLCHAIN/bin/clang++"
export NM="$TOOLCHAIN/bin/llvm-nm"
export LD="$TOOLCHAIN/bin/clang"
export AR="$TOOLCHAIN/bin/llvm-ar"
export OBJCOPY="$TOOLCHAIN/bin/llvm-objcopy"
export STRIP="$TOOLCHAIN/bin/llvm-strip"
export CXXFILT="$TOOLCHAIN/bin/llvm-cxxfilt"
export OBJDUMP="$TOOLCHAIN/bin/llvm-objdump"



# export CC=aarch64-linux-gnu-gcc
# export CXX=aarch64-linux-gnu-g++
# export AR=aarch64-linux-gnu-ar
# export LD=aarch64-linux-gnu-ld
# export RANLIB=aarch64-linux-gnu-ranlib
# export STRIP=aarch64-linux-gnu-strip
# export PKG_CONFIG=aarch64-linux-gnu-pkg-config
# export PKG_CONFIG_PATH=/usr/aarch64-linux-gnu/lib/pkgconfig

pushd jdk-jdk-17-29

OLD_PATH=$(pwd)
SOURCE="/Users/xiaobai/git/auto-publish-harmonyos/flutter/hap_installer/jdk/jdk-jdk-17-29"


bash configure \
--openjdk-target=aarch64-unknown-linux-musl \
--with-toolchain-type=clang \
--enable-headless-only \
--with-sysroot=${SYSROOT} \
--with-toolchain-path=${TOOLCHAIN} \
--with-jvm-variants=server \
--disable-warnings-as-errors \
--with-native-debug-symbols=internal \
--with-debug-level=slowdebug \
--with-freetype=bundled \
--with-cups-include=/usr/include \
--with-fontconfig-include=/usr/include/ \
--with-alsa-include=/usr/include/ \
--with-jvm-variants=zero \
--with-extra-cflags="-Wno-error  --target=aarch64-linux-ohos --sysroot=$NDK_HOME/sysroot -O2 -fdebug-prefix-map=${OLD_PATH}=$SOURCE "  \
--with-extra-cxxflags="-Wno-error  --target=aarch64-linux-ohos --sysroot=$NDK_HOME/sysroot -O2 -fdebug-prefix-map=${OLD_PATH}=$SOURCE " \
--with-extra-ldflags="-Wno-error  -extld=$LD --target=aarch64-linux-ohos --sysroot=$NDK_HOME/sysroot " \
BUILD_CC=${CC} \
BUILD_CXX=${CXX} \
BUILD_NM=${NM} \
BUILD_AR=${AR} \
BUILD_OBJCOPY=${OBJCOPY} \
BUILD_STRIP=${STRIP} \
BUILD_LD=${LD} \
AR=${AR} \
STRIP=${STRIP} \
OBJCOPY=${OBJCOPY} \
OBJDUMP=${OBJDUMP} \
CXXFILT=${CXXFILT} \
NM=${NM} \
--with-jobs=$(nproc)

make images


popd

echo ${BUILD_PATH}
# bash configure \
# --openjdk-target=aarch64-unknown-linux-musl \
# --with-boot-jdk=/usr/lib/jvm/java-17-openjdk-arm64/ \
# --with-toolchain-type=gcc \
# --enable-headless-only \
# --with-extra-cflags="-Wno-error" \
# --with-jvm-variants=server \
# --disable-warnings-as-errors