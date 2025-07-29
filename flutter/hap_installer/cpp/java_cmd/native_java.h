//
// Created on 2025/7/28.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#ifndef TESTJIT_NATIVE_JAVA_H
#define TESTJIT_NATIVE_JAVA_H
#include "napi/native_api.h"

EXTERN_C_START
const char* native_jvm(const char* optionsString, const char* mainClass, const char* args[], int argc);
EXTERN_C_END
#endif //TESTJIT_NATIVE_JAVA_H
