# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(autoInstaller)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

set(LIBS_DIR ${NATIVERENDER_ROOT_PATH}/third_party)
set(OPENSSL_ROOT_DIR ${LIBS_DIR}/openssl)
set(OPENSSL_INCLUDE_DIR ${OPENSSL_ROOT_DIR}/include)

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
set_target_properties(libssl PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/darwin64-arm64/libssl.a)
set_target_properties(libssl PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
add_library(libcrypto STATIC IMPORTED)
set_target_properties(libcrypto PROPERTIES IMPORTED_LOCATION ${OPENSSL_ROOT_DIR}/darwin64-arm64/libcrypto.a)
set_target_properties(libcrypto PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${OPENSSL_INCLUDE_DIR})
endif()


add_subdirectory(third_party/bounds_checking_function)

include_directories(include
${OPENSSL_INCLUDE_DIR}
hdctools/
third_party/bounds_checking_function/include
)



add_subdirectory(hdctools)
