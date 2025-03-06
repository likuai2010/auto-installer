//
// Created on 2024/10/17.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".
#include "napi/native_api.h"
#include "params_run_tool.h"
#include "contrib/minizip/unzip.h"

using namespace OHOS::SignatureTools;

static const char** split(char* input, int& size)
{
    std::vector<const char*> params;
    char* temp = strtok(input, " ");
    while (temp != nullptr) {
        params.push_back(temp);
        temp = strtok(nullptr, " ");
    }
    size = params.size();
    const char** paramsArray = new const char*[params.size() + 1]; // +1 为了存储 nullptr
    for (size_t i = 0; i < params.size(); ++i) {
        paramsArray[i] = const_cast<char*>(params[i]); // 转换 const char* 为 char*
    }
    return paramsArray;
}
struct CallbackData {
    int result;
};
static CallbackData callbackData;

static napi_value SignHap(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);
     size_t str_len;
    napi_status status = napi_get_value_string_utf8(env, args[0], NULL, 0, &str_len);
    char* buffer = (char*)malloc(str_len + 1); // +1 for the null terminator
    status = napi_get_value_string_utf8(env, args[0], buffer, str_len + 1, NULL);
    if (status != napi_ok) {
        free(buffer);
        return NULL;
    }
    int count;
    const char** params = split(buffer, count);
    napi_value resourceName;
    napi_create_string_latin1(env, "SignHap'", NAPI_AUTO_LENGTH, &resourceName);
    napi_threadsafe_function tsfn;
    napi_create_threadsafe_function(env, args[1], NULL, resourceName, 0, 1, NULL, NULL, NULL, [](napi_env env, napi_value js_callback, void *context, void *data){
       CallbackData* cd = (CallbackData *)data;
        if (cd == nullptr)
            return ;
        napi_value params[1];
        napi_create_int32(env, cd->result, &params[0]);
        napi_call_function(env, nullptr, js_callback, 1, params, nullptr);
    }, &tsfn);
    std::thread t([](const char** params, int count, napi_threadsafe_function tsfn){
//         FILE* sout = freopen("/data/storage/el2/base/haps/entry/temp/signed_out.txt", "w", stdout);
//         FILE* serr = freopen("/data/storage/el2/base/haps/entry/temp/signed_err.txt", "w", stderr);
        callbackData.result = ParamsRunTool::ProcessCmd((char **)params, count) ? 0 : -1;
//         if (sout != nullptr) { 
//             fclose(sout);
//             fclose(serr);
//         }
        napi_call_threadsafe_function(tsfn, &callbackData, napi_tsfn_blocking);
    },params, count, tsfn);
    t.detach();
    napi_value sum;
    napi_create_double(env, 0, &sum);
    return sum;
}
void unzip(const char *source, const char *fileName, const char *destination) {
    unzFile zipfile = unzOpen(source);
    if (zipfile == NULL) {
        printf("无法打开 ZIP 文件: %s\n", source);
        return;
    }

    if (unzLocateFile(zipfile, fileName, 1) != UNZ_OK) {
        printf("未找到文件: %s\n", destination);
        unzClose(zipfile);
        return;
    }
      if (unzOpenCurrentFile(zipfile) != UNZ_OK) {
        printf("无法打开文件: %s\n", destination);
        unzClose(zipfile);
        return;
    }
    FILE *dest_file = fopen(destination, "wb");
    if (dest_file == NULL) {
        printf("无法创建目标文件: %s\n", destination);
        unzCloseCurrentFile(zipfile);
        unzClose(zipfile);
        return;
    }
    // 从 ZIP 文件中读取数据并写入目标文件
    char buffer[4096];
    int bytes_read;
    while ((bytes_read = unzReadCurrentFile(zipfile, buffer, sizeof(buffer))) > 0) {
        fwrite(buffer, 1, bytes_read, dest_file);
    }
  
    fclose(dest_file);
    unzCloseCurrentFile(zipfile);
    unzClose(zipfile);
    printf("成功提取: %s\n", destination);
}

static napi_value extract_specific_file(napi_env env, napi_callback_info info)
{
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);
    size_t str_len;
    napi_status status = napi_get_value_string_utf8(env, args[0], NULL, 0, &str_len);
    char* source = (char*)malloc(str_len + 1); // +1 for the null terminator
    status = napi_get_value_string_utf8(env, args[0], source, str_len + 1, NULL);
    status = napi_get_value_string_utf8(env, args[1], NULL, 0, &str_len);
    char* target = (char*)malloc(str_len + 1); // +1 for the null terminator
    status = napi_get_value_string_utf8(env, args[1], target, str_len + 1, NULL);
    unzip(source, "module.json", target);
    napi_value sum;
    napi_create_double(env, 0, &sum);
    return sum;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "signHap", nullptr, SignHap, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "loadModuleJson", nullptr, extract_specific_file, nullptr, nullptr, nullptr, napi_default, nullptr },
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module js_hapSignTool = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "signtool",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&js_hapSignTool);
}