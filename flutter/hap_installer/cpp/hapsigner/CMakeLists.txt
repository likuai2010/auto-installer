# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)

project(hapsigner C)
set(CMAKE_CXX_STANDARD 17)


add_subdirectory(third_party/bzip2)


set(rootDir ${CMAKE_CURRENT_SOURCE_DIR}/source/hapsigntool_cpp)
set(signature_tools_api ${rootDir}/api)
set(signature_tools_utils ${rootDir}/utils)
set(signature_tools_codesigning ${rootDir}/codesigning)
set(signature_tools_cmd ${rootDir}/cmd)
set(signature_tools_common ${rootDir}/common)
set(signature_tools_hap ${rootDir}/hap)
set(signature_tools_zip ${rootDir}/zip)
set(signature_tools_profile ${rootDir}/profile)
set(signature_tools_signer ${rootDir}/signer)

set(outputs
    "${rootDir}/main.cpp"
    "${signature_tools_api}/src/sign_tool_service_impl.cpp"
    "${signature_tools_api}/src/cert_tools.cpp"
    "${signature_tools_signer}/src/signer_factory.cpp"
    "${signature_tools_signer}/src/local_signer.cpp"
)
set(include_dirs
third_party/bzip2/source
third_party/zlib/source
third_party/json/source/include
)
list(APPEND include_dirs
"${signature_tools_api}/include"
"${signature_tools_signer}/include"
"${signature_tools_cmd}/include"
"${signature_tools_codesigning}/datastructure/include"
"${signature_tools_codesigning}/fsverity/include"
"${signature_tools_codesigning}/utils/include"
"${signature_tools_codesigning}/sign/include"
"${signature_tools_common}/include"
"${signature_tools_hap}/verify/include"
"${signature_tools_hap}/config/include"
"${signature_tools_hap}/entity/include"
"${signature_tools_hap}/provider/include"
"${signature_tools_hap}/sign/include"
"${signature_tools_hap}/utils/include"
"${signature_tools_profile}/include"
"${signature_tools_utils}/include"
"${signature_tools_zip}/include"
)

list(APPEND outputs
"${signature_tools_cmd}/src/cmd_util.cpp"
"${signature_tools_cmd}/src/params_run_tool.cpp"
"${signature_tools_cmd}/src/params_trust_list.cpp"
"${signature_tools_cmd}/src/params.cpp"

"${signature_tools_codesigning}/datastructure/src/code_sign_block.cpp"
"${signature_tools_codesigning}/datastructure/src/code_sign_block_header.cpp"
"${signature_tools_codesigning}/datastructure/src/extension.cpp"
"${signature_tools_codesigning}/datastructure/src/fs_verity_info_segment.cpp"
"${signature_tools_codesigning}/datastructure/src/hap_info_segment.cpp"
"${signature_tools_codesigning}/datastructure/src/merkle_tree_extension.cpp"
"${signature_tools_codesigning}/datastructure/src/native_lib_info_segment.cpp"
"${signature_tools_codesigning}/datastructure/src/segment_header.cpp"
"${signature_tools_codesigning}/datastructure/src/sign_info.cpp"
"${signature_tools_codesigning}/datastructure/src/signed_file_pos.cpp"
"${signature_tools_codesigning}/datastructure/src/elf_sign_block.cpp"
"${signature_tools_codesigning}/datastructure/src/unzip_handle_param.cpp"
"${signature_tools_codesigning}/fsverity/src/fs_verity_descriptor.cpp"
"${signature_tools_codesigning}/fsverity/src/fs_verity_digest.cpp"
"${signature_tools_codesigning}/fsverity/src/fs_verity_generator.cpp"
"${signature_tools_codesigning}/fsverity/src/fs_verity_hash_algorithm.cpp"
"${signature_tools_codesigning}/fsverity/src/merkle_tree_builder.cpp"
"${signature_tools_codesigning}/fsverity/src/fs_verity_descriptor_with_sign.cpp"
"${signature_tools_codesigning}/utils/src/fs_digest_utils.cpp"
"${signature_tools_codesigning}/utils/src/cms_utils.cpp"
"${signature_tools_codesigning}/sign/src/bc_signeddata_generator.cpp"
"${signature_tools_codesigning}/sign/src/code_signing.cpp"
"${signature_tools_codesigning}/sign/src/verify_code_signature.cpp"

"${signature_tools_common}/src/byte_buffer_data_source.cpp"
"${signature_tools_common}/src/byte_buffer.cpp"
"${signature_tools_common}/src/file_data_source.cpp"
"${signature_tools_common}/src/random_access_file.cpp"
"${signature_tools_common}/src/digest_parameter.cpp"
"${signature_tools_common}/src/digest_common.cpp"
"${signature_tools_common}/src/localization_adapter.cpp"
"${signature_tools_common}/src/options.cpp"

"${signature_tools_hap}/verify/src/verify_hap.cpp"
"${signature_tools_hap}/verify/src/verify_bin.cpp"
"${signature_tools_hap}/verify/src/verify_elf.cpp"
"${signature_tools_hap}/config/src/signer_config.cpp"
"${signature_tools_hap}/entity/src/content_digest_algorithm.cpp"
"${signature_tools_hap}/entity/src/param_constants.cpp"
"${signature_tools_hap}/entity/src/signature_algorithm_helper.cpp"
"${signature_tools_hap}/entity/src/block_data.cpp"
"${signature_tools_hap}/entity/src/block_head.cpp"
"${signature_tools_hap}/entity/src/sign_head.cpp"
"${signature_tools_hap}/entity/src/sign_block_info.cpp"
"${signature_tools_hap}/entity/src/sign_content_info.cpp"
"${signature_tools_hap}/entity/src/sign_block_data.cpp"
"${signature_tools_hap}/entity/src/signature_block_types.cpp"
"${signature_tools_hap}/entity/src/signing_block.cpp"
"${signature_tools_hap}/provider/src/local_sign_provider.cpp"
"${signature_tools_hap}/provider/src/remote_sign_provider.cpp"
"${signature_tools_hap}/provider/src/sign_provider.cpp"
"${signature_tools_hap}/sign/src/sign_hap.cpp"
"${signature_tools_hap}/sign/src/sign_bin.cpp"
"${signature_tools_hap}/sign/src/sign_elf.cpp"
"${signature_tools_hap}/utils/src/hap_utils.cpp"
"${signature_tools_hap}/utils/src/dynamic_lib_handle.cpp"
"${signature_tools_hap}/sign/src/bc_pkcs7_generator.cpp"

"${signature_tools_profile}/src/profile_info.cpp"
"${signature_tools_profile}/src/profile_verify.cpp"
"${signature_tools_profile}/src/pkcs7_data.cpp"
"${signature_tools_profile}/src/profile_sign_tool.cpp"

"${signature_tools_utils}/src/cert_dn_utils.cpp"
"${signature_tools_utils}/src/verify_cert_openssl_utils.cpp"
"${signature_tools_utils}/src/file_utils.cpp"
"${signature_tools_utils}/src/key_store_helper.cpp"
"${signature_tools_utils}/src/hap_signer_block_utils.cpp"
"${signature_tools_utils}/src/string_utils.cpp"
"${signature_tools_utils}/src/verify_hap_openssl_utils.cpp"
"${signature_tools_utils}/src/byte_array_utils.cpp"
"${signature_tools_utils}/src/hash_utils.cpp"

"${signature_tools_zip}/src/central_directory.cpp"
"${signature_tools_zip}/src/data_descriptor.cpp"
"${signature_tools_zip}/src/endof_central_directory.cpp"
"${signature_tools_zip}/src/random_access_file_input.cpp"
"${signature_tools_zip}/src/random_access_file_output.cpp"
"${signature_tools_zip}/src/zip_entry.cpp"
"${signature_tools_zip}/src/zip_entry_data.cpp"
"${signature_tools_zip}/src/zip_entry_header.cpp"
"${signature_tools_zip}/src/zip_signer.cpp"
"${signature_tools_zip}/src/zip_utils.cpp"
)

set(cflags
"-std=c++17"
"-fno-rtti"
"-Wno-c++20-extensions"
)
if(OHOS)
add_definitions(-DHILOG )
endif()
#多线程有问题， 容易崩溃，限制线程数1
#source/hapsigntool_cpp/codesigning/fsverity/include/thread_pool.h

include_directories(${include_dirs} ${CMAKE_CURRENT_SOURCE_DIR})


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${cflags}")
# musl 不支持 -pg 缺少 _mcount
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -ggdb -Wall ")

if(OHOS)
    set(LD_FLAGS "-fPIC -Wl-zrelro-znow-znoexecstack -fstack-protector-all"
    libace_napi.z.so
    hilog_ndk.z
    )
endif()
if(WIN32)
set(LD_FLAGS ws2_32)
endif()

list(APPEND outputs hap_signer_tool.cpp )

include_directories(${include_dirs})
link_libraries(
 ${LD_FLAGS}
 libcrypto
 boundscheck
 bzip2
 zlib
)

if(APPLE)
add_library(signtool STATIC ${outputs})
else()
add_library(signtool SHARED ${outputs})
endif()
add_executable(signtools ${outputs})





