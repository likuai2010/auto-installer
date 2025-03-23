# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)

project(libusb C)

include_directories(include)
set(target_gen_dir ${CMAKE_CURRENT_SOURCE_DIR}/source)
set(LIBUSB_DIR ${CMAKE_CURRENT_SOURCE_DIR}/source)
set(libs)
set(outputs
    "${target_gen_dir}/libusb-1.0.26/libusb/core.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/descriptor.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/hotplug.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/io.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/sync.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/strerror.c"
)
if(APPLE)
list(APPEND outputs
    "${target_gen_dir}/libusb-1.0.26/libusb/os/darwin_usb.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/os/events_posix.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/os/threads_posix.c"
)

elseif(MINGW OR WIN32)
list(APPEND outputs
    "${target_gen_dir}/libusb-1.0.26/libusb/os/events_windows.c"
     "${target_gen_dir}/libusb-1.0.26/libusb/os/threads_windows.c"
     "${target_gen_dir}/libusb-1.0.26/libusb/os/windows_common.c"
     "${target_gen_dir}/libusb-1.0.26/libusb/os/windows_usbdk.c"
     "${target_gen_dir}/libusb-1.0.26/libusb/os/windows_winusb.c"
)
elseif(UNIX OR OHOS)
list(APPEND outputs
    "${target_gen_dir}/libusb-1.0.26/libusb/os/events_posix.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/os/linux_netlink.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/os/linux_usbfs.c"
    "${target_gen_dir}/libusb-1.0.26/libusb/os/threads_posix.c"
)
endif()

set(include_dirs
${target_gen_dir}/libusb-1.0.26/libusb
${target_gen_dir}/libusb-1.0.26/libusb/os
)

set(cflags
    "-U__ANDROID__"
    # "-UUSE_UDEV"
    # "-Wno-#warnings"
    # "-Wno-error=sign-compare"
    # "-Wno-error=switch"
    # "-Wno-error=pragma-pack"
)
if((UNIX AND NOT APPLE))
    list(APPEND include_dirs "${LIBUSB_DIR}/linux")
elseif(MINGW OR WIN32)
    list(APPEND cflags
        "-Werror"
        "-Wno-unused-function"
        "-Wno-unused-parameter"
        "-DPLATFORM_WINDOWS"
    )
    list(APPEND include_dirs "${LIBUSB_DIR}/windows")
elseif(APPLE)
   list(APPEND cflags
        # "-Wno-unused-parameter"
        # "-Wno-deprecated-declarations"
   )
   list(APPEND include_dirs "${LIBUSB_DIR}/darwin")
   list(APPEND libs 
   objc 
   "-framework CoreFoundation"
    "-framework IOKit"
    "-framework Security")
endif()




set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cflags}")

add_library(usb STATIC ${outputs})
include_directories(${include_dirs})
target_include_directories(usb PUBLIC ${include_dirs})
target_link_libraries(usb PRIVATE ${libs})


