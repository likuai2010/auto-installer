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

set(cflags
"-Wno-incompatible-pointer-types"
#"-Werror"
#"-Wimplicit-function-declaration"
)


include_directories(${include_dirs})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cflags}")
set(LD_FLAGS "-fPIC -s -Wl,-z,relro,-z,now,-z,noexecstack -fstack-protector-all")

add_library(lz4 STATIC ${outputs})
target_link_libraries(lz4 PRIVATE ${LD_FLAGS})


