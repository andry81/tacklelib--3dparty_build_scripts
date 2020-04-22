@echo off

(
  echo.@echo off
  echo.
  echo.rem set "MINGW_ROOT=c:/Qt/Qt5_12_6/Tools/mingw730_32"
  echo.rem set "CYGWIN_ROOT=c:/cygwin/3.0.x"
  echo.rem set "MSYS_ROOT=c:/msys32/20190524/usr"
  echo.set "WINDOWS_SDK_ROOT=c:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A"
  echo.set SRC_BASE_GROUP=utility
  echo.set SRC_BASE_DIR=boost
  echo.set SRC_DIR=%%SRC_BASE_DIR%%-1_72_0-release
  echo.set BUILD_DIR=%%SRC_DIR%%-build
  echo.set TOOLSET=msvc-14.1
  echo.rem set TOOLSET=mingw_gcc
  echo.rem set TOOLSET=cygwin_gcc
  echo.rem set TOOLSET=msys_gcc
  echo.set VARIANT=release,debug
  echo.set ARCHITECTURE=x86
  echo.set ADDRESS_MODEL=32
  echo.set LINK_TYPE=shared
  echo.set RUNTIME_LINK=shared
  echo.set THREADING=multi
  echo.set BOOST_LIB_CONFIG_ARGS=debug-symbols=on "--build-dir=__build-%%TOOLSET%%-%%ADDRESS_MODEL%%"
) > "%~dp0configure.user.bat"
