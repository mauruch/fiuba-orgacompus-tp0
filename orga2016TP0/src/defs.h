#ifndef _DEFS_H_INCLUDED_
#define _DEFS_H_INCLUDED_

#ifdef SUNOS5
/*
 * Solaris 9 no tiene <stdint.h>
 */
#define MISSING_STDINT_H

/*
 * Tampoco parece estar <getopt.h>
 */
#define MISSING_GETOPT

/*
 * Includes complementarios.
 */
#include <sys/types.h>
#endif

#ifdef MISSING_GETOPT
#include <mygetopt.h>
#else
#include <getopt.h>
#endif

#ifndef MISSING_STDINT_H
#include <stdint.h>
#endif

#include <ctype.h>

/*
 * Turn on format string argument checking. This is more accurate than
 * printfck, but it misses #ifdef-ed code. XXX I am just guessing at what
 * gcc versions support this. In order to turn this off for some platforms,
 * specify #define PRINTFLIKE and #define SCANFLIKE in the system-dependent
 * sections above.
 */
#ifndef PRINTFLIKE
#if (__GNUC__ == 2 && __GNUC_MINOR__ >= 7) || __GNUC__ == 3
#define PRINTFLIKE(x, y) __attribute__ ((format (printf, (x), (y))))
#else
#define PRINTFLIKE(x, y)
#endif
#endif

/*
 * Need to specify what functions never return, so that the compiler can
 * warn for missing initializations and other trouble. However, OPENSTEP4
 * gcc 2.7.x cannot handle this so we define this only if NORETURN isn't
 * already defined above.
 *
 * Data point: gcc 2.7.2 has __attribute__ (Wietse Venema) but gcc 2.6.3 does
 * not (Clive Jones). So we'll set the threshold at 2.7.
 */
#ifndef NORETURN
#if (__GNUC__ == 2 && __GNUC_MINOR__ >= 7) || __GNUC__ >= 3
#define NORETURN void __attribute__((__noreturn__))
#endif
#endif

#ifndef NORETURN
#define NORETURN void
#endif

/*
 * Safety. On some systems, ctype.h misbehaves with non-ASCII or negative
 * characters. More importantly, Postfix uses the ISXXX() macros to ensure
 * protocol compliance, so we have to rule out non-ASCII characters.
 */
#define _UCHAR_(c) ((unsigned char)(c))
#define ISASCII(c) (isascii(_UCHAR_(c)))
#define ISPRINT(c) (ISASCII(c) && isprint(_UCHAR_(c)))
#define ISSPACE(c) (ISASCII(c) && isspace(_UCHAR_(c)))

#endif
