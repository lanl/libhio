# -*- mode: shell-script -*-
# Copyright 2015-2016 Los Alamos National Security, LLC. All rights
#                     reserved.

AC_DEFUN([HIO_CHECK_CVERSION],[
    AC_MSG_CHECKING([for flag to enable C11 support])
    hio_check_cversion_cflags_save="$CFLAGS"
    CFLAGS="$CFLAGS -std=c11"
    hio_check_cversion_cflags_c11=0
    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
                      [AC_MSG_RESULT([yes])
                       hio_check_cversion_cflags_c11=1],
                      [AC_MSG_RESULT([no])])
    if test $hio_check_cversion_cflags_c11 = 0 ; then
        CFLAGS="$hio_check_cversion_cflags_save"
        AC_PROG_CC_C99
    fi

    AC_MSG_CHECKING([for C11 atomics])
    hio_check_cversion_c11_atomics=0
    hio_check_cversion_sync_atomics=0
    AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <stdatomic.h>
                                      #include <stdint.h>
                                      atomic_ulong x;]],
                                    [[atomic_init(&x, 0);]])],
                   [AC_MSG_RESULT([yes])
                    hio_check_cversion_c11_atomics=1],[AC_MSG_RESULT([no])])
    if test $hio_check_cversion_c11_atomics = 0 ; then
        AC_MSG_CHECKING([for sync builtin atomics])
        AC_LINK_IFELSE([AC_LANG_PROGRAM([[unsigned long x = 0;]],[[__sync_fetch_and_add(&x, 1);]])],
                       [AC_MSG_RESULT([yes])
                       hio_check_cversion_sync_atomics=1],[AC_MSG_RESULT([no])])
    fi

    AC_DEFINE_UNQUOTED([HIO_ATOMICS_C11], [$hio_check_cversion_c11_atomics], [Whether to use C11 atomics])
    AC_DEFINE_UNQUOTED([HIO_ATOMICS_SYNC], [$hio_check_cversion_sync_atomics], [Whether to use __sync atomics])
])
