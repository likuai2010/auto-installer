# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)

project(zlib C)

set(target_gen_dir ${CMAKE_CURRENT_SOURCE_DIR}/source)
set(outputs
"${target_gen_dir}/adler32.c"
"${target_gen_dir}/compress.c"
"${target_gen_dir}/contrib/minizip/ioapi.c"
"${target_gen_dir}/contrib/minizip/unzip.c"
"${target_gen_dir}/contrib/minizip/zip.c"
"${target_gen_dir}/crc32.c"
"${target_gen_dir}/crc32.h"
"${target_gen_dir}/deflate.c"
"${target_gen_dir}/deflate.h"
"${target_gen_dir}/gzclose.c"
"${target_gen_dir}/gzguts.h"
"${target_gen_dir}/gzlib.c"
"${target_gen_dir}/gzread.c"
"${target_gen_dir}/gzwrite.c"
"${target_gen_dir}/infback.c"
"${target_gen_dir}/inffast.c"
"${target_gen_dir}/inffast.h"
"${target_gen_dir}/inffixed.h"
"${target_gen_dir}/inflate.c"
"${target_gen_dir}/inflate.h"
"${target_gen_dir}/inftrees.c"
"${target_gen_dir}/inftrees.h"
"${target_gen_dir}/trees.c"
"${target_gen_dir}/trees.h"
"${target_gen_dir}/uncompr.c"
"${target_gen_dir}/zconf.h"
"${target_gen_dir}/zlib.h"
"${target_gen_dir}/zutil.c"
"${target_gen_dir}/zutil.h"
)

set(include_dirs
${target_gen_dir}
"${target_gen_dir}/contrib/minizip"
)

set(cflags
"-Wno-incompatible-pointer-types"
#"-Wno-strict-prototypes"
#"-Wimplicit-function-declaration"
#"-Werror"
#"-Wno-strict-prototypes"
#"-march=armv8-a+crc"


include_directories(${include_dirs})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cflags}")
)
if(LINUX)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
endif()

set(LD_FLAGS "-fPIC -fstack-protector-all")

if(OHOS)
list(APPEND LD_FLAGS "-Wl,-z,relro,-z,now,")
endif()

add_library(zlib STATIC ${outputs})
target_link_libraries(zlib PRIVATE ${LD_FLAGS})


