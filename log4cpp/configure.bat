@echo off

(
  echo.@echo off
  echo.
  echo.set "USER_PATH=c:/Program Files/CMake3/bin"
  echo.set SRC_BASE_GROUP=log
  echo.set SRC_BASE_DIR=log4cpp
  echo.set SRC_DIR=log4cpp-1_1_3-release
  echo.set BUILD_DIR=%%SRC_DIR%%
  echo.set TOOLSET=msvc-14.1
  echo.set ADDRESS_MODEL=32
  echo.set VARIANT=release,debug
  echo.rem set CMAKE_POLICY_DEFAULT_CMP0091=NEW
  echo.rem set "CMAKE_MSVC_RUNTIME_LIBRARY=MultiThreaded$<$<CONFIG:Debug>:Debug>"
) > "%~dp0configure.user.bat"
