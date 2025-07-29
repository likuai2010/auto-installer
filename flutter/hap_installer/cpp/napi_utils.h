#include "napi/native_api.h"
#include <stdio.h>
#include <iomanip>
#include <sstream>
#include <cstdlib>
#include <cstring>

struct CallbackData {
    int result;
    std::string message;
};

const char** vector_to_const_argv(const std::vector<std::string>& vec) {
    const char** argv = new const char*[vec.size() + 1];
    for (size_t i = 0; i < vec.size(); ++i) {
        argv[i] = vec[i].c_str();
    }
    argv[vec.size()] = nullptr;
    return argv;
}


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


int napi_to_int(napi_env env, napi_value value) {
    int result = 0;
    napi_get_value_int32(env, value, &result);
    return result;
}