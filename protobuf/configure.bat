@echo off

(
  echo.@echo off
  echo.
  echo.set "USER_PATH=c:/Program Files/CMake3/bin"
  echo.set SRC_BASE_GROUP=net
  echo.set SRC_BASE_DIR=protobuf
  echo.set SRC_DIR=protobuf-3_5_0-release
  echo.set BUILD_DIR=%%SRC_DIR%%
  echo.set TOOLSET=msvc-14.1
  echo.set ADDRESS_MODEL=32
  echo.set VARIANT=release,debug
  echo.set protobuf_MSVC_STATIC_RUNTIME=OFF
  echo.set protobuf_BUILD_SHARED_LIBS=ON
) > "%~dp0configure.user.bat"
