* README.txt
* gmock

1. PREREQUISITES
2. CONFIGURE
3. BUILD
4. POSTINSTALL
5. CLEANUP

-------------------------------------------------------------------------------
1. PREREQUISITES
-------------------------------------------------------------------------------
1. Install Microsoft Visual Studio:
    - msvc2015 for vc14_x64 + Update 3
    - msvc2017 for x86/x64

-------------------------------------------------------------------------------
2. CONFIGURE
-------------------------------------------------------------------------------
1. run `preconfigure.bat` from the `_build` directory.
2. run `configure.bat` from the `_build` directory.
3. edit `configure.user.bat`.

-------------------------------------------------------------------------------
3. BUILD
-------------------------------------------------------------------------------
run `build.bat` from the `_build` directory

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
