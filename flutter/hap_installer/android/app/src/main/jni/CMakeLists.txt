cmake_minimum_required(VERSION 3.18.1)
project("mygojni")

# 添加我们的 JNI 封装源文件
add_library(gojni SHARED
        jni_wrapper.cpp
)

# 包含头文件目录
target_include_directories(gojni PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# 链接 Go 生成的库
# 注意：这里我们只是告诉链接器符号存在，实际加载在运行时
find_library(log-lib log)

target_link_libraries(gojni
        ${log-lib}
)
