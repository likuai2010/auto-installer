# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(native_core_library VERSION 0.0.1 LANGUAGES C)


set(libPath ${CMAKE_CURRENT_SOURCE_DIR}/../libs)


set(LIBRARY_PATHS )

if(ANDROID)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../../../cpp "${CMAKE_CURRENT_BINARY_DIR}/shared")
list(APPEND LIBRARY_PATHS 
hdc_z
signtool
)
elseif(WIN32)
list(APPEND LIBRARY_PATHS
${libPath}/windows/x86-64/libhdc_z.dll.a
${libPath}/windows/x86-64/libsigntool.dll.a
)
elseif(APPLE)
else()
add_library(hdc STATIC IMPORTED)
set_target_properties(hdc PROPERTIES IMPORTED_LOCATION ${libPath}/linux/arm64-v8a/libhdc_z.a)
set_target_properties(hdc PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${libPath}/include)
add_library(signtool STATIC IMPORTED)
set_target_properties(signtool PROPERTIES IMPORTED_LOCATION ${libPath}/windows/x86-64/libsigntool.a)
set_target_properties(signtool PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${libPath}/include)
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
