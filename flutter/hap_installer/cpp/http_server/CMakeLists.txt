# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

include_directories(${NATIVERENDER_ROOT_PATH}
${NATIVERENDER_ROOT_PATH}/include/linux
                    ${NATIVERENDER_ROOT_PATH}/include)


add_library(httpServer SHARED http_server.cpp)
target_link_libraries(httpServer PUBLIC libace_napi.z.so libpthread.a libhilog_ndk.z.so)