mkdir build
cd build

cmake ^
    -G "Visual Studio 17 2022" -A x64 ^
    -DPython3_EXECUTABLE=%PREFIX%\python.exe ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DHEYOKA_PY_ENABLE_IPO=yes ^
    ..

cmake --build . --config Release --target install -j%CPU_COUNT%
