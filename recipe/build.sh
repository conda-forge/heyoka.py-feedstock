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

echo "PYTHON env variable: $PYTHON"
echo "PREFIX: $PREFIX"
echo "CMAKE_ARGS: $CMAKE_ARGS"

"$PYTHON" -c 'import sys; print("Version:", sys.version)'
"$PYTHON" -c 'import sys; print("ABI flags:", repr(sys.abiflags))'
"$PYTHON" -c 'import sysconfig; print("Include:", sysconfig.get_path("include"))'
"$PYTHON" -c 'import sysconfig; print("Py_GIL_DISABLED:", sysconfig.get_config_var("Py_GIL_DISABLED"))'

find "$PREFIX/include" -name Python.h

cmake -G Ninja ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_REQUIRE_FIND_PACKAGE_Python3=ON \
    --debug-find-pkg=Python3 \
    -DPython3_EXECUTABLE=$PYTHON \
    -DPython3_NumPy_INCLUDE_DIR=`$PYTHON -c "import numpy as np;print(np.get_include())"` \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DHEYOKA_PY_ENABLE_IPO=$ENABLE_IPO \
    ..

ninja -j${CPU_COUNT} -v

ninja install
