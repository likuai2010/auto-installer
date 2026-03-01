# Simplified CMakeLists.txt for cJSON - only builds the library, no tests
cmake_minimum_required(VERSION 3.5.0)
project(cjson C)

# cJSON library
set(CJSON_LIB cjson)

file(GLOB HEADERS source/cJSON.h)
set(SOURCES source/cJSON.c)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)

if(BUILD_SHARED_LIBS)
    add_library("${CJSON_LIB}" SHARED ${HEADERS} ${SOURCES})
else()
    add_library("${CJSON_LIB}" STATIC ${HEADERS} ${SOURCES})
endif()

# Enable locales by default
add_definitions(-DENABLE_LOCALES)

# Export symbols
add_definitions(-DCJSON_EXPORT_SYMBOLS -DCJSON_API_VISIBILITY)

# Include directories
target_include_directories("${CJSON_LIB}" PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/source
)

# Link math library on non-Windows
if(NOT WIN32)
    target_link_libraries("${CJSON_LIB}" m)
endif()
