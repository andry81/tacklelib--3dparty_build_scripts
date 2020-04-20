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

echo.PATH: "%PATH:;="&echo.PATH: "%"

if not exist "%BUILD_ROOT%\" mkdir "%BUILD_ROOT%"

call :CMD pushd "%%BUILD_ROOT%%" && (
  call :BUILD
  call :CMD popd
)

pause

exit /b

:BUILD
call :CMD cmake -G "%%CMAKE_GENERATOR%%" "%%BUILD_SRC%%" || exit /b 1

set VARIANT_VALUE_INDEX=1

:BUILD_LOOP
set "VARIANT_VALUE="
for /F "tokens=%VARIANT_VALUE_INDEX% delims=," %%i in ("%VARIANT%") do set "VARIANT_VALUE=%%i"
if "%VARIANT_VALUE%" == "" exit /b 0

call :CMD cmake --build . --config "%%VARIANT_VALUE%%" || exit /b

if /i "%VARIANT_VALUE%" == "debug" (
  set "MSVC_LIB_SUFFIX=d"
) else (
  set "MSVC_LIB_SUFFIX="
)

if not "%TOOLSET%" == "%TOOLSET:msvc-=%" (
  if not "%ADDRESS_MODEL%" == "64" (
    call :XCOPY_FILE "%%BUILD_ROOT%%\%%VARIANT_VALUE%%" "log4cpp.lib"    "%%BUILD_ROOT%%\lib\x86\%%VARIANT_VALUE%%" /Y /D /H || exit /b
  ) else (
    call :XCOPY_FILE "%%BUILD_ROOT%%\%%VARIANT_VALUE%%" "log4cpp.lib"    "%%BUILD_ROOT%%\lib\x64\%%VARIANT_VALUE%%" /Y /D /H || exit /b
  )
)

echo.

set /A VARIANT_VALUE_INDEX+=1

goto BUILD_LOOP

:XCOPY_FILE
if not exist "%CONTOOLS_ROOT%/std/xcopy_file.bat" (
  echo.%?~nx0%: error: xcopy_file.bat is not found: "%CONTOOLS_ROOT%/std/xcopy_file.bat".
  exit /b 5
) >&2
if not exist "%~3" mkdir "%~3"
call "%%CONTOOLS_ROOT%%/std/xcopy_file.bat" %%* || exit /b
exit /b 0

:CMD
echo.^>%*
(
  %*
)
