# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(native_core_library VERSION 0.0.1 LANGUAGES C)


set(libPath ${CMAKE_CURRENT_SOURCE_DIR}/../libs)

set(LIBRARY_PATHS )

if(ANDROID)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../../../cpp "${CMAKE_CURRENT_BINARY_DIR}/unhap")
list(APPEND LIBRARY_PATHS 
hdc_z
signtool
unhap
)
elseif(WIN32)
  list(APPEND LIBRARY_PATHS
    ${libPath}/windows/x86-64/libunhap.dll.a
  )
elseif(APPLE)
else()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

list(APPEND LIBRARY_PATHS
  ${libPath}/linux/x86-64/libunhap.a
  ${libPath}/linux/x86-64/libzlib.a
)
endif()


include_directories(${libPath}/include)


add_library(native_core SHARED
  "native_core.c"
)

set_target_properties(native_core PROPERTIES
  PUBLIC_HEADER native_core.h
  OUTPUT_NAME "native_core"
)

target_compile_definitions(native_core PUBLIC DART_SHARED_LIB)

target_link_libraries(native_core PRIVATE ${LIBRARY_PATHS})



if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(native_core PRIVATE "-Wl,-z,max-page-size=16384")
endif()



if(WIN32)
set(OUTPUT_DIR ${CMAKE_BINARY_DIR}/runner/Debug)
add_custom_command(TARGET native_core POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  ${libPath}/windows/x86-64/libunhap.dll
  ${OUTPUT_DIR}
)
set(OUTPUT_DIR ${CMAKE_BINARY_DIR}/runner/Release)
add_custom_command(TARGET native_core POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  ${libPath}/windows/x86-64/libunhap.dll
  ${libPath}/windows/x86-64/libwinpthread-1.dll
  ${OUTPUT_DIR}
)

endif()
