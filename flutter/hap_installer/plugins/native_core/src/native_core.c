#include "native_core.h"

#ifdef ANDROID
#include "hdc.h"
#include "hap_signer_tool.h"
#include "un_hap.h"
#else
#include <libgen.h>
#include "un_hap.h"
#include <dlfcn.h>
#include <stdio.h>
#include <jni.h>

#endif


typedef int (*JNI_CreateJavaVM_t)(void*, void**, void*);

FILE *sout = NULL;
FFI_PLUGIN_EXPORT int hdcCmd(int argc, const char *args[], const char *tempDir)
{
  int ret = 0;
#ifdef ANDROID

  FILE *sout = freopen(tempDir, "w", stdout);
  FILE *serr = freopen(tempDir, "w", stderr);
  const char *dir = dirname(tempDir);
  ret = cmd(argc, args, dir);
  fclose(sout);
  fclose(serr);
  freopen("/dev/tty", "w", stdout);
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
FFI_PLUGIN_EXPORT int signCmd(int argc, const char *args[], const char *tempDir)
{
  int ret = 0;
#ifdef ANDROID
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
void createAndSetSecurityManager(JNIEnv* env) {
    // 查找 NoExitSecurityManager 类
    jclass securityManagerClass = (*env)->FindClass(env, "ExitBlockingSecurityManager");
    if (securityManagerClass == NULL) {
        printf("Error: Could not find NoExitSecurityManager class\n");
        return;
    }
    jmethodID mainMethod = (*env)->GetStaticMethodID(env, securityManagerClass, "main", "([Ljava/lang/String;)V");

    (*env)->CallStaticVoidMethod(env, securityManagerClass, mainMethod, NULL);
    
    // 检查是否有异常
    if ((*env)->ExceptionCheck(env)) {
        (*env)->ExceptionDescribe(env);
        (*env)->ExceptionClear(env);
        printf("Warning: Exception occurred while setting security manager\n");
    } else {
        printf("Security manager set successfully\n");
    }
}


void exit(int status) {
  printf("Intercepted exit(%d)\n", status);
  // 可以选择不调用真正的 exit()
  // _exit(status); // 如果必须退出，可以用 _exit
}

// "-Djava.class.path=."  
const char* native_jvm(const char* optionsString, const char* mainClass, const char* args[], int argc, const char* libjvm_path){
  //const char* libjvm_path = "/Library/Java/JavaVirtualMachines/graalvm-jdk-17.0.12+8.1/Contents/Home/lib/server/libjvm.dylib";
  
  void* jvm_library = dlopen(libjvm_path, RTLD_LAZY | RTLD_GLOBAL);
  if (!jvm_library) {
    return "Error loading libjvm";
  }
  JNI_CreateJavaVM_t JNI_CreateJavaVM = (JNI_CreateJavaVM_t)dlsym(jvm_library, "JNI_CreateJavaVM");
  if (!JNI_CreateJavaVM) {
      dlclose(jvm_library);
      return "Error finding JNI_CreateJavaVM";
  }

  JavaVMOption options[2];
  options[0].optionString = optionsString;
  options[1].optionString = "-Djava.security.manager=allow";
  JavaVMInitArgs vm_args;
  vm_args.version = JNI_VERSION_1_8;
  vm_args.nOptions = 1;
  vm_args.options = options;
  vm_args.ignoreUnrecognized = JNI_TRUE;
  JavaVM* jvm;
  JNIEnv* env;
  jint result = JNI_CreateJavaVM(&jvm, (void**)&env, &vm_args);
  if (result != JNI_OK) {
      printf(" Failed to create JVM %d \n", result);
      dlclose(jvm_library);
      return "Failed to create JVM";
  }
  (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);

  createAndSetSecurityManager(env);
  jclass MainClass = (*env)->FindClass(env, mainClass);
  if (MainClass != NULL) {
      jmethodID mainMethod = (*env)->GetStaticMethodID(env, MainClass, "main", "([Ljava/lang/String;)V");
      if (mainMethod != NULL) {
          jclass stringClass = (*env)->FindClass(env, "java/lang/String");
          if (stringClass == NULL) {
              return "Could not find String class";
          }
          jobjectArray mainArgs = (*env)->NewObjectArray(env, argc, stringClass, NULL);
          if (mainArgs == NULL) {
              (*env)->DeleteLocalRef(env, stringClass);
              return "Could not create String array";
          }
          for (int i = 0; i < argc; i++) {
            jstring arg = (*env)->NewStringUTF(env, args[i]);
            if (arg == NULL) {
                (*env)->DeleteLocalRef(env, mainArgs);
                (*env)->DeleteLocalRef(env, stringClass);
                return "Could not create String";
            }
            (*env)->SetObjectArrayElement(env, mainArgs, i, arg);
            (*env)->DeleteLocalRef(env, arg);
          }
          (*env)->CallStaticVoidMethod(env, MainClass, mainMethod, mainArgs);
          if ((*env)->ExceptionCheck(env)) {
            (*env)->ExceptionClear(env);
            (*env)->DeleteLocalRef(env, mainArgs);
            (*env)->DeleteLocalRef(env, stringClass);
              return "Exception occurred when calling main method";
          }
          (*env)->DeleteLocalRef(env, mainArgs);
          (*env)->DeleteLocalRef(env, stringClass);
          return "sucess";
      } else {
          return "Could not find main method\n";
      }
  } else {
      return "Could not find MainClass class\n";
  }
  (*jvm)->DetachCurrentThread(jvm);

  jint re = (*jvm)->DestroyJavaVM(jvm);
  if (re != JNI_OK) {
    printf("关闭 JVM 失败，错误码: %d\n", re);
  }
 
  dlclose(jvm_library);
  return "Failed to create JVM";
}



FFI_PLUGIN_EXPORT int unHap(const char *source, const char *fileName, const char *destination)
{
  return extractFileByHap(source, fileName, destination);
}
FFI_PLUGIN_EXPORT int unApp(const char *source, const char *destination)
{

  return unzipByApp(source, destination);
}

