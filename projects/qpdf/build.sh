#!/bin/bash -eu
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# Build zlib with proper compiler flags for sanitizer support
pushd $SRC/zlib
# Clean any previous build
make distclean || true
# Configure with the sanitizer-aware compiler and flags
CFLAGS="$CFLAGS" CC="$CC" ./configure --static --prefix="$WORK"
make -j$(nproc) all
make install
popd

# Build libjpeg-turbo with proper compiler flags for sanitizer support
pushd $SRC/libjpeg-turbo
# Clean any previous build
rm -rf CMakeCache.txt CMakeFiles || true
# For MSan, we need to disable SIMD as it contains uninstrumented assembly
# Also pass all compiler flags for proper instrumentation
cmake . \
    -DCMAKE_C_COMPILER="$CC" \
    -DCMAKE_CXX_COMPILER="$CXX" \
    -DCMAKE_C_FLAGS="$CFLAGS" \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
    -DCMAKE_INSTALL_PREFIX="$WORK" \
    -DENABLE_STATIC=1 \
    -DENABLE_SHARED=0 \
    -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
    -DWITH_SIMD=0
make -j$(nproc)
make install
popd

# qpdf
./fuzz/oss-fuzz-build
