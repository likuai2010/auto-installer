
#!/bin/bash

mkdir -p sysroot/aarch64-unknown-linux-musl/lib
cp $OHOS_SDK_HOME/native/sysroot/usr/lib/aarch64-linux-ohos/crt1.o sysroot/aarch64-unknown-linux-musl/lib/crt1.o
cp $OHOS_SDK_HOME/native/sysroot/usr/lib/aarch64-linux-ohos/crti.o sysroot/aarch64-unknown-linux-musl/lib/crti.o
cp $OHOS_SDK_HOME/native/sysroot/usr/lib/aarch64-linux-ohos/crtn.o sysroot/aarch64-unknown-linux-musl/lib/crtn.o
cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/clang_rt.crtbegin.o sysroot/aarch64-unknown-linux-musl/lib/crtbegin.o
cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/clang_rt.crtend.o sysroot/aarch64-unknown-linux-musl/lib/crtend.o
cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/libclang_rt.builtins.a sysroot/aarch64-unknown-linux-musl/lib/libgcc.a
cp $OHOS_SDK_HOME/native/llvm/lib/clang/15.0.4/lib/aarch64-linux-ohos/libclang_rt.builtins.a sysroot/aarch64-unknown-linux-musl/lib/libgcc_s.a


export NDK_HOME=$OHOS_SDK_HOME/native
export TOOLCHAIN=$NDK_HOME/llvm
export SYSROOT=$TOOLCHAIN/sysroot
export PATH=$TOOLCHAIN/bin:$PATH
export CC="$TOOLCHAIN/bin/clang"
export CXX="$TOOLCHAIN/bin/clang++"
export AR=llvm-ar
export AS=llvm-as
export LD=ld.lld
export STRIP=llvm-strip



pushd jdk-jdk-17-10
bash configure \
--openjdk-target=aarch64-unknown-linux-musl \
--with-boot-jdk=/usr/lib/jvm/java-17-openjdk-arm64/ \
--with-toolchain-type=gcc \
--enable-headless-only \
--with-jvm-variants=server \
--disable-warnings-as-errors


popd


# bash configure \
# --openjdk-target=aarch64-unknown-linux-musl \
# --with-boot-jdk=/usr/lib/jvm/java-17-openjdk-arm64/ \
# --with-toolchain-type=gcc \
# --enable-headless-only \
# --with-extra-cflags="-Wno-error" \
# --with-jvm-variants=server \
# --disable-warnings-as-errors