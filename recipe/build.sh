#! /usr/bin/bash
set -e

# upstream CMakeLists.txt still declares cmake_minimum_required 2.8.7, which
# CMake 4 rejects
sed -i 's/cmake_minimum_required (VERSION 2.8.7)/cmake_minimum_required(VERSION 3.15...3.31)/g' source/CMakeLists.txt

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)

# COLLIER builds either a static or a shared library. MG5_aMC links its
# generated code against libcollier.a, so build both: static first, then
# shared, so the CMake config installed last points at the shared library.
for static in ON OFF; do
  cmake ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DCMAKE_Fortran_COMPILER="${FC}" \
    -Dstatic=${static} -S source -B build-static-${static}
  cmake --build build-static-${static} --parallel="${NPROC}"
  cmake --install build-static-${static}
done
