# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)

project(lz4 C)

set(target_gen_dir ${CMAKE_CURRENT_SOURCE_DIR})
set(outputs
   "${target_gen_dir}/lib/lz4.c"
   "${target_gen_dir}/lib/lz4hc.c"
)


set(include_dirs
${target_gen_dir}/lib
)
set(cflags)
if(MSVC)
    # MSVC 不支持 /Wno-* 选项，所以可以选择使用其他 MSVC 选项
    add_compile_options(/W4)
    list(APPEND cflags /W4)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    # 对于 GCC 和 Clang，使用 /Wno-incompatible-pointer-types
    list(APPEND cflags "-Wno-incompatible-pointer-types")
endif()

include_directories(${include_dirs})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cflags}")
if(OHOS)
#set(LD_FLAGS "-fPIC -s -Wl,-z,relro,-z,now, -fstack-protector-all")
endif()

add_library(lz4 STATIC ${outputs})
target_link_libraries(lz4 PRIVATE ${LD_FLAGS})


