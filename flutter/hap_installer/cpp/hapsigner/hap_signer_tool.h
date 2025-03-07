
#ifdef __APPLE__
#include <libkern/OSByteOrder.h>
#define be16toh(x) OSSwapBigToHostInt16(x)
#define le16toh(x) OSSwapLittleToHostInt16(x)
#define be32toh(x) OSSwapBigToHostInt32(x)
#define le32toh(x) OSSwapLittleToHostInt32(x)
#define be64toh(x) OSSwapBigToHostInt64(x)
#define le64toh(x) OSSwapLittleToHostInt64(x)
#endif
#ifdef _WIN32
#include <winsock2.h>
#include <windows.h>
#include <stdint.h>
#include <intrin.h>
#define be16toh(x) ntohs(x)
#define le16toh(x) (x)
#define be32toh(x) ntohl(x)
#define le32toh(x) (x)
#define be64toh(x) _byteswap_uint64(x)
#define le64toh(x) (x)
#endif