# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)

project(bzip2 C)

execute_process(
    COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/source/install.sh ${CMAKE_CURRENT_SOURCE_DIR}/source
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/source
    RESULT_VARIABLE result
    OUTPUT_VARIABLE output
    ERROR_VARIABLE error
)



set(target_gen_dir ${CMAKE_CURRENT_SOURCE_DIR}/source/)
set(outputs
"${target_gen_dir}/blocksort.c"
"${target_gen_dir}/bzlib.c"
"${target_gen_dir}/compress.c"
"${target_gen_dir}/crctable.c"
"${target_gen_dir}/decompress.c"
"${target_gen_dir}/huffman.c"
"${target_gen_dir}/randtable.c"
)

set(include_dirs
${target_gen_dir}
)


include_directories(${include_dirs})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cflags}")

set(LD_FLAGS "-fPIC  -fstack-protector-all")
if(OHOS)
list(APPEND LD_FLAGS "-Wl,-z,relro,-z,now,")
endif()

add_library(bzip2 STATIC ${outputs})
target_link_libraries(bzip2 PRIVATE ${LD_FLAGS})


