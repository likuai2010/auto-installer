#include "native_core.h"
#include "hdc.h"
#include "hap_signer_tool.h"

FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[], const char *tempDir)
{
  FILE *sout = freopen(tempDir, "w", stdout);
  FILE *serr = freopen(tempDir, "w", stderr);
  int ret = cmd(argc, args, tempDir);
  fclose(sout);
  fclose(serr);
  return ret;
}
FFI_PLUGIN_EXPORT int hdcServer(void)
{
  return server();
}
FFI_PLUGIN_EXPORT int signCmd(int argc, const char *args[], const char *tempDir)
{
  return signCmd(argc, args, tempDir);
}
FFI_PLUGIN_EXPORT char *uzip(const char *source, const char *fileName, const char *destination)
{
  return uzip(source, fileName, destination);
}