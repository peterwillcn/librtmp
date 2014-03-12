#!/bin/sh

TOOLCHAIN=/tmp/Shou
$ANDROID_NDK/build/tools/make-standalone-toolchain.sh --toolchain=arm-linux-androideabi-4.8 \
  --system=linux-x86_64 --platform=android-19 --install-dir=$TOOLCHAIN

SSL=`pwd`/../openssl

CFLAGS="-std=c99 -O3 -Wall -marm -pipe -fpic -fasm \
  -march=armv7-a -mfpu=neon -mfloat-abi=hard -mvectorize-with-neon-quad \
  -mhard-float -D_NDK_MATH_NO_SOFTFP=1 -fdiagnostics-color=always \
  -finline-limit=300 -ffast-math \
  -fstrict-aliasing -Werror=strict-aliasing \
  -fmodulo-sched -fmodulo-sched-allow-regmoves \
  -Wno-psabi -Wa,--noexecstack \
  -D__ARM_ARCH_5__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5TE__ \
  -DANDROID -DNDEBUG -I$SSL/include"

LDFLAGS="-lm_hard -lz -Wl,--no-undefined -Wl,-z,noexecstack \
  -Wl,--no-warn-mismatch -Wl,--fix-cortex-a8 -L$SSL/obj/local/armeabi-v7a"

cd librtmp
make clean
PATH=/tmp/shou/bin:$PATH CROSS_COMPILE=arm-linux-androideabi- make CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" SHARED=
