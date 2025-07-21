#include "napi/native_api.h"
#include "hdc.h"

static napi_value HdcCmd(napi_env env, napi_callback_info info)
{
    napi_value sum;
    napi_create_double(env, 1 ? 0 : -1, &sum);
    return sum;
}



EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "hdcCmd", nullptr, HdcCmd, nullptr, nullptr, nullptr, napi_default, nullptr }
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module HdcModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "hdc_z",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&HdcModule);
}
