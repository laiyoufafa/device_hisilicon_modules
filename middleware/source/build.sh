#!/bin/bash
# Copyright (c) 2021 HiSilicon (Shanghai) Technologies CO., LIMITED.
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
#
# Compile middleware project, this is the entrance script

# error out on errors
set -e
OUT_DIR="$1"
BOARD_NAME="$2"
HOS_KERNEL_TYPE="$3"
BUILD_COMPILER="$4"
OHOS_BUILD_PATH="$5"
COMPILER_VER="$6"

function main(){
    CUR_DIR=$(cd $(dirname "$0");pwd)
    ROOT_DIR=$CUR_DIR/../../../../..
    unset OS_TYPE
    COMPILER_TYPE=$BUILD_COMPILER
    if [ "$HOS_KERNEL_TYPE" = "liteos_a" ];then
        OS_TYPE="ohos"
    elif [ "$HOS_KERNEL_TYPE" = "linux" ];then
        OS_TYPE="linux"
    fi
    if [ "$BUILD_COMPILER" = "llvm" ];then
        COMPILER_TYPE="clang"
    fi
    echo "###### $BOARD_NAME:$OS_TYPE:$COMPILER_VER;$COMPILER_TYPE;$BUILD_COMPILER ######"
    cat <<-EOF >$ROOT_DIR/device/hisilicon/third_party/ffmpeg/cfg.mak
	CFG_CHIP_TYPE=$BOARD_NAME
	CFG_OS_TYPE=$OS_TYPE
	CFG_COMPILE_TYPE=$COMPILER_TYPE
	CFG_LINUX_COMPILER_VER=$COMPILER_VER
	CFG_OHOS_BUILD_PATH=$OHOS_BUILD_PATH
	EOF
    cd $ROOT_DIR/device/hisilicon/third_party/ffmpeg; make clean; make -j; cd -;

    cp -rf $ROOT_DIR/device/hisilicon/third_party/ffmpeg/ffmpeg-y/install/lib/libavcodec.so $OUT_DIR/
    cp -rf $ROOT_DIR/device/hisilicon/third_party/ffmpeg/ffmpeg-y/install/lib/libavformat.so $OUT_DIR/
    cp -rf $ROOT_DIR/device/hisilicon/third_party/ffmpeg/ffmpeg-y/install/lib/libavutil.so $OUT_DIR/

    cp -rf $CUR_DIR/component/fileformat/mp4/lib/$BUILD_COMPILER/$OS_TYPE/libmp4.so $OUT_DIR/
    cp -rf $CUR_DIR/component/fileformat/ts/lib/$BUILD_COMPILER/$OS_TYPE/libts.so $OUT_DIR/
    cp -rf $CUR_DIR/component/fileformat/exif/lib/$BUILD_COMPILER/$OS_TYPE/libexif.so $OUT_DIR/
    cp -rf $CUR_DIR/component/fileformat/common/lib/$BUILD_COMPILER/$OS_TYPE/libfileformat.so $OUT_DIR/
    cp -rf $CUR_DIR/component/recorder_pro/lib/$BUILD_COMPILER/$OS_TYPE/librecorder_pro.so $OUT_DIR/
    cp -rf $CUR_DIR/component/dtcf/lib/$BUILD_COMPILER/$OS_TYPE/libdtcf.so $OUT_DIR/
    cp -rf $CUR_DIR/component/fstool/lib/$BUILD_COMPILER/$OS_TYPE/libfstool.so $OUT_DIR/
    cp -rf $CUR_DIR/common/hitimer/lib/$BUILD_COMPILER/$OS_TYPE/libhitimer.so $OUT_DIR/
    cp -rf $CUR_DIR/common/mbuffer/lib/$BUILD_COMPILER/$OS_TYPE/libmbuf.so $OUT_DIR/
    cp -rf $CUR_DIR/common/log/lib/$BUILD_COMPILER/$OS_TYPE/libmwlog.so $OUT_DIR/
}

main "$@"
