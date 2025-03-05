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

# build macos
# ./Configure darwin64-arm64-cc --prefix=/opt/openssl --openssldir=/opt/openssl no-shared
# make -j$(nproc)

export CROSS_COMPILE=aarch64-linux-gnu-
pushd source
./Configure linux-aarch64 --cross-compile-prefix=${CROSS_COMPILE} --prefix=/path/to/output no-shared \
    no-dso \
    no-async 
make -j
popd

