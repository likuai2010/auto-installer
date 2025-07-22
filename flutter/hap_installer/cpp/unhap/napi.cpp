#include "napi/native_api.h"
#include "un_hap.h"
#include <stdio.h>
#include <sstream>

std::string napi_to_string(napi_env env, napi_value value) {
    size_t length = 0;
    napi_get_value_string_utf8(env, value, nullptr, 0, &length);
    
    std::vector<char> buffer(length + 1);
    napi_get_value_string_utf8(env, value, buffer.data(), buffer.size(), nullptr);
    
    return std::string(buffer.data());
}

static napi_value unByHap(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);
    
    std::string source = napi_to_string(env, args[0]);
    std::string fileName = napi_to_string(env, args[1]);
    std::string destination = napi_to_string(env, args[2]);

    int ret = extractFileByHap(source.c_str(), fileName.c_str(), destination.c_str());
    napi_value sum;
    napi_create_double(env, ret, &sum);
    return sum;
}
static napi_value unApp(napi_env env, napi_callback_info info)
{
    
    size_t argc = 2;
    napi_value args[2] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);
    
    std::string source = napi_to_string(env, args[0]);
    std::string destination = napi_to_string(env, args[1]);
    napi_value sum;
    int ret = unzipByApp(source.c_str(), destination.c_str());
    napi_create_double(env, ret, &sum);
    return sum;
}



EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "unHap", nullptr, unByHap, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "unApp", nullptr, unApp, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module UnHapModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "unHap",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&UnHapModule);
}
