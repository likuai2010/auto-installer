#include "native_core.h"
#include "hdc.h"
#include "hap_signer_tool.h"
#ifndef _WIN32
#include <libgen.h>
#endif
FILE *sout = NULL;
FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[], const char *tempDir)
{
  int ret = 0;
#ifdef _WIN32
  ret = cmd(argc, args, tempDir);
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
  return server();
}
FFI_PLUGIN_EXPORT int signCmd(int argc, const char *args[], const char *tempDir)
{

  FILE *sout = freopen(tempDir, "w", stdout);
  FILE *serr = freopen(tempDir, "w", stderr);
  int ret = sign_hap(argc, args);
  fclose(sout);
  fclose(serr);
#ifdef _WIN32
  freopen("CON", "w", stdout);
#else
  freopen("/dev/tty", "w", stdout);
#endif
  return ret;
}
FFI_PLUGIN_EXPORT int unHap(const char *source, const char *fileName, const char *destination)
{
    return unzip(source, fileName, destination);
}