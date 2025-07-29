

set(appspawn_path ${CMAKE_CURRENT_LIST_DIR}/source)

include_directories(include
    ${appspawn_path}/service/hnp/base
    ${appspawn_path}/service/hnp/pack/include
    ${appspawn_path}/service/hnp/installer/include
    ../hapsigner/third_party/zlib/source
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DHNP_CLI -std=c++17  -Wall ")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DHNP_CLI  ")
set(cliSources 
"${appspawn_path}/service/hnp/base/hnp_file.c"
"${appspawn_path}/service/hnp/base/hnp_json.c"
"${appspawn_path}/service/hnp/base/hnp_log.c"
"${appspawn_path}/service/hnp/base/hnp_zip.c"
"${appspawn_path}/service/hnp/hnpcli_main.c"
"${appspawn_path}/service/hnp/pack/src/hnp_pack.c"
)

set(hnpSources 
"${appspawn_path}/service/hnp/base/hnp_file.c"
"${appspawn_path}/service/hnp/base/hnp_json.c"
"${appspawn_path}/service/hnp/base/hnp_log.c"
"${appspawn_path}/service/hnp/base/hnp_sal.c"
"${appspawn_path}/service/hnp/base/hnp_zip.c"
"${appspawn_path}/service/hnp/hnp_main.c"
"${appspawn_path}/service/hnp/installer/src/hnp_installer.c"
)


# add_library(hnp_cli SHARED ${cliSources} )
# target_link_libraries(
#     hnp_cli
#     boundscheck
#     zlib
#     cjson
# )

add_executable(hnpcli ${cliSources})
target_link_libraries(
    hnpcli
    boundscheck
    zlib
    cjson
)