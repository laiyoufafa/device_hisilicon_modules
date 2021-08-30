echo `pwd`
CUR_DIR=$(pwd)
CFG_CHIP_TYPE=$1
CFG_OS_TYPE=$2
CFG_COMPILE_TYPE=$3
CFG_LINUX_COMPILER_VER=$4
CFG_OHOS_BUILD_PATH=$5

echo "CFG_CHIP_TYPE=${CFG_CHIP_TYPE} CFG_OS_TYPE=${CFG_OS_TYPE} CFG_LINUX_COMPILER_VER=${CFG_LINUX_COMPILER_VER} CFG_OHOS_BUILD_PATH=${CFG_OHOS_BUILD_PATH}"
#if [ "${CFG_COMPILE_TYPE}" == "clang" ]; then
CFG_SDK_TOOLCHAIN=$CFG_OHOS_BUILD_PATH/
#else
#    if [ "${CFG_OS_TYPE}" == "ohos" ]; then
#        CFG_SDK_TOOLCHAIN=$CFG_OHOS_BUILD_PATH/arm-linux-ohoseabi-
#    else
#        CFG_SDK_TOOLCHAIN=arm-$CFG_LINUX_COMPILER_VER-linux-
#    fi
#fi

configure_attr=" --prefix=./install \
    --disable-autodetect \
    --enable-cross-compile \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    --target-os=linux \
    --enable-shared \
    --disable-static \
    --disable-swscale-alpha \
    --disable-debug \
    --disable-iconv  \
    --enable-small \
    --disable-network \
    --disable-filters \
    --disable-devices \
    --disable-programs \
    --disable-ffplay \
    --disable-swresample \
    --disable-swscale \
    --disable-avdevice \
    --disable-postproc \
    --disable-avfilter \
    --disable-protocols \
    --disable-pthreads \
    --disable-runtime-cpudetect \
    --disable-faan
    --disable-everything   \
    --enable-pic \
    --enable-protocol=file \
    --disable-muxers \
    --enable-demuxer=mov\
    --enable-demuxer=mpegts\
    --enable-demuxer=mp3 \
    --enable-parser=hevc \
    --enable-parser=h264 \
    --enable-decoder=mp2 \
    --enable-decoder=mp3 \
    --disable-neon \
    --disable-inline-asm \
    --disable-asm \
    --disable-armv6 \
    --disable-armv6t2 \
    --disable-armv5te \
    --disable-vfp \
    --disable-hardcoded-tables \
    --disable-mediacodec \
    --disable-mediafoundation \
    --enable-bsf=h264_mp4toannexb \
    --enable-bsf=hevc_mp4toannexb \
    --disable-pixelutils \
    --enable-demuxer=wav \
    --disable-gpl \
    --disable-zlib \
    --disable-w32threads --disable-os2threads --disable-alsa --disable-appkit --disable-avfoundation \
    --disable-bzlib --disable-coreimage --disable-iconv --disable-libxcb --disable-libxcb-shm \
    --disable-libxcb-xfixes --disable-libxcb-shape --disable-lzma --disable-sndio --disable-schannel \
    --disable-sdl2 --disable-securetransport --disable-xlib --disable-amf --disable-audiotoolbox \
    --disable-cuda-llvm --disable-cuvid --disable-nvdec --disable-nvenc --disable-vaapi --disable-vdpau \
    --disable-videotoolbox --disable-ossfuzz --disable-swscale-alpha \
    --disable-valgrind-backtrace \
    --disable-linux-perf \
    --disable-large-tests \
    --cpu=cortex-a7 --arch=armv7-a --cross-prefix=${CFG_SDK_TOOLCHAIN} "


if [ "${CFG_CHIP_TYPE}" == "hi3559"  -o  "${CFG_CHIP_TYPE}" == "hi3556" ]; then
echo "hi3559/hi3556 =? ${CFG_CHIP_TYPE}"
configure_attr+=" --cpu=cortex-a7 --arch=armv7-a --cross-prefix=${CFG_SDK_TOOLCHAIN} "
fi

if [ "${CFG_CHIP_TYPE}" == "hi3559v200" ]; then
echo "hi3559v200 =? ${CFG_CHIP_TYPE}"
configure_attr+=" --cpu=cortex-a7 --arch=armv7-a --cross-prefix=${CFG_SDK_TOOLCHAIN} "
fi

if [ "${CFG_CHIP_TYPE}" == "hi3516dv300" ]; then
echo "###########hi3516dv300 =? ${CFG_CHIP_TYPE}########"
#configure_attr+=" --cpu=cortex-a7 --arch=armv7-a --cross-prefix=${CFG_SDK_TOOLCHAIN} "
fi

if [ "${CFG_CHIP_TYPE}" == "hi3518ev300" ]; then
echo "hi3518ev300 =? ${CFG_CHIP_TYPE}"
configure_attr+=" --cpu=cortex-a7 --arch=armv7-a --cross-prefix=${CFG_SDK_TOOLCHAIN} "
fi

echo "###################################"
echo ${configure_attr}
echo ${CFG_SDK_TOOLCHAIN}
echo "###################################"
export http_proxy=""
export https_proxy=""
export no_proxy=""

sed -i "/^LD=/cLD=$CFG_OHOS_BUILD_PATH/clang" configure_temp

${CFG_CONFIGURE:=./configure_temp} ${configure_attr} --extra-cflags="-mfloat-abi=softfp -mfpu=neon-vfpv4 -fPIC -fstack-protector-all -s -ftrapv" --extra-ldflags="-Wl,-z,relro,-z,now -fPIC"
