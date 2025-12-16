# Copyright 2016 Google Inc.
# Copyright 2022-2025 D. R. Commander
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
#
# This Dockerfile includes 11 new libjpeg API fuzzers from rmc-infosec fork.
# Once upstream PR is merged, change back to libjpeg-turbo/libjpeg-turbo.
#
# New fuzzers added:
#   - decompress_libjpeg_fuzzer  - progressive_fuzzer
#   - marker_fuzzer              - coefficient_fuzzer
#   - partial_fuzzer             - error_recovery_fuzzer
#   - raw_data_fuzzer            - transcode_fuzzer
#   - compress_libjpeg_fuzzer    - compress_raw_data_fuzzer
#   - resync_fuzzer
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install -y make yasm cmake

# Clone libjpeg-turbo with new fuzzers from rmc-infosec fork
# TODO: Change back to libjpeg-turbo/libjpeg-turbo once upstream PR is merged
RUN git clone --depth 1 https://github.com/rmc-infosec/libjpeg-turbo -b feat/libjpeg-api-fuzzer libjpeg-turbo.main

# Create branches.txt for build.sh compatibility (only main branch for now)
RUN mkdir -p fuzz && echo "main" > fuzz/branches.txt

# Seed corpora from official repo
RUN git clone --depth 1 https://github.com/libjpeg-turbo/seed-corpora
RUN cd seed-corpora && zip -r ../decompress_fuzzer_seed_corpus.zip afl-testcases/jpeg* bugs/decompress*
RUN zip -r decompress_fuzzer_seed_corpus.zip libjpeg-turbo.main/testimages/*.jpg
RUN cd seed-corpora && zip -r ../compress_fuzzer_seed_corpus.zip afl-testcases/bmp afl-testcases/gif* afl-testcases/targa bugs/compress*
RUN zip -r compress_fuzzer_seed_corpus.zip libjpeg-turbo.main/testimages/*.bmp libjpeg-turbo.main/testimages/*.ppm
RUN rm -rf seed-corpora

COPY build.sh $SRC/
