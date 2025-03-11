#include "native_core.h"
#include "hdc.h"
#include "hap_signer_tool.h"

FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[])
{
  return cmd(argc, args);
}
FFI_PLUGIN_EXPORT int hdcServer(void)
{
  return hdcServer();
}
FFI_PLUGIN_EXPORT int signCmd(int argc, const char *args[])
{
  return signCmd(argc, args);
}
FFI_PLUGIN_EXPORT char *uzip(const char *source, const char *fileName, const char *destination)
{
  return uzip(source, fileName, destination);
}