@echo off

(
  echo.@echo off
  echo.
  echo.set "USER_PATH=c:/Program Files/CMake3/bin"
  echo.set SRC_BASE_GROUP=net
  echo.set SRC_BASE_DIR=protobuf
  echo.set SRC_DIR=protobuf-3_5_1-release
  echo.set BUILD_DIR=%%SRC_DIR%%
  echo.set TOOLSET=msvc-14.1
  echo.set ADDRESS_MODEL=32
  echo.set VARIANT=release,debug
  echo.rem CAUTION:
  echo.rem   In case of build of multiple MODULES (DLL+DLL or DLL+EXE) with linkage
  echo.rem   to the single `libprotobuf` module YOU MUST to enable MSVC Static Runtime
  echo.rem   (/MT*), otherwise there will be the protobuf double initialization
  echo.rem   runtime error: `descriptor_database.cc:58 File already exists in
  echo.rem   database Descriptors`. The `protobuf` uses static field constructor to
  echo.rem   initialize a global storage with the descriptors which in case of the
  echo.rem   MSVC Shared Runtime will be placed in the same memory address and will
  echo.rem   be initialized each time when the static constructor being called!
  echo.rem
  echo.set protobuf_MSVC_STATIC_RUNTIME=ON
  echo.set protobuf_BUILD_SHARED_LIBS=ON
  echo.set protobuf_BUILD_TESTS=OFF
) > "%~dp0configure.user.bat"
