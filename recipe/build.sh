#!/usr/bin/env bash

# IPO setup.
if [[ "$target_platform" == linux-ppc64le ]]; then
    export ENABLE_IPO=no
else
    export ENABLE_IPO=yes
fi

if [[ "$target_platform" == osx-* ]]; then
    # Workaround for compile issue on older OSX SDKs.
    export CXXFLAGS="$CXXFLAGS -fno-aligned-allocation -D_LIBCPP_DISABLE_AVAILABILITY"
fi

mkdir build
cd build

cmake -G Ninja ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DPython3_EXECUTABLE=$PREFIX/bin/python \
    -DPython3_NumPy_INCLUDE_DIR=`python -c "import numpy as np;print(np.get_include())"` \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DHEYOKA_PY_ENABLE_IPO=$ENABLE_IPO \
    ..

ninja -j${CPU_COUNT} -v

ninja install
