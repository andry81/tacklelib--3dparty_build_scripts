@echo off

setlocal

call "%%~dp0__init__.bat" || exit /b

if %IMPL_MODE%0 NEQ 0 goto IMPL

rem no local logging if nested call
set WITH_LOGGING=0
if %NEST_LVL%0 EQU 0 set WITH_LOGGING=1

if %WITH_LOGGING% EQU 0 goto IMPL

if not exist "%CONFIGURE_DIR%\.log" mkdir "%CONFIGURE_DIR%\.log"

rem use stdout/stderr redirection with logging
call "%%CONTOOLS_ROOT%%\get_datetime.bat"
set "LOG_FILE_NAME_SUFFIX=%RETURN_VALUE:~0,4%'%RETURN_VALUE:~4,2%'%RETURN_VALUE:~6,2%_%RETURN_VALUE:~8,2%'%RETURN_VALUE:~10,2%'%RETURN_VALUE:~12,2%''%RETURN_VALUE:~15,3%"

set IMPL_MODE=1
"%COMSPEC%" /C call %0 %* 2>&1 | "%CONTOOLS_ROOT%\wtee.exe" "%CONFIGURE_DIR%\.log\%LOG_FILE_NAME_SUFFIX%.%~n0.log"
exit /b

:IMPL
set /A NEST_LVL+=1

set "PATH=%PATH%;%QT_ROOT%/bin"

echo.PATH: "%PATH:;="&echo.PATH: "%"

if not exist "%QT_ROOT%" (
  echo.%~nx0: error: QT_ROOT does not exist.
  exit /b 1
) >&2

if not "%TOOLSET%" == "%TOOLSET:msvc-=%" (
  echo.Registering %TOOLSET% %MSVC_ARCHITECTURE%...
)

rem msvc 2017 search based on: https://renenyffenegger.ch/notes/Windows/development/Visual-Studio/environment-variables/index
rem

if "%TOOLSET%" == "msvc-14.1" (
  for /f "usebackq tokens=* delims=" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere" -latest -property installationPath`) do (
    set "MSVC2017_INSTALL_ROOT=%%i"
    call "%%MSVC2017_INSTALL_ROOT%%\Common7\Tools\VsDevCmd.bat"
    call "%%VCINSTALLDIR%%\Auxiliary\Build\vcvarsall.bat" %%MSVC_ARCHITECTURE%%
  )
) else if "%TOOLSET%" == "msvc-14.0" (
  call "%%VS140COMNTOOLS%%\..\..\VC\vcvarsall.bat" %%MSVC_ARCHITECTURE%%
) else if "%TOOLSET%" == "msvc-12.0" (
  call "%%VS120COMNTOOLS%%\..\..\VC\vcvarsall.bat" %%MSVC_ARCHITECTURE%%
) else if "%TOOLSET%" == "msvc-10.0" (
  call "%%VS100COMNTOOLS%%\..\..\VC\vcvarsall.bat" %%MSVC_ARCHITECTURE%%
) else (
  echo.%~nx0: error: TOOLSET build is not supported: "%TOOLSET%"
  exit /b 127
) >&2

if not "%TOOLSET%" == "%TOOLSET:msvc-=%" (
  call :CMD where cl || exit /b
  call :CMD where rc || exit /b
)

if not exist "%BUILD_ROOT%\" mkdir "%BUILD_ROOT%"

call :CMD pushd "%%BUILD_ROOT%%" && (
  rem generate nmake
  call :CMD qmake -r "CONFIG += force_debug_info skip_target_version_ext" -spec %%QMAKE_GENERATOR_TOOLSET%% %%QMAKE_CMD_LINE%% "%%BUILD_SRC%%/qwt.pro"
  call :CMD popd
)

if %ERRORLEVEL% NEQ 0 goto EXIT

call :CMD pushd "%%BUILD_ROOT%%" && (
  rem run nmake
  if not "%TOOLSET%" == "%TOOLSET:msvc-=%" (
    call :CMD nmake && call :CMD nmake install
  ) else if not "%TOOLSET%" == "%TOOLSET:mingw_=%" (
    call :CMD make && call :CMD make install
  ) else if not "%TOOLSET%" == "%TOOLSET:cygwin_=%" (
    call :CMD make && call :CMD make install
  )
  call :CMD popd
)

:EXIT
pause

exit /b

:CMD
echo.^>%*
(%*)
