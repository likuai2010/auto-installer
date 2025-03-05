
include_directories(include
    source/src/common
    source/src/host
    third_party/bounds_checking_function/include
    third_party/libusb/source/libusb-1.0.26
    third_party/lz4/lib
    third_party/libuv/include
)
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -ggdb -Wall ")
# add_subdirectory(third_party/libusb)
add_subdirectory(third_party/lz4)

#-DHDC_SUPPORT_USB
add_definitions(-DHILOG )

#//-DHOST_LINUX
add_definitions(-DUSE_CONFIG_UV_THREADS -DSIZE_THREAD_POOL=128 -DHDC_HOST  -DHARMONY_PROJECT -DTEST_HASH -DHDC_MSG_HASH="TEST")
AUX_SOURCE_DIRECTORY(${CMAKE_CURRENT_LIST_DIR}/source/src/host HOST_SRCS)
AUX_SOURCE_DIRECTORY(${CMAKE_CURRENT_LIST_DIR}/source/src/common COMMON_SRCS)

get_filename_component(MY_RESULT_ABSOLUTE_PATH_VAR
                       "${CMAKE_CURRENT_LIST_DIR}/source/src/host/${MY_RELATIVE_PATH_VAR}"
                       ABSOLUTE)
list(REMOVE_ITEM HOST_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/host/main.cpp")
list(REMOVE_ITEM HOST_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/host/server.cpp")
list(REMOVE_ITEM COMMON_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/common/base.cpp")
list(REMOVE_ITEM COMMON_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/common/auth.cpp")
link_libraries(
    uv
    libcrypto
    lz4
    boundscheck
    usb
    hilog_ndk.z
)
add_library(hdc_z SHARED main.cpp base.cpp server.cpp auth.cpp ${COMMON_SRCS} ${HOST_SRCS} )
#add_executable(hdc_z ${COMMON_SRCS} ${HOST_SRCS})