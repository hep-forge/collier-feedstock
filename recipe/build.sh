#! /usr/bin/bash
set -e

# upstream CMakeLists.txt still declares cmake_minimum_required 2.8.7, which
# CMake 4 rejects
sed -i 's/cmake_minimum_required (VERSION 2.8.7)/cmake_minimum_required(VERSION 3.15...3.31)/g' source/CMakeLists.txt

cmake ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DCMAKE_Fortran_COMPILER="${FC}" -S source -B build

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
cmake --build build --parallel="${NPROC}"
cmake --install build
