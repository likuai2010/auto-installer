#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[]);
FFI_PLUGIN_EXPORT void hdcServer(void);
FFI_PLUGIN_EXPORT int signCmd(int argc, const char *args[]);
FFI_PLUGIN_EXPORT char *uzip(const char *source, const char *fileName, const char *destination);
