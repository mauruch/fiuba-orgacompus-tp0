#ifndef _DEBUG_H_INCLUDED_
#define _DEBUG_H_INCLUDED_

#include <stdio.h>
#include <stdlib.h>

#ifdef DEBUG
#define ASSERT(expr)                                                         \
	do {                                                                 \
		if (!(expr)) {                                               \
			fprintf(stderr,                                      \
			        "panic: assertion %s failed: %s() %s:%d.\n", \
			        (#expr),                                     \
			        __FUNCTION__,                                \
			        __FILE__,                                    \
			        __LINE__);                                   \
			fflush(stderr);                                      \
			abort();                                             \
		}                                                            \
	} while (0)
#else
#define ASSERT(expr) do { } while (0)
#endif

#endif
