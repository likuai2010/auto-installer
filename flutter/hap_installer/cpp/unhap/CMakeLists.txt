cmake_minimum_required(VERSION 3.5.0)

project(unhap C)
set(CMAKE_CXX_STANDARD 17)

add_subdirectory(../hapsigner/third_party/zlib "${CMAKE_CURRENT_BINARY_DIR}/shared")

set(include_dirs
    ../hapsigner/third_party/zlib/source
)

list(APPEND outputs un_hap.cpp )
if(MINGW)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static-libgcc -static-libstdc++")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc  -static-libstdc++")
endif()
include_directories(${include_dirs})
link_libraries(
 ${LD_FLAGS}
 zlib
)

if(WIN32)
add_library(unhap SHARED ${outputs})
else()
add_library(unhap STATIC ${outputs})
endif()