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

FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[], const char *tempDir);
FFI_PLUGIN_EXPORT int hdcServer(const char *tempPath);

FFI_PLUGIN_EXPORT int signCmd(int argc, const char *args[], const char *tempDir);
FFI_PLUGIN_EXPORT int unHap(const char *source, const char *fileName, const char *destination);
FFI_PLUGIN_EXPORT int unApp(const char *source, const char *destination);

FFI_PLUGIN_EXPORT const char* native_jvm(const char* optionsString, const char* mainClass, const char* args[], int argc, const char* libjvm_path);