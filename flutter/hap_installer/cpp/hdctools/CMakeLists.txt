
include_directories(include
    source/src/common
    source/src/host
    third_party/libusb/source/
    third_party/libusb/source/libusb
    third_party/libusb/source/libusb-1.0.26
    third_party/lz4/lib
    third_party/libuv/source/include
)
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17  -Wall ")



add_subdirectory(third_party/lz4)
add_subdirectory(third_party/libusb)
#-DHDC_SUPPORT_USB
if(OHOS)
    add_definitions(-DHILOG -DHOST_OHOS -DHDC_SUPPORT_ENCRYPT_TCP -DHDC_SUPPORT_UART)
else()
    add_subdirectory(third_party/libuv)
endif()

add_definitions(-DUSE_CONFIG_UV_THREADS -DSIZE_THREAD_POOL=128 -DHDC_HOST  -DHARMONY_PROJECT -DTEST_HASH -DHDC_MSG_HASH="TEST")
if(LINUX OR ANDROID)
    add_definitions(-DHOST_LINUX)
endif()
if(APPLE)
    add_definitions(-DHOST_MAC) 
endif()
if(MINGW)
    add_definitions(-DHOST_MINGW)
endif()
AUX_SOURCE_DIRECTORY(${CMAKE_CURRENT_LIST_DIR}/source/src/host HOST_SRCS)
AUX_SOURCE_DIRECTORY(${CMAKE_CURRENT_LIST_DIR}/source/src/common COMMON_SRCS)

get_filename_component(MY_RESULT_ABSOLUTE_PATH_VAR
                       "${CMAKE_CURRENT_LIST_DIR}/source/src/host/${MY_RELATIVE_PATH_VAR}"
                       ABSOLUTE)
list(REMOVE_ITEM HOST_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/host/main.cpp")
list(REMOVE_ITEM HOST_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/host/server.cpp")
list(REMOVE_ITEM COMMON_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/common/base.cpp")
list(REMOVE_ITEM COMMON_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/common/auth.cpp")
list(REMOVE_ITEM COMMON_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/common/hdc_huks.cpp")
list(REMOVE_ITEM COMMON_SRCS "${CMAKE_CURRENT_LIST_DIR}/source/src/common/password.cpp")

configure_file(
  base.h
  ${CMAKE_CURRENT_LIST_DIR}/source/src/common/base.h
  COPYONLY
  @ONLY
  FORCE  # 强制覆盖
)


set(FixSource main.cpp hdc.h   base.cpp server.cpp auth.cpp)
if(OHOS)
list(APPEND FixSource napi.cpp)
endif()

if(APPLE)
    add_library(hdc_z STATIC ${FixSource} ${COMMON_SRCS} ${HOST_SRCS} )
else()
    add_library(hdc_z SHARED ${FixSource} ${COMMON_SRCS} ${HOST_SRCS} )
endif()
target_link_libraries(
    hdc_z
    libcrypto
    libssl
    lz4
    boundscheck
    uv
    usb
)
if(OHOS)
    target_link_libraries(
        hdc_z
        hilog_ndk.z
        libace_napi.z.so
    )
endif()


#add_executable(hdc main.cpp base.cpp server.cpp auth.cpp ${COMMON_SRCS} ${HOST_SRCS})