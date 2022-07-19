netX ARM GCC Toolchain
======================

Overview:
---------
This project evolved when a GCC was needed for Linux and new compiler generations for the netX were evaluated.
It is a generic build script for ARM9 cores with special ARM926EJ-S / ARM966E optimizations as the currently
used Hitex toolchain has.

These scripts should help others to cross compile newer GCC version, but are currently only used internally
for projects on the Hilscher netX chips.

Usage:
======
Just execute the build.sh script to build the GCC toolchain. 

The following commands can be passed:

"all" - Rebuilds from source completely

Partial Targets:
"clean"   - cleanup temporary files
"get"     - Download all neccessary files
"extract" - Extract and prepare the downloaded sources
"compile" - Compile extracted sources
"archive" - Build an archive for distribution

Generic Build process and help:
-------------------------------
1.  cd [binutils-build]
2. [binutils-source]/configure --target=arm-elf --prefix=[toolchain-prefix] --enable-interwork --enable-multilib
3. make all install
4. export PATH="$PATH:[toolchain-prefix]/bin"
5. cd [gcc-build]
6. [gcc-source]/configure --target=arm-elf --prefix=[toolchain-prefix] --enable-interwork --enable-multilib --enable-languages="c,c++" --with-newlib --with-headers=[newlib-source]/newlib/libc/include --disable-libstdcxx-pch --disable-libssp
6a(GCC > 4.5) --enable-lto --with-system-zlib
7. make all-gcc install-gcc
8. cd [newlib-build]
9. [newlib-source]/configure --target=arm-elf --prefix=[toolchain-prefix] --enable-interwork --enable-multilib
10. make all install
11. cd [gcc-build]
12. make all install
13. cd [gdb-build]
14a(Linux). [gdb-source]/configure --target=arm-elf --prefix=[toolchain-prefix] --enable-interwork --enable-multilib
14b(MinGw). [gdb-source]/configure --target=arm-elf --prefix=[toolchain-prefix] --enable-interwork --enable-multilib --enable-gdbtk --with-expat=yes
14c(cvs). --disable-newlib --disable-binutils --disable-ld --disable-gold --with-libelf=/home/Guru/crosscompiler/temp --disable-sid --disable-libgloss --disable-rda --disable-gas
15. make all install 			       

Notes:
 MinGW:
  - Compiling gcc may abort with an error in sys/types.h ("typedef char * caddr_t"). For some reason the compiler
    expands this to "typedef char * char *" which does not work. Temporarily removing this line from "sys/types.h"
    fixes this problem. Make sure to insert this line, before distributing this toolchain.
