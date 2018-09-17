#!/bin/bash

#!/usr/bin/env sh
#NDK_ROOT="${1:-${NDK_ROOT}}"
NDK_ROOT=${ANDROID_NDK_ROOT}

### ABI setup
declare -a ANDROID_ABI_LIST=("arm64-v8a" "armeabi-v7a with NEON")

### path setup
SCRIPT=$(readlink -f $0)
WD=`dirname $SCRIPT`
SOURCE_ROOT=${WD}/gflags
echo $GLOG_ROOT

BUILD_DIR=${SOURCE_ROOT}/build
INSTALL_DIR=${WD}/android_glog
N_JOBS=${N_JOBS:-8}

if [ "${ANDROID_ABI}" = "armeabi" ]; then
    API_LEVEL=19
else
    API_LEVEL=21
fi

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"


# First argument is abi type (armeabi-v7a, x86)
function build_impl {
  ABI=$1

  echo "Building Opencv for $ABI"
  mkdir build_$ABI
  cd build_$ABI

# collect install directories to build/install
  cmake -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
      -DCMAKE_TOOLCHAIN_FILE="${NDK_ROOT}/build/cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
      -DANDROID_ARM_NEON=ON \
      -DANDROID_ABI="$ABI" \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=OFF \
      -DANDROID_STL="c++_static" \
      ../../
  make -j${N_JOBS}

  cd ../
}

build_impl armeabi-v7a
build_impl arm64-v8a


cd "${WD}"
#rm -rf "${BUILD_DIR}"


