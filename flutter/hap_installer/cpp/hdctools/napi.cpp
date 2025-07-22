#include "napi/native_api.h"
#include "hdc.h"
#include <thread>
#include <stdio.h>
#include <iomanip>
#include <sstream>

std::vector<std::string> parseCommandLine(const std::string& cmd) {
    std::vector<std::string> args;
    std::istringstream iss(cmd);
    std::string arg;
    bool inQuotes = false;
    char ch;
    
    while (iss >> std::noskipws >> ch) {
        if (ch == '\"') {
            inQuotes = !inQuotes;
        } else if (ch == ' ' && !inQuotes) {
            if (!arg.empty()) {
                args.push_back(arg);
                arg.clear();
            }
        } else {
            arg += ch;
        }
    }
    
    if (!arg.empty()) {
        args.push_back(arg);
    }
    
    return args;
}

std::string napi_to_string(napi_env env, napi_value value) {
    size_t length = 0;
    napi_get_value_string_utf8(env, value, nullptr, 0, &length);
    
    std::vector<char> buffer(length + 1);
    napi_get_value_string_utf8(env, value, buffer.data(), buffer.size(), nullptr);
    
    return std::string(buffer.data());
}
const char** vector_to_const_argv(const std::vector<std::string>& vec) {
    // 分配指针数组 (多分配一个用于NULL终止)
    const char** argv = new const char*[vec.size() + 1];
    
    for (size_t i = 0; i < vec.size(); ++i) {
        // 直接指向std::string的内部缓冲区
        argv[i] = vec[i].c_str();
    }
    
    // 添加NULL终止符
    argv[vec.size()] = nullptr;
    
    return argv;
}


struct CallbackData {
    int result;
};
static CallbackData callbackData;


static napi_value HdcCmd(napi_env env, napi_callback_info info)
{
    size_t argc = 3;
    napi_value args[3] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);
    
    std::string cmdString = napi_to_string(env, args[0]);
    std::string tempDir = napi_to_string(env, args[1]);
    std::vector<std::string> params = parseCommandLine(cmdString);
    napi_value resourceName;
    napi_create_string_latin1(env, "hdcCmd'", NAPI_AUTO_LENGTH, &resourceName);
    napi_threadsafe_function tsfn;
    napi_create_threadsafe_function(env, args[2], NULL, resourceName, 0, 1, NULL, NULL, NULL, [](napi_env env, napi_value js_callback, void *context, void *data){
        napi_value params[1];
        napi_create_int32(env, 0, &params[0]);
        napi_call_function(env, nullptr, js_callback, 1, params, nullptr);
    }, &tsfn);
    std::thread t([](std::vector<std::string> params, std::string tempDir, napi_threadsafe_function tsfn){
        const char** argv = vector_to_const_argv(params);
        callbackData.result = cmd(params.size(), argv, tempDir.c_str());
        delete[] argv;
        napi_call_threadsafe_function(tsfn, &callbackData, napi_tsfn_blocking);
    },params, tempDir, tsfn);
    t.detach();
    napi_value sum;
    napi_create_double(env, 0, &sum);
    return sum;
}

static napi_value hdcServer(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args , nullptr, nullptr);
    std::string cmdString = napi_to_string(env, args[0]);
    napi_value sum;
    std::thread t([](std::string cmdString){
        server(cmdString.c_str());
    },cmdString);
    t.detach();
    napi_create_double(env, 0, &sum);
    return sum;
}


EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "hdcServer", nullptr, hdcServer, nullptr, nullptr, nullptr, napi_default, nullptr },
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
