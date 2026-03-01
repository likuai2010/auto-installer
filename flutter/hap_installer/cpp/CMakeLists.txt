# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(hapInstaller)


set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(LIBS_DIR ${NATIVERENDER_ROOT_PATH}/third_party)
set(OPENSSL_ROOT_DIR ${LIBS_DIR}/openssl)
set(OPENSSL_INCLUDE_DIR ${OPENSSL_ROOT_DIR}/include)




if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
set(LINUX 1)
endif()

if(OHOS)
# 导入静态库
add_library(libssl STATIC IMPORTED)
set_target_properties(libssl PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/ohos/${CMAKE_OHOS_ARCH_ABI}/libssl.a)
set_target_properties(libssl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
# 导入静态库
add_library(libcrypto STATIC IMPORTED)
set_target_properties(libcrypto PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/ohos/${CMAKE_OHOS_ARCH_ABI}/libcrypto.a)
set_target_properties(libcrypto PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
endif()
if(APPLE)
add_library(libssl STATIC IMPORTED)
add_library(libcrypto STATIC IMPORTED)
set_target_properties(libssl PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/darwin64/universal/libssl.a)
set_target_properties(libssl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
set_target_properties(libcrypto PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/darwin64/universal/libcrypto.a)
set_target_properties(libcrypto PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})

endif()
if(ANDROID)
add_library(libcrypto STATIC IMPORTED)
set_target_properties(libcrypto PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/android/arm64-v8a/libcrypto.a)
set_target_properties(libcrypto PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
add_library(libssl STATIC IMPORTED)
set_target_properties(libssl PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/android/arm64-v8a/libssl.a)
set_target_properties(libssl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
add_library(libcrypto STATIC IMPORTED)
set_target_properties(libcrypto PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/linux/x86-64/libcrypto.a)
set_target_properties(libcrypto PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
endif()


if(APPLE)
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0")
set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")
endif()

add_subdirectory(third_party/bounds_checking_function)
add_subdirectory(third_party/cJSON)
add_subdirectory(hapsigner/third_party/zlib)

include_directories(
include
${OPENSSL_INCLUDE_DIR}
${CMAKE_CURRENT_SOURCE_DIR}
hdctools/
third_party/bounds_checking_function/source/include
third_party/cJSON/source/
)

if(ANDROID)
add_definitions(-DANDROID_PLATFORM=android-24 -D_GNU_SOURCE=1)
endif()

if (ANDROID)
add_subdirectory(hdctools)
add_subdirectory(hapsigner)
add_subdirectory(unhap)
elseif(OHOS)
    add_subdirectory(unhap)
    # add_subdirectory(hdctools)
    # add_subdirectory(hnp_tools)
    # add_subdirectory(http_server)
else()
add_subdirectory(packing_tool)
#add_subdirectory(hnp_tools)
#add_subdirectory(unhap)
#add_subdirectory(hapsigner)
endif()
