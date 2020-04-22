* README.txt
* boost

1. PREREQUISITES
2. CONFIGURE
3. BUILD
4. CLEANUP

-------------------------------------------------------------------------------
1. PREREQUISITES
-------------------------------------------------------------------------------
1. Install Microsoft Visual Studio:
    - msvc2015 for vc14_x86/vc14_x64 + Update 3
    - msvc2017 for x86/x64
2. Read internet:
   a. Unknown compiler version while compiling Boost with MSVC 14.0 (VS 2015):
      http://stackoverflow.com/questions/30760889/unknown-compiler-version-while-compiling-boost-with-msvc-14-0-vs-2015
3. patch boost directory if not done yet:
    - apply patches from /_patches directory into boost directory

-------------------------------------------------------------------------------
2. CONFIGURE
-------------------------------------------------------------------------------
1. run `preconfigure.bat`
2. run `bootstrap.bat` from the BUILD_ROOT directory
3. run `configure.bat`
4. edit `configure.user.bat`

-------------------------------------------------------------------------------
3. BUILD
-------------------------------------------------------------------------------
run `build.bat`

-------------------------------------------------------------------------------
4. CLEANUP
-------------------------------------------------------------------------------
Just remove out of source build directory associated with particular
architecture:

  `<root>/<architecture>/%BUILD_DIR%`
