#include <jni.h>
#include <string>
#include <dlfcn.h>
#include "libmylib.h" // 从 Go 生成的头文件
typedef int (*Add_T)(int argc, int argv);

extern "C" {

JNIEXPORT jint JNICALL
Java_com_xiaobai_nativelib_NativeLib_add(
        JNIEnv* env,
        jobject /* this */,
        jint a,
        jint b) {
    // 直接调用 Go 导出的函数
   // return Add(a, b);
//    void* jvm_library = dlopen("libsigner_go.so", RTLD_LAZY | RTLD_GLOBAL);
//    Sign_Cmd JNI_CreateJavaVM = (Sign_Cmd)dlsym(jvm_library, "Sign_Cmd");
//    char* d = JNI_CreateJavaVM(0, NULL,"");
   return 1;
}

}