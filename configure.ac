#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([hdcb], [0.1.0], [v3l0c1r4pt0r@gmail.com])
AC_CONFIG_SRCDIR([src/colour.c])
# AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([regex.h stddef.h stdint.h stdlib.h string.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_INLINE
AC_TYPE_INT8_T
AC_TYPE_OFF_T
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_CHECK_FUNCS([regcomp strtol])

AC_CONFIG_FILES([Makefile
                 examples/Makefile
                 scripts/Makefile
                 src/Makefile
                 scripts/hdcb
                 scripts/hdcb-func.sh])
AC_OUTPUT
