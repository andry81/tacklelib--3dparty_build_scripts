* README.txt
* log4cxx

1. PREREQUISITES
2. CONFIGURE
3. BUILD
4. POSTINSTALL
5. CLEANUP

-------------------------------------------------------------------------------
1. PREREQUISITES
-------------------------------------------------------------------------------
1. Install Microsoft Visual Studio:
    - msvc2017 for x86/x64
2. patch log4cxx directory if not done yet:
    - apply patches from /_patches directory into log4cxx directory

-------------------------------------------------------------------------------
2. CONFIGURE
-------------------------------------------------------------------------------
1. run `preconfigure.bat`
2. run `configure.bat`
3. edit `configure.user.bat`

-------------------------------------------------------------------------------
3. BUILD
-------------------------------------------------------------------------------
run `build.bat`

-------------------------------------------------------------------------------
4. POSTINSTALL
-------------------------------------------------------------------------------
N/A

-------------------------------------------------------------------------------
5. CLEANUP
-------------------------------------------------------------------------------
Just remove out of source build directory associated with particular
architecture:

  `<root>/<architecture>/%BUILD_DIR%`
