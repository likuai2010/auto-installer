//
// Created on 2025/7/28.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "native_java.h"
#include "dlfcn.h"
#include <jni.h>
#include <thread>
#include "napi_utils.h"
#include <sys/mman.h>  // mmap, mprotect



bool canJit(){
    unsigned char code[] = {
        0xc0, 0x03, 0x5f, 0xd6      // ret                    (返回)
    };
    size_t code_size = sizeof(code);
    void *mem = mmap(NULL, code_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (mem == MAP_FAILED) {
        return false;
    }
    memcpy(mem, code, code_size);
    if (mprotect(mem, code_size, PROT_READ | PROT_EXEC) == -1) {
        munmap(code, code_size);
        return false;
    } else {
       return true;
    }
}
napi_value HasJit(napi_env env, napi_callback_info info){
    napi_value sum;
    napi_create_double(env, canJit() ? 1 : 0, &sum);
    return sum;
}

static CallbackData callbackData;
napi_value JavaCmd(napi_env env, napi_callback_info info)
{
    size_t argc = 4;
    napi_value args[4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);
    std::string jarString = napi_to_string(env, args[0]);
    std::string mainString = napi_to_string(env, args[1]);
    std::string cmdString = napi_to_string(env, args[2]);
    std::vector<std::string> params = parseCommandLine(cmdString);
    napi_value resourceName;
    napi_create_string_latin1(env, "javaCmd", NAPI_AUTO_LENGTH, &resourceName);
    napi_threadsafe_function tsfn;
    napi_create_threadsafe_function(env, args[1], NULL, resourceName, 0, 1, NULL, NULL, NULL, [](napi_env env, napi_value js_callback, void *context, void *data){
       CallbackData* cd = (CallbackData *)data;
        if (cd == nullptr)
            return ;
        napi_value params[1];
        napi_create_int32(env, cd->result, &params[0]);
        napi_call_function(env, nullptr, js_callback, 1, params, nullptr);
    }, &tsfn);
    std::thread t([](std::vector<std::string> params,std::string jarString, std::string mainString,  napi_threadsafe_function tsfn){
        const char** argv = vector_to_const_argv(params);
        native_jvm(jarString.c_str(), mainString.c_str(), argv, params.size());
        napi_call_threadsafe_function(tsfn, &callbackData, napi_tsfn_blocking);
    },params, jarString, mainString, tsfn);
    t.detach();
    napi_value sum;
    napi_create_double(env, 0, &sum);
    return sum;
}


EXTERN_C_START

typedef int (*JNI_CreateJavaVM_t)(void*, void**, void*);

typedef void (*set_javaHome)(const char *);

// 禁用 System.exit
void fixSecurityManager(JNIEnv* env) {
     // 查找 NoExitSecurityManager 类
     jclass securityManagerClass = (env)->FindClass( "ExitBlockingSecurityManager");
     if (securityManagerClass == NULL) {
         return;
     }
     jmethodID mainMethod = (env)->GetStaticMethodID(securityManagerClass, "main", "([Ljava/lang/String;)V");
     (env)->CallStaticVoidMethod(securityManagerClass, mainMethod, NULL);
     if ((env)->ExceptionCheck()) {
         (env)->ExceptionDescribe();
         (env)->ExceptionClear();
     }
}

static JavaVM* g_jvm = NULL;

const char * init_jvm(const char* optionsString){
    if(g_jvm == NULL ){
        void* jvm_library = dlopen("libjvm.so", RTLD_LAZY | RTLD_GLOBAL);
        if (!jvm_library) {
            return "Error loading libjvm";
        }
        JNI_CreateJavaVM_t JNI_CreateJavaVM = (JNI_CreateJavaVM_t)dlsym(jvm_library, "JNI_CreateJavaVM");
        if (!JNI_CreateJavaVM) {
          dlclose(jvm_library);
          return "Error finding JNI_CreateJavaVM";
        }
        JavaVMOption options[4];
        options[0].optionString = (char*)optionsString;
        options[1].optionString = "-Djava.security.manager=allow";
        options[2].optionString = "-Xint";
        options[3].optionString = "-XX:+AggressiveHeap";
        JavaVMInitArgs vm_args;
        vm_args.version = JNI_VERSION_1_8;
        vm_args.nOptions = 1;
        vm_args.options = options;
        vm_args.ignoreUnrecognized = JNI_TRUE;
        JNIEnv *env;
        jint result = JNI_CreateJavaVM(&g_jvm, (void**)&env, &vm_args);
        if (result != JNI_OK) {
            dlclose(jvm_library);
            return "Failed to create JVM";
        }
    }
    return NULL;
}

const char* native_jvm(const char* optionsString, const char* mainClass, const char* args[], int argc){
    freopen("/data/storage/el2/base/haps/entry/temp/output.txt", "w", stdout);
    freopen("/data/storage/el2/base/haps/entry/temp/error.txt", "w", stderr);
    
    const char* ret = init_jvm(optionsString);
    if(ret != NULL)
        return ret;
    JNIEnv *env;
    jint res = g_jvm->GetEnv((void **)&env, JNI_VERSION_1_8);
    if (res == JNI_EDETACHED) {
        g_jvm->AttachCurrentThread((void **)&env, NULL);
    }
    fixSecurityManager(env);
    jclass MainClass = env->FindClass(mainClass);
    if (MainClass != NULL) {
        jmethodID mainMethod = env->GetStaticMethodID(MainClass, "main", "([Ljava/lang/String;)V");
        if (mainMethod != NULL) {
            jclass stringClass = env->FindClass("java/lang/String");
            if (stringClass == NULL) {
               return "Could not find String class";
            }
            jobjectArray mainArgs = env->NewObjectArray(argc, stringClass, NULL);
            if (mainArgs == NULL) {
               env->DeleteLocalRef(stringClass);
               return "Could not create String array";
            }
            for (int i = 0; i < argc; i++) {
                 jstring arg = env->NewStringUTF( args[i]);
                 if (arg == NULL) {
                     env->DeleteLocalRef( mainArgs);
                     env->DeleteLocalRef( stringClass);
                     return "Could not create String";
                 }
                 env->SetObjectArrayElement(mainArgs, i, arg);
                 env->DeleteLocalRef(arg);
            }
            env->CallStaticVoidMethod(MainClass, mainMethod, mainArgs);
            if (env->ExceptionCheck()) {
                env->ExceptionDescribe();
                env->ExceptionClear();
                env->DeleteLocalRef(mainArgs);
                env->DeleteLocalRef(stringClass);
                return "Exception occurred when calling main method";
            }
            env->DeleteLocalRef(mainArgs);
            env->DeleteLocalRef(stringClass);
            return "success";
        }else {
            if (env->ExceptionCheck()) {
                env->ExceptionDescribe();
                env->ExceptionClear();
            }
            return "Could not find main method\n";
        }
    }else{
        if (env->ExceptionCheck()) {
            env->ExceptionDescribe();
            env->ExceptionClear();
        }
        return "Could not find MainClass class\n"; 
    }
}

static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "javaCmd", nullptr, JavaCmd, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "hasJit", nullptr, HasJit, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}

EXTERN_C_END



static napi_module JavaCmdModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "JavaCmd",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&JavaCmdModule);
}
