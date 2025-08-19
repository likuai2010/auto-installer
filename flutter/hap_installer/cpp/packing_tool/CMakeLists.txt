

set(appspawn_path ${CMAKE_CURRENT_LIST_DIR}/source/packing_tool/frameworks)

include_directories(include
    ${appspawn_path}/include
    ${appspawn_path}/include/json
    ../hapsigner/third_party/zlib/source
    ../hapsigner/third_party/json/source/include
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17  -fexceptions -Wall ")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fexceptions  ")

set(cliSources 
"${appspawn_path}/src/hap_packager.cpp"
"${appspawn_path}/src/hsp_packager.cpp"
"${appspawn_path}/src/main.cpp"
"${appspawn_path}/src/packager.cpp"
"${appspawn_path}/src/shell_command.cpp"
"${appspawn_path}/src/app_packager.cpp"
"${appspawn_path}/src/appqf_packager.cpp"
"${appspawn_path}/src/fast_app_packager.cpp"
"${appspawn_path}/src/general_normalize.cpp"
"${appspawn_path}/src/hap_packager.cpp"
"${appspawn_path}/src/hqf_packager.cpp"
"${appspawn_path}/src/hqf_verify.cpp"
"${appspawn_path}/src/hsp_packager.cpp"
"${appspawn_path}/src/json/distro_filter.cpp"
"${appspawn_path}/src/json/general_normalize_version_utils.cpp"
"${appspawn_path}/src/json/hap_verify_info.cpp"
"${appspawn_path}/src/json/hap_verify_utils.cpp"
"${appspawn_path}/src/json/json_utils.cpp"
"${appspawn_path}/src/json/module_json.cpp"
"${appspawn_path}/src/json/module_json_fa.cpp"
"${appspawn_path}/src/json/module_json_stage.cpp"
"${appspawn_path}/src/json/module_json_utils.cpp"
"${appspawn_path}/src/json/normalize_version_utils.cpp"
"${appspawn_path}/src/json/pack_info.cpp"
"${appspawn_path}/src/json/pack_info_utils.cpp"
"${appspawn_path}/src/json/patch_json.cpp"
"${appspawn_path}/src/json/patch_json_utils.cpp"
"${appspawn_path}/src/json/pt_json.cpp"
"${appspawn_path}/src/log.cpp"
"${appspawn_path}/src/main.cpp"
"${appspawn_path}/src/multiapp_packager.cpp"
"${appspawn_path}/src/package_normalize.cpp"
"${appspawn_path}/src/packager.cpp"
"${appspawn_path}/src/res_packager.cpp"
"${appspawn_path}/src/shell_command.cpp"
"${appspawn_path}/src/unzip_wrapper.cpp"
"${appspawn_path}/src/utils.cpp"
"${appspawn_path}/src/version_normalize.cpp"
"${appspawn_path}/src/zip_utils.cpp"
"${appspawn_path}/src/zip_wrapper.cpp"
)


add_executable(packing_tool ${cliSources})
target_link_libraries(
    packing_tool
    boundscheck
    zlib
    cjson
    libcrypto
)