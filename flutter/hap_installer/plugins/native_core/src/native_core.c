#include "native_core.h"

#ifdef ANDROID
#include "hdc.h"
#include "hap_signer_tool.h"
#include "un_hap.h"
#include <libgen.h>
#include <jni.h>
#include "dlfcn.h"
#include <stdio.h>

#elif _WIN32
#include "un_hap.h"
#include <stdio.h>
#else
#include "un_hap.h"
#include <dlfcn.h>
#include <stdio.h>


#endif


typedef int (*JNI_CreateJavaVM_t)(void*, void**, void*);

FILE *sout = NULL;
FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[], const char *tempDir)
{
  int ret = 0;
#ifdef ANDROID
  const char *dir = dirname(tempDir);
  ret = cmd(argc, args, dir);
#else
    ret = 404;
#endif
  return ret;
}
FFI_PLUGIN_EXPORT int hdcServer(const char *tempDir)
{
#ifdef ANDROID
  return server(tempDir);
#else
  return 404;
#endif
}

typedef char* (*Sign_Cmd_T)(int argc, char** argv, char* tempDir);

FFI_PLUGIN_EXPORT char* signCmd(int argc, const char *args[], const char *tempDir)
{
  int ret = 0;
#ifdef ANDROID
//   FILE *sout = freopen(tempDir, "w", stdout);
//   FILE *serr = freopen(tempDir, "w", stderr);
//   ret = sign_hap(argc, args);
//   if (sout != NULL)
//     fclose(sout);
//   if (serr != NULL)
//     fclose(serr);
    void* go_library = dlopen("libsigner_go.so", RTLD_LAZY | RTLD_GLOBAL);
    if (!go_library) {
        return "load signer_go.so failure";
    }
    Sign_Cmd_T cmd = (Sign_Cmd_T)dlsym(go_library, "Sign_Cmd");
    char* result = cmd(argc, (char**)args, tempDir);
    return result;
   //freopen("/dev/tty", "w", stdout);
#endif
  return "signCmd no support";
}



FFI_PLUGIN_EXPORT int unHap(const char *source, const char *fileName, const char *destination)
{
  return extractFileByHap(source, fileName, destination);
}
FFI_PLUGIN_EXPORT int unApp(const char *source, const char *destination)
{

  return unzipByApp(source, destination);
}

