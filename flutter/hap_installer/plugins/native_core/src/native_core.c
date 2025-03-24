#include "native_core.h"

#ifndef _WIN32
#include <libgen.h>
#include "hdc.h"
#include "un_hap.h"
#include "hap_signer_tool.h"
#else
#include "un_hap.h"
#endif

FILE *sout = NULL;
FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[], const char *tempDir)
{
  int ret = 0;
#ifdef _WIN32
  ret = 404;
#elif __OHOS__
  ret = 404;
#else
  FILE *sout = freopen(tempDir, "w", stdout);
  FILE *serr = freopen(tempDir, "w", stderr);
  const char *dir = dirname(tempDir);
  ret = cmd(argc, args, dir);
  fclose(sout);
  fclose(serr);
  freopen("/dev/tty", "w", stdout);
#endif
  return ret;
}
FFI_PLUGIN_EXPORT int hdcServer(void)
{
#ifdef _WIN32
  return 404;
#elif __OHOS__
  return 404;
#else
  return server();
#endif
}
FFI_PLUGIN_EXPORT int signCmd(int argc, const char *args[], const char *tempDir)
{
  int ret = 0;
#ifdef _WIN32
  ret = 404;
#elif __OHOS__
  ret = 404;
#else
  // FILE *sout = freopen(tempDir, "w", stdout);
  // FILE *serr = freopen(tempDir, "w", stderr);
  ret = sign_hap(argc, args);
  // if (sout != NULL)
  //   fclose(sout);
  // if (serr != NULL)
  //   fclose(serr);
  // freopen("/dev/tty", "w", stdout);
#endif
  return ret;
}
FFI_PLUGIN_EXPORT int unHap(const char *source, const char *fileName, const char *destination)
{
  return extractFileByHap(source, fileName, destination);
}
FFI_PLUGIN_EXPORT int unApp(const char *source, const char *destination)
{
  return unzipByApp(source, destination);
}