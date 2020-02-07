@echo off

rem double setlocal to restore environment before the call to bash and after
setlocal
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

if not exist "%CYGWIN_PATH%" (
  echo.%~nx0: error: CYGWIN_PATH does not exist.
  exit /b 1
) >&2

if "%ADDRESS_MODEL%" == "64" (
  if not exist "%PYTHON64_PATH%" (
    echo.%~nx0: error: PYTHON64_PATH does not exist.
    exit /b 2
  ) >&2
) else (
  if not exist "%PYTHON_PATH%" (
    echo.%~nx0: error: PYTHON_PATH does not exist.
    exit /b 2
  ) >&2
)

rem drop last error level
cd .

set "PATH=%PATH%;%CYGWIN_PATH%\bin"

if "%ADDRESS_MODEL%" == "64" (
  set OMNIORB_ARCHITECTURE=win64
  set "PATH=%PATH%;%PYTHON64_PATH%"
) else (
  set OMNIORB_ARCHITECTURE=win32
  set "PATH=%PATH%;%PYTHON_PATH%"
)

if "%TOOLSET%" == "msvc-14.0" (
  set OMNIORB_PLATFORM=x86_%OMNIORB_ARCHITECTURE%_vs_14
) else if "%TOOLSET%" == "msvc-12.0" (
  set OMNIORB_PLATFORM=x86_%OMNIORB_ARCHITECTURE%_vs_12
) else if "%TOOLSET%" == "msvc-10.0" (
  set OMNIORB_PLATFORM=x86_%OMNIORB_ARCHITECTURE%_vs_10
)

rem save going to change the current directory into a variable
set "CWD=%BUILD_BASE_PATH%\%SRC_DIR%\src"

(
  rem drop all local variables..
  endlocal

  rem ..except this
  set "CWD=%CWD%"
  set "PATH=%PATH%"
  set "OMNIORB_PLATFORM=%OMNIORB_PLATFORM%"
  if "%ADDRESS_MODEL%" == "64" (
    set "PYTHONHOME=%PYTHON64_PATH:\=/%"
    set "PYTHONPATH=%PYTHON64_PATH:\=/%/Lib"
    set "PYTHON=%PYTHON64_PATH:\=/%/python.exe"
  ) else (
    set "PYTHONHOME=%PYTHON_PATH:\=/%"
    set "PYTHONPATH=%PYTHON_PATH:\=/%/Lib"
    set "PYTHON=%PYTHON_PATH:\=/%/python.exe"
  )

  rem register here more environment before the call to bash shell
  if "%TOOLSET%" == "msvc-14.0" (
    call "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" %MSVC_ARCHITECTURE%
  ) else if "%TOOLSET%" == "msvc-12.0" (
    call "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" %MSVC_ARCHITECTURE%
  ) else if "%TOOLSET%" == "msvc-10.0" (
    call "%VS100COMNTOOLS%\..\..\VC\vcvarsall.bat" %MSVC_ARCHITECTURE%
  )

  rem call procedure with prepared environment
  call :EXEC "%%~dp0build.sh"

  rem drop all local variables again
  endlocal
)

pause 

goto :EOF

:EXEC
rem replace all backslashes to forward
set "EXEC_CMD=%~1"
set EXEC_CMD=bash -c "%EXEC_CMD:\=/%"

call :CMD pushd "%%CWD%%" && (
  rem make a call with drop of some variables
  set "EXEC_CMD="
  set "CWD="

  echo.^>%EXEC_CMD%
  %EXEC_CMD%

  popd
)

exit /b
