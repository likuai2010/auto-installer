# the minimum version of CMake.

project(boundscheck C)

set(OPTION
    -fPIC
    -fstack-protector-all
    -D_FORTIFY_SOURCE=2
    -O2
    -Wformat=2
    -Wfloat-equal
    -Wshadow
    -Wconversion
    -Wformat-security
    -Wextra
    --param=ssp-buffer-size=4
    -Warray-bounds
    -Wpointer-arith
    -Wcast-qual
    -Wstrict-prototypes
    -Wmissing-prototypes
    -Wstrict-overflow=1
    -Wstrict-aliasing=2
    -Wswitch
    -Wswitch-default
)
add_compile_options(${OPTION})

file(GLOB SOURCES "source/src/*.c")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall ")

set(LD_FLAGS "")

include_directories(source/include)
add_library(boundscheck STATIC ${SOURCES})
target_link_libraries(boundscheck PRIVATE ${LD_FLAGS})


