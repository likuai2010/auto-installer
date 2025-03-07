
set(build_with_liblegacy  true)
set(openssl_enabled  true)

 message("openssl detecting os now...")
 message("current_cpu = ${current_cpu}")
 message("current_os = ${current_os}")
 message("host_os = ${host_os}")
set(openssl_selected_platform  "")
 message("is_mingw = ${is_mingw}")
# if(current_cpu == "arm" && !(current_os == "linux" || host_os == "mac")
#    message("openssl selected linux-armv4")
#   openssl_selected_platform = "linux-armv4"
# elseif(current_cpu == "arm64" &&
#           !(current_os == "linux" || host_os == "mac") ||
#             current_os == "ohos" ||
#            current_os == "linux" || host_os == "linux")
#    message("openssl selected linux-aarch64")
#   openssl_selected_platform = "linux-aarch64"
# elseif((current_cpu == "x64" || current_cpu == "x86_64") &&
#           current_os == "mac" || current_os == "ios")
#   # compilation for ios depends the platform
#    message("openssl selected darwin64-x86_64-cc")
#   openssl_selected_platform = "darwin64-x86_64-cc"
# elseif(current_cpu == "arm64" &&
#           current_os == "mac" || current_os == "ios")
#   # ios and macos both use the platform
#    message("openssl selected darwin64-arm64-cc")
#   openssl_selected_platform = "darwin64-arm64-cc"
# elseif((current_cpu == "x64" || current_cpu == "x86_64") &&
#            current_os != "mingw")
#    message("openssl selected linux-x86_64")
#   openssl_selected_platform = "linux-x86_64"
# elseif(is_mingw)
#    message("openssl selected mingw64")
#   openssl_selected_platform = "mingw64"
# elseif(current_cpu == "arm" && current_os == "android")
#    message("openssl selected linux-armv4")
#   openssl_selected_platform = "linux-armv4"
# elseif(current_cpu == "arm64" && current_os == "android")
#    message("openssl selected linux-aarch64")
#   openssl_selected_platform = "linux-aarch64"
# elseif(current_cpu == "loongarch64" && current_os == "ohos")
#    message("openssl selected linux64-loongarch64")
#   openssl_selected_platform = "linux64-loongarch64"
# endif()
openssl_selected_platform = "linux-aarch64"
 message(
    "openssl detecting os done. openssl_selected_platform = ${openssl_selected_platform}")

set(build_all_generated_path "${target_out_dir}/build_all_generated")

# 升级修改适配检查点1 libcrypto 不同平台汇编代码
set(libcrypto_build_all_generated_linux_armv4_sources
  "${build_all_generated_path}/crypto/aes/aes-armv4.S"
  "${build_all_generated_path}/crypto/aes/aesv8-armx.S"
  "${build_all_generated_path}/crypto/aes/bsaes-armv7.S"
  "${build_all_generated_path}/crypto/armv4cpuid.S"
  "${build_all_generated_path}/crypto/bn/armv4-gf2m.S"
  "${build_all_generated_path}/crypto/bn/armv4-mont.S"
  "${build_all_generated_path}/crypto/chacha/chacha-armv4.S"
  "${build_all_generated_path}/crypto/ec/ecp_nistz256-armv4.S"
  "${build_all_generated_path}/crypto/modes/ghash-armv4.S"
  "${build_all_generated_path}/crypto/modes/ghashv8-armx.S"
  "${build_all_generated_path}/crypto/poly1305/poly1305-armv4.S"
  "${build_all_generated_path}/crypto/sha/keccak1600-armv4.S"
  "${build_all_generated_path}/crypto/sha/sha1-armv4-large.S"
  "${build_all_generated_path}/crypto/sha/sha256-armv4.S"
  "${build_all_generated_path}/crypto/sha/sha512-armv4.S"
)

# 升级修改适配检查点2 libcrypto 不同平台汇编代码
set(libcrypto_build_all_generated_linux_aarch64_sources
  "${build_all_generated_path}/crypto/aes/aesv8-armx.S"
  "${build_all_generated_path}/crypto/aes/vpaes-armv8.S"
  "${build_all_generated_path}/crypto/arm64cpuid.S"
  "${build_all_generated_path}/crypto/bn/armv8-mont.S"
  "${build_all_generated_path}/crypto/chacha/chacha-armv8.S"
  "${build_all_generated_path}/crypto/ec/ecp_nistz256-armv8.S"
  "${build_all_generated_path}/crypto/modes/aes-gcm-armv8_64.S"
  "${build_all_generated_path}/crypto/modes/ghashv8-armx.S"
  "${build_all_generated_path}/crypto/poly1305/poly1305-armv8.S"
  "${build_all_generated_path}/crypto/sha/keccak1600-armv8.S"
  "${build_all_generated_path}/crypto/sha/sha1-armv8.S"
  "${build_all_generated_path}/crypto/sha/sha256-armv8.S"
  "${build_all_generated_path}/crypto/sha/sha512-armv8.S"
)

# 升级修改适配检查点3 libcrypto 不同平台汇编代码
set(libcrypto_build_all_generated_darwin64_x86_64_cc_sources
  "${build_all_generated_path}/crypto/aes/aes-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-mb-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-sha1-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-sha256-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-x86_64.s"
  "${build_all_generated_path}/crypto/aes/bsaes-x86_64.s"
  "${build_all_generated_path}/crypto/aes/vpaes-x86_64.s"
  "${build_all_generated_path}/crypto/bn/rsaz-avx2.s"
  "${build_all_generated_path}/crypto/bn/rsaz-avx512.s"
  "${build_all_generated_path}/crypto/bn/rsaz-x86_64.s"
  "${build_all_generated_path}/crypto/bn/x86_64-gf2m.s"
  "${build_all_generated_path}/crypto/bn/x86_64-mont.s"
  "${build_all_generated_path}/crypto/bn/x86_64-mont5.s"
  "${build_all_generated_path}/crypto/camellia/cmll-x86_64.s"
  "${build_all_generated_path}/crypto/chacha/chacha-x86_64.s"
  "${build_all_generated_path}/crypto/ec/ecp_nistz256-x86_64.s"
  "${build_all_generated_path}/crypto/ec/x25519-x86_64.s"
  "${build_all_generated_path}/crypto/md5/md5-x86_64.s"
  "${build_all_generated_path}/crypto/modes/aesni-gcm-x86_64.s"
  "${build_all_generated_path}/crypto/modes/ghash-x86_64.s"
  "${build_all_generated_path}/crypto/poly1305/poly1305-x86_64.s"
  "${build_all_generated_path}/crypto/rc4/rc4-md5-x86_64.s"
  "${build_all_generated_path}/crypto/rc4/rc4-x86_64.s"
  "${build_all_generated_path}/crypto/sha/keccak1600-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha1-mb-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha1-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha256-mb-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha256-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha512-x86_64.s"
  "${build_all_generated_path}/crypto/whrlpool/wp-x86_64.s"
  "${build_all_generated_path}/crypto/x86_64cpuid.s"
)
if(build_with_liblegacy)
  List(APPEND libcrypto_build_all_generated_darwin64_x86_64_cc_sources 
  "${build_all_generated_path}/engines/e_padlock-x86_64.s"
  )
endif()

# 升级修改适配检查点4 libcrypto 不同平台汇编代码
set(libcrypto_build_all_generated_darwin64_arm64_cc_sources
  "${build_all_generated_path}/crypto/aes/aesv8-armx.S"
  "${build_all_generated_path}/crypto/aes/vpaes-armv8.S"
  "${build_all_generated_path}/crypto/arm64cpuid.S"
  "${build_all_generated_path}/crypto/bn/armv8-mont.S"
  "${build_all_generated_path}/crypto/chacha/chacha-armv8.S"
  "${build_all_generated_path}/crypto/ec/ecp_nistz256-armv8.S"
  "${build_all_generated_path}/crypto/modes/aes-gcm-armv8_64.S"
  "${build_all_generated_path}/crypto/modes/ghashv8-armx.S"
  "${build_all_generated_path}/crypto/poly1305/poly1305-armv8.S"
  "${build_all_generated_path}/crypto/sha/keccak1600-armv8.S"
  "${build_all_generated_path}/crypto/sha/sha1-armv8.S"
  "${build_all_generated_path}/crypto/sha/sha256-armv8.S"
  "${build_all_generated_path}/crypto/sha/sha512-armv8.S"
)

# 升级修改适配检查点5 libcrypto 不同平台汇编代码
set(libcrypto_build_all_generated_linux_x86_64_sources
  "${build_all_generated_path}/crypto/aes/aes-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-mb-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-sha1-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-sha256-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-x86_64.s"
  "${build_all_generated_path}/crypto/aes/bsaes-x86_64.s"
  "${build_all_generated_path}/crypto/aes/vpaes-x86_64.s"
  "${build_all_generated_path}/crypto/bn/rsaz-avx2.s"
  "${build_all_generated_path}/crypto/bn/rsaz-avx512.s"
  "${build_all_generated_path}/crypto/bn/rsaz-x86_64.s"
  "${build_all_generated_path}/crypto/bn/x86_64-gf2m.s"
  "${build_all_generated_path}/crypto/bn/x86_64-mont.s"
  "${build_all_generated_path}/crypto/bn/x86_64-mont5.s"
  "${build_all_generated_path}/crypto/camellia/cmll-x86_64.s"
  "${build_all_generated_path}/crypto/chacha/chacha-x86_64.s"
  "${build_all_generated_path}/crypto/ec/ecp_nistz256-x86_64.s"
  "${build_all_generated_path}/crypto/ec/x25519-x86_64.s"
  "${build_all_generated_path}/crypto/md5/md5-x86_64.s"
  "${build_all_generated_path}/crypto/modes/aesni-gcm-x86_64.s"
  "${build_all_generated_path}/crypto/modes/ghash-x86_64.s"
  "${build_all_generated_path}/crypto/poly1305/poly1305-x86_64.s"
  "${build_all_generated_path}/crypto/rc4/rc4-md5-x86_64.s"
  "${build_all_generated_path}/crypto/rc4/rc4-x86_64.s"
  "${build_all_generated_path}/crypto/sha/keccak1600-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha1-mb-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha1-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha256-mb-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha256-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha512-x86_64.s"
  "${build_all_generated_path}/crypto/whrlpool/wp-x86_64.s"
  "${build_all_generated_path}/crypto/x86_64cpuid.s"
)
if(build_with_liblegacy)
  list(APPEND libcrypto_build_all_generated_linux_x86_64_sources 
  "${build_all_generated_path}/engines/e_padlock-x86_64.s" )
endif()

# 升级修改适配检查点2 libcrypto 不同平台汇编代码
set(libcrypto_build_all_generated_linux_loongarch64_sources
  "${build_all_generated_path}/crypto/loongarch64cpuid.s"
  "${build_all_generated_path}/crypto/md5/md5-loongarch64.S"
)

# 升级修改适配检查点6 libcrypto 不同平台汇编代码
set(libcrypto_build_all_generated_mingw64_sources
  "${build_all_generated_path}/crypto/aes/aes-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-mb-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-sha1-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-sha256-x86_64.s"
  "${build_all_generated_path}/crypto/aes/aesni-x86_64.s"
  "${build_all_generated_path}/crypto/aes/bsaes-x86_64.s"
  "${build_all_generated_path}/crypto/aes/vpaes-x86_64.s"
  "${build_all_generated_path}/crypto/bn/rsaz-avx2.s"
  "${build_all_generated_path}/crypto/bn/rsaz-avx512.s"
  "${build_all_generated_path}/crypto/bn/rsaz-x86_64.s"
  "${build_all_generated_path}/crypto/bn/x86_64-gf2m.s"
  "${build_all_generated_path}/crypto/bn/x86_64-mont.s"
  "${build_all_generated_path}/crypto/bn/x86_64-mont5.s"
  "${build_all_generated_path}/crypto/camellia/cmll-x86_64.s"
  "${build_all_generated_path}/crypto/chacha/chacha-x86_64.s"
  "${build_all_generated_path}/crypto/ec/ecp_nistz256-x86_64.s"
  "${build_all_generated_path}/crypto/ec/x25519-x86_64.s"
  "${build_all_generated_path}/crypto/md5/md5-x86_64.s"
  "${build_all_generated_path}/crypto/modes/aesni-gcm-x86_64.s"
  "${build_all_generated_path}/crypto/modes/ghash-x86_64.s"
  "${build_all_generated_path}/crypto/poly1305/poly1305-x86_64.s"
  "${build_all_generated_path}/crypto/rc4/rc4-md5-x86_64.s"
  "${build_all_generated_path}/crypto/rc4/rc4-x86_64.s"
  "${build_all_generated_path}/crypto/sha/keccak1600-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha1-mb-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha1-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha256-mb-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha256-x86_64.s"
  "${build_all_generated_path}/crypto/sha/sha512-x86_64.s"
  "${build_all_generated_path}/crypto/whrlpool/wp-x86_64.s"
  "${build_all_generated_path}/crypto/x86_64cpuid.s"
)
if(build_with_liblegacy)
  list(APPEND libcrypto_build_all_generated_mingw64_sources
   "${build_all_generated_path}/engines/e_padlock-x86_64.s" 
   )
endif()



set(libcrypto_build_all_generated_selected_platform_sources)
if(openssl_selected_platform == "linux-armv4")
    list(APPEND libcrypto_build_all_generated_selected_platform_sources
        ${libcrypto_build_all_generated_linux_armv4_sources})
elseif(openssl_selected_platform == "linux-aarch64")
    list(APPEND libcrypto_build_all_generated_selected_platform_sources
    ${libcrypto_build_all_generated_linux_aarch64_sources})
elseif(openssl_selected_platform == "darwin64-x86_64-cc")
    list(APPEND libcrypto_build_all_generated_selected_platform_sources
    ${ibcrypto_build_all_generated_darwin64_x86_64_cc_sources})
elseif(openssl_selected_platform == "darwin64-arm64-cc")
    list(APPEND libcrypto_build_all_generated_selected_platform_sources  
    ${libcrypto_build_all_generated_darwin64_arm64_cc_sources})
elseif(openssl_selected_platform == "linux-x86_64")
    list(APPEND libcrypto_build_all_generated_selected_platform_sources 
    ${libcrypto_build_all_generated_linux_x86_64_sources})
elseif(openssl_selected_platform == "mingw64")
    list(APPEND libcrypto_build_all_generated_selected_platform_sources  
    ${libcrypto_build_all_generated_mingw64_sources})
elseif(openssl_selected_platform == "linux64-loongarch64")
    list(APPEND libcrypto_build_all_generated_selected_platform_sources  
    ${libcrypto_build_all_generated_linux_loongarch64_sources})
endif()

# 升级修改适配检查点7 libcommon 生成的源码列表
libcommon_build_all_generated_selected_platform_sources
  "${build_all_generated_path}/providers/common/der/der_digests_gen.c"
  "${build_all_generated_path}/providers/common/der/der_dsa_gen.c"
  "${build_all_generated_path}/providers/common/der/der_ec_gen.c"
  "${build_all_generated_path}/providers/common/der/der_ecx_gen.c"
  "${build_all_generated_path}/providers/common/der/der_rsa_gen.c"
  "${build_all_generated_path}/providers/common/der/der_wrap_gen.c"
endif()

# 升级修改适配检查点8 libdefault 生成的源码列表
set(libdefault_build_all_generated_selected_platform_sources 
"${build_all_generated_path}/providers/common/der/der_sm2_gen.c"
)

# We make use of both exec_script and action to build openssl build_all_generated items.
#
# Some modules use openssl in an incorrect way leading to the confusing building sequences
# so the user modules building fail because openssl headers have not been generated at the building time.
# The exec_script in the global area will be executed before ninja command
# and it ensures that the headers is generated properly before the building of any modules.
#
# Openssl generate some assembly codes before it is building.
# The sources list in BUILD.gn include the assembly codes.
# The gn build system requires that all items in sources list should be the output of another build item.
# So we use an empty action to generate the assembly codes.
# Actually we generate the assembly codes in exec_script not in action.
#
# The gn build system requires the script in exec_script and action should be python script
# so we invoke the shell script in python script

# action("openssl_build_all_generated")
#   script = rebase_path("//third_party/openssl/empty.py")
#   outputs)
#   outputs += libcommon_build_all_generated_selected_platform_sources
#   outputs += libdefault_build_all_generated_selected_platform_sources
#   outputs += set(libcrypto_build_all_generated_selected_platform_sources
#   outputs +( "${build_all_generated_path}/apps/progs.c" )
#   if(openssl_selected_platform == "mingw64")
#     outputs +( "${build_all_generated_path}/apps/openssl.rc" )
#   }
# }

set(openssl_internal_cflags
  "-Wall"

  # ../../third_party/openssl/crypto/o_str.c:309:9: error: incompatible integer to pointer conversion assigning to 'char *' from 'int' [-Werror-Wint-conversion)
  #     err = strerror_r(errnum buf buflen);
  #         ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  "-Wno-error=int-conversion"

  # ../../third_party/openssl/crypto/bn/bn_conv.c:92:34: error: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 10000000000000000000 to 2313682944 [-Werror-Wconstant-conversion)
  #             *lp = BN_div_word(t BN_DEC_CONV);
  #                   ~~~~~~~~~~~    ^~~~~~~~~~~
  "-Wno-error=constant-conversion"

  # ../../third_party/openssl/crypto/bn/bn_exp.c:382:38: error: shift count >= width of type [-Werror-Wshift-count-overflow)
  #     ifm->d[j - 1) &((BN_ULONG)1) <<BN_BITS2 - 1)))
  #                                      ^  ~~~~~~~~~~~~~~
  "-Wno-error=shift-count-overflow"

  # ../../third_party/openssl/crypto/conf/conf_def.c:31:11: error: 'stat' macro redefined [-Werror-Wmacro-redefined)
  # #  define stat    _stat
  #           ^
  # ../../prebuilts/mingw-w64/ohos/linux-x86_64/clang-mingw/x86_64-w64-mingw32/include/sys/stat.h:279:9: note: previous definition is here
  # #define stat _stat64
  #         ^
  # 1 error generated.
  "-Wno-error=macro-redefined"

  "-Wno-error=implicit-fallthrough"
  "-Wno-error=sign-compare"
)
if(NOT compatible_with_legacy_build_system)
  list(APPEND openssl_internal_cflags
    # Fix llvm-15 build error
    "-Wno-unused-but-set-variable"
  )
endif()

if(current_cpu == "loongarch64")
list(APPEND openssl_internal_cflags
    "-Wno-error=constant-conversion"
    "-Wno-error=macro-redefined"
  )
endif()

# 升级修改适配检查点9 内部公共头文件目录列表
set(crypto_config_common_private_include_dirs
  # -I args from Makefile
  "."
  "crypto"
  "include"
  "providers/common/include"
  "providers/implementations/include"

  # internal include dirs
  "apps/include"
  "crypto/bn"
  "crypto/ec"
  "crypto/ec/curve448"
  "crypto/modes"
  "crypto/rsa"
  "providers/common/include/prov"

  "${build_all_generated_path}/apps"
  "${build_all_generated_path}/crypto"
  "${build_all_generated_path}/include"
  "${build_all_generated_path}/include/crypto"
  "${build_all_generated_path}/include/openssl"
  "${build_all_generated_path}/providers/common/include"
  "${build_all_generated_path}/providers/common/include/prov"
)
set(crypto_config_common_public_include_dirs
  "include"
  "${build_all_generated_path}/include"
)


# 升级修改适配检查点10 内部公共编译选项宏列表
set(crypto_config_common_cflags
  "-Wa--noexecstack"
  "-DNDEBUG"
  "-DOPENSSL_BUILDING_OPENSSL"
  "-DOPENSSL_CPUID_OBJ"
  "-DOPENSSL_PIC"

  # use `openssl version -a` cmd to see runtime OPENSSLDIR ENGINESDIR MODULESDIR value

  # the origin value generated by Configure
  # linux-armv4 linux-aarch64 darwin64-x86_64-cc darwin64-arm64-cc
  # /usr/local/lib/engines-3
  # linux-x86_64 mingw64
  # /usr/local/lib64/engines-3
  "-DENGINESDIR=\"\""

  # the origin value generated by Configure
  # linux-armv4 linux-aarch64 darwin64-x86_64-cc darwin64-arm64-cc
  # /usr/local/lib/ossl-modules
  # linux-x86_64 mingw64
  # /usr/local/lib64/ossl-modules
  "-DMODULESDIR=\"\""

  # the origin value generated by Configure
  # /usr/local/ssl
  # we set the variable as the following to locate openssl.cnf
  "-DOPENSSLDIR=\"/system/etc\""
)
if(build_with_liblegacy)
  list(APPEND crypto_config_common_cflags  
  "-DSTATIC_LEGACY" )
endif()

# 升级修改适配检查点11 内部不同平台编译选项列表
set(crypto_config_linux_armv4_cflags
  "-DOPENSSL_USE_NODELETE"
  "-fPIC"
  "-pthread"

  "-DAES_ASM"
  "-DBSAES_ASM"
  "-DECP_NISTZ256_ASM"
  "-DGHASH_ASM"
  "-DKECCAK1600_ASM"
  "-DOPENSSL_BN_ASM_GF2m"
  "-DOPENSSL_BN_ASM_MONT"
  "-DPOLY1305_ASM"
  "-DSHA1_ASM"
  "-DSHA256_ASM"
  "-DSHA512_ASM"
)

# 升级修改适配检查点12 内部不同平台编译选项列表
set(crypto_config_linux_aarch64_cflags
  "-DOPENSSL_USE_NODELETE"
  "-fPIC"
  "-pthread"

  "-DECP_NISTZ256_ASM"
  "-DKECCAK1600_ASM"
  "-DOPENSSL_BN_ASM_MONT"
  "-DPOLY1305_ASM"
  "-DSHA1_ASM"
  "-DSHA256_ASM"
  "-DSHA512_ASM"
  "-DVPAES_ASM"
)

# 升级修改适配检查点13 内部不同平台编译选项列表
set(crypto_config_darwin64_x86_64_cc_cflags
  "-fPIC"
  "-DL_ENDIAN"
  "-D_REENTRANT"
  "-DOPENSSL_IA32_SSE2"

  "-DAES_ASM"
  "-DBSAES_ASM"
  "-DCMLL_ASM"
  "-DECP_NISTZ256_ASM"
  "-DGHASH_ASM"
  "-DKECCAK1600_ASM"
  "-DMD5_ASM"
  "-DOPENSSL_BN_ASM_GF2m"
  "-DOPENSSL_BN_ASM_MONT"
  "-DOPENSSL_BN_ASM_MONT5"
  "-DPOLY1305_ASM"
  "-DSHA1_ASM"
  "-DSHA256_ASM"
  "-DSHA512_ASM"
  "-DVPAES_ASM"
  "-DWHIRLPOOL_ASM"
  "-DX25519_ASM"
)
if(build_with_liblegacy)
list(APPEND  crypto_config_darwin64_x86_64_cc_cflags  "-DPADLOCK_ASM" )
endif()

# 升级修改适配检查点14 内部不同平台编译选项列表
set(crypto_config_darwin64_arm64_cc_cflags
  "-DL_ENDIAN"
  "-D_REENTRANT"
  "-fPIC"

  "-DECP_NISTZ256_ASM"
  "-DKECCAK1600_ASM"
  "-DOPENSSL_BN_ASM_MONT"
  "-DPOLY1305_ASM"
  "-DSHA1_ASM"
  "-DSHA256_ASM"
  "-DSHA512_ASM"
  "-DVPAES_ASM"
)

# 升级修改适配检查点15 内部不同平台编译选项列表
set(crypto_config_linux_x86_64_cflags
  "-DL_ENDIAN"
  "-DOPENSSL_IA32_SSE2"
  "-DOPENSSL_USE_NODELETE"
  "-fPIC"
  "-m64"
  "-pthread"

  "-DAES_ASM"
  "-DBSAES_ASM"
  "-DCMLL_ASM"
  "-DECP_NISTZ256_ASM"
  "-DGHASH_ASM"
  "-DKECCAK1600_ASM"
  "-DMD5_ASM"
  "-DOPENSSL_BN_ASM_GF2m"
  "-DOPENSSL_BN_ASM_MONT"
  "-DOPENSSL_BN_ASM_MONT5"
  "-DPOLY1305_ASM"
  "-DSHA1_ASM"
  "-DSHA256_ASM"
  "-DSHA512_ASM"
  "-DVPAES_ASM"
  "-DWHIRLPOOL_ASM"
  "-DX25519_ASM"
)
if(build_with_liblegacy)
list(APPEND  crypto_config_linux_x86_64_cflags "-DPADLOCK_ASM" )
endif()

# 升级修改适配检查点16 内部不同平台编译选项列表
set(crypto_config_mingw64_cflags
  "-D_MT"
  "-D_UNICODE"
  "-DL_ENDIAN"
  "-DOPENSSL_IA32_SSE2"
  "-DUNICODE"
  "-DWIN32_LEAN_AND_MEAN"
  "-m64"

  "-DAES_ASM"
  "-DBSAES_ASM"
  "-DCMLL_ASM"
  "-DECP_NISTZ256_ASM"
  "-DGHASH_ASM"
  "-DKECCAK1600_ASM"
  "-DMD5_ASM"
  "-DOPENSSL_BN_ASM_GF2m"
  "-DOPENSSL_BN_ASM_MONT"
  "-DOPENSSL_BN_ASM_MONT5"
  "-DPOLY1305_ASM"
  "-DSHA1_ASM"
  "-DSHA256_ASM"
  "-DSHA512_ASM"
  "-DVPAES_ASM"
  "-DWHIRLPOOL_ASM"
  "-DX25519_ASM"
)
if(build_with_liblegacy)
  list(APPEND crypto_config_mingw64_cflags  "-DPADLOCK_ASM" )
endif()

set(crypto_config_linux_loongarch64_cflags
  "-DOPENSSL_USE_NODELETE"
  "-fPIC"
  "-pthread"
  "-Wall"
  "-O3"
  "-DNDEBUG"
  "-MMD"
  "-MF"
  "-DOPENSSL_BUILDING_OPENSSL"
  "-DOPENSSL_PIC"
)

set(crypto_config_current_platform_cflags)
if(openssl_selected_platform == "linux-armv4")
  crypto_config_current_platform_cflags += crypto_config_linux_armv4_cflags
elseif(openssl_selected_platform == "linux-aarch64")
  crypto_config_current_platform_cflags += crypto_config_linux_aarch64_cflags
elseif(openssl_selected_platform == "darwin64-x86_64-cc")
  crypto_config_current_platform_cflags +=
      crypto_config_darwin64_x86_64_cc_cflags
elseif(openssl_selected_platform == "darwin64-arm64-cc")
  crypto_config_current_platform_cflags +=
      crypto_config_darwin64_arm64_cc_cflags
elseif(openssl_selected_platform == "linux-x86_64")
  crypto_config_current_platform_cflags += crypto_config_linux_x86_64_cflags
elseif(openssl_selected_platform == "mingw64")
  crypto_config_current_platform_cflags += crypto_config_mingw64_cflags
elseif(openssl_selected_platform == "linux64-loongarch64")
  crypto_config_current_platform_cflags +=
      crypto_config_linux_loongarch64_cflags
}

if(mingw32_libs_path
mingw32_libs
ifis_mingw || is_win)
  mingw32_libs_path +( "//prebuilts/mingw-w64/ohos/linux-x86_64/clang-mingw/x86_64-w64-mingw32/lib" )
  mingw32_libs +(
    "ws2_32"
    "crypt32"
  )
}

config("crypto_config_private")
  include_dirs = crypto_config_common_private_include_dirs
  cflags = crypto_config_common_cflags + crypto_config_current_platform_cflags +
           openssl_internal_cflags
  lib_dirs = mingw32_libs_path
  libs = mingw32_libs
}

config("crypto_config_public")
  include_dirs = crypto_config_common_public_include_dirs
  libs = mingw32_libs
}

# 升级修改适配检查点17 libcommon 原目录源码列表
set(libcommon_common_sources
  "providers/common/der/der_dsa_key.c"
  "providers/common/der/der_dsa_sig.c"
  "providers/common/der/der_ec_key.c"
  "providers/common/der/der_ec_sig.c"
  "providers/common/der/der_ecx_key.c"
  "providers/common/der/der_rsa_key.c"
  "providers/common/provider_ctx.c"
  "providers/common/provider_err.c"
  "providers/implementations/ciphers/ciphercommon.c"
  "providers/implementations/ciphers/ciphercommon_block.c"
  "providers/implementations/ciphers/ciphercommon_ccm.c"
  "providers/implementations/ciphers/ciphercommon_ccm_hw.c"
  "providers/implementations/ciphers/ciphercommon_gcm.c"
  "providers/implementations/ciphers/ciphercommon_gcm_hw.c"
  "providers/implementations/ciphers/ciphercommon_hw.c"
  "providers/implementations/digests/digestcommon.c"
  "ssl/record/tls_pad.c"
)

# 升级修改适配检查点18 libdefault 原目录源码列表
set(libdefault_common_sources
  "providers/common/bio_prov.c"
  "providers/common/capabilities.c"
  "providers/common/der/der_rsa_sig.c"
  "providers/common/der/der_sm2_key.c"
  "providers/common/der/der_sm2_sig.c"
  "providers/common/digest_to_nid.c"
  "providers/common/provider_seeding.c"
  "providers/common/provider_util.c"
  "providers/common/securitycheck.c"
  "providers/common/securitycheck_default.c"
  "providers/implementations/asymciphers/rsa_enc.c"
  "providers/implementations/asymciphers/sm2_enc.c"
  "providers/implementations/ciphers/cipher_aes.c"
  "providers/implementations/ciphers/cipher_aes_cbc_hmac_sha.c"
  "providers/implementations/ciphers/cipher_aes_cbc_hmac_sha1_hw.c"
  "providers/implementations/ciphers/cipher_aes_cbc_hmac_sha256_hw.c"
  "providers/implementations/ciphers/cipher_aes_ccm.c"
  "providers/implementations/ciphers/cipher_aes_ccm_hw.c"
  "providers/implementations/ciphers/cipher_aes_gcm.c"
  "providers/implementations/ciphers/cipher_aes_gcm_hw.c"
  "providers/implementations/ciphers/cipher_aes_hw.c"
  "providers/implementations/ciphers/cipher_aes_ocb.c"
  "providers/implementations/ciphers/cipher_aes_ocb_hw.c"
  "providers/implementations/ciphers/cipher_aes_siv.c"
  "providers/implementations/ciphers/cipher_aes_siv_hw.c"
  "providers/implementations/ciphers/cipher_aes_wrp.c"
  "providers/implementations/ciphers/cipher_aes_xts.c"
  "providers/implementations/ciphers/cipher_aes_xts_fips.c"
  "providers/implementations/ciphers/cipher_aes_xts_hw.c"
  "providers/implementations/ciphers/cipher_aria.c"
  "providers/implementations/ciphers/cipher_aria_ccm.c"
  "providers/implementations/ciphers/cipher_aria_ccm_hw.c"
  "providers/implementations/ciphers/cipher_aria_gcm.c"
  "providers/implementations/ciphers/cipher_aria_gcm_hw.c"
  "providers/implementations/ciphers/cipher_aria_hw.c"
  "providers/implementations/ciphers/cipher_camellia.c"
  "providers/implementations/ciphers/cipher_camellia_hw.c"
  "providers/implementations/ciphers/cipher_chacha20.c"
  "providers/implementations/ciphers/cipher_chacha20_hw.c"
  "providers/implementations/ciphers/cipher_chacha20_poly1305.c"
  "providers/implementations/ciphers/cipher_chacha20_poly1305_hw.c"
  "providers/implementations/ciphers/cipher_cts.c"
  "providers/implementations/ciphers/cipher_null.c"
  "providers/implementations/ciphers/cipher_sm4.c"
  "providers/implementations/ciphers/cipher_sm4_ccm.c"
  "providers/implementations/ciphers/cipher_sm4_ccm_hw.c"
  "providers/implementations/ciphers/cipher_sm4_gcm.c"
  "providers/implementations/ciphers/cipher_sm4_gcm_hw.c"
  "providers/implementations/ciphers/cipher_sm4_hw.c"
  "providers/implementations/ciphers/cipher_tdes.c"
  "providers/implementations/ciphers/cipher_tdes_common.c"
  "providers/implementations/ciphers/cipher_tdes_default.c"
  "providers/implementations/ciphers/cipher_tdes_default_hw.c"
  "providers/implementations/ciphers/cipher_tdes_hw.c"
  "providers/implementations/ciphers/cipher_tdes_wrap.c"
  "providers/implementations/ciphers/cipher_tdes_wrap_hw.c"
  "providers/implementations/digests/blake2_prov.c"
  "providers/implementations/digests/blake2b_prov.c"
  "providers/implementations/digests/blake2s_prov.c"
  "providers/implementations/digests/md5_prov.c"
  "providers/implementations/digests/md5_sha1_prov.c"
  "providers/implementations/digests/null_prov.c"
  "providers/implementations/digests/ripemd_prov.c"
  "providers/implementations/digests/sha2_prov.c"
  "providers/implementations/digests/sha3_prov.c"
  "providers/implementations/digests/sm3_prov.c"
  "providers/implementations/encode_decode/decode_der2key.c"
  "providers/implementations/encode_decode/decode_epki2pki.c"
  "providers/implementations/encode_decode/decode_msblob2key.c"
  "providers/implementations/encode_decode/decode_pem2der.c"
  "providers/implementations/encode_decode/decode_pvk2key.c"
  "providers/implementations/encode_decode/decode_spki2typespki.c"
  "providers/implementations/encode_decode/encode_key2any.c"
  "providers/implementations/encode_decode/encode_key2blob.c"
  "providers/implementations/encode_decode/encode_key2ms.c"
  "providers/implementations/encode_decode/encode_key2text.c"
  "providers/implementations/encode_decode/endecoder_common.c"
  "providers/implementations/exchange/dh_exch.c"
  "providers/implementations/exchange/ecdh_exch.c"
  "providers/implementations/exchange/ecx_exch.c"
  "providers/implementations/exchange/kdf_exch.c"
  "providers/implementations/kdfs/hkdf.c"
  "providers/implementations/kdfs/kbkdf.c"
  "providers/implementations/kdfs/krb5kdf.c"
  "providers/implementations/kdfs/pbkdf2.c"
  "providers/implementations/kdfs/pbkdf2_fips.c"
  "providers/implementations/kdfs/pkcs12kdf.c"
  "providers/implementations/kdfs/scrypt.c"
  "providers/implementations/kdfs/sshkdf.c"
  "providers/implementations/kdfs/sskdf.c"
  "providers/implementations/kdfs/tls1_prf.c"
  "providers/implementations/kdfs/x942kdf.c"
  "providers/implementations/kem/rsa_kem.c"
  "providers/implementations/keymgmt/dh_kmgmt.c"
  "providers/implementations/keymgmt/dsa_kmgmt.c"
  "providers/implementations/keymgmt/ec_kmgmt.c"
  "providers/implementations/keymgmt/ecx_kmgmt.c"
  "providers/implementations/keymgmt/kdf_legacy_kmgmt.c"
  "providers/implementations/keymgmt/mac_legacy_kmgmt.c"
  "providers/implementations/keymgmt/rsa_kmgmt.c"
  "providers/implementations/macs/blake2b_mac.c"
  "providers/implementations/macs/blake2s_mac.c"
  "providers/implementations/macs/cmac_prov.c"
  "providers/implementations/macs/gmac_prov.c"
  "providers/implementations/macs/hmac_prov.c"
  "providers/implementations/macs/kmac_prov.c"
  "providers/implementations/macs/poly1305_prov.c"
  "providers/implementations/macs/siphash_prov.c"
  "providers/implementations/rands/crngt.c"
  "providers/implementations/rands/drbg.c"
  "providers/implementations/rands/drbg_ctr.c"
  "providers/implementations/rands/drbg_hash.c"
  "providers/implementations/rands/drbg_hmac.c"
  "providers/implementations/rands/seed_src.c"
  "providers/implementations/rands/seeding/rand_cpu_x86.c"
  "providers/implementations/rands/seeding/rand_tsc.c"
  "providers/implementations/rands/seeding/rand_unix.c"
  "providers/implementations/rands/seeding/rand_win.c"
  "providers/implementations/rands/test_rng.c"
  "providers/implementations/signature/dsa_sig.c"
  "providers/implementations/signature/ecdsa_sig.c"
  "providers/implementations/signature/eddsa_sig.c"
  "providers/implementations/signature/mac_legacy_sig.c"
  "providers/implementations/signature/rsa_sig.c"
  "providers/implementations/signature/sm2_sig.c"
  "providers/implementations/storemgmt/file_store.c"
  "providers/implementations/storemgmt/file_store_any2obj.c"
  "ssl/s3_cbc.c"
)

# 升级修改适配检查点19 liblegacy 源码列表
if(build_with_liblegacy)
  liblegacy_sources
    "providers/implementations/ciphers/cipher_blowfish.c"
    "providers/implementations/ciphers/cipher_blowfish_hw.c"
    "providers/implementations/ciphers/cipher_cast5.c"
    "providers/implementations/ciphers/cipher_cast5_hw.c"
    "providers/implementations/ciphers/cipher_des.c"
    "providers/implementations/ciphers/cipher_des_hw.c"
    "providers/implementations/ciphers/cipher_desx.c"
    "providers/implementations/ciphers/cipher_desx_hw.c"
    "providers/implementations/ciphers/cipher_idea.c"
    "providers/implementations/ciphers/cipher_idea_hw.c"
    "providers/implementations/ciphers/cipher_rc2.c"
    "providers/implementations/ciphers/cipher_rc2_hw.c"
    "providers/implementations/ciphers/cipher_rc4.c"
    "providers/implementations/ciphers/cipher_rc4_hmac_md5.c"
    "providers/implementations/ciphers/cipher_rc4_hmac_md5_hw.c"
    "providers/implementations/ciphers/cipher_rc4_hw.c"
    "providers/implementations/ciphers/cipher_seed.c"
    "providers/implementations/ciphers/cipher_seed_hw.c"
    "providers/implementations/digests/md4_prov.c"
    "providers/implementations/digests/mdc2_prov.c"
    "providers/implementations/digests/wp_prov.c"
    "providers/implementations/kdfs/pbkdf1.c"
  )
endif()


  # 升级修改适配检查点20 libcrypto 原目录源码列表
set(sources
    "crypto/aes/aes_cfb.c"
    "crypto/aes/aes_ecb.c"
    "crypto/aes/aes_ige.c"
    "crypto/aes/aes_misc.c"
    "crypto/aes/aes_ofb.c"
    "crypto/aes/aes_wrap.c"
    "crypto/aria/aria.c"
    "crypto/asn1/a_bitstr.c"
    "crypto/asn1/a_d2i_fp.c"
    "crypto/asn1/a_digest.c"
    "crypto/asn1/a_dup.c"
    "crypto/asn1/a_gentm.c"
    "crypto/asn1/a_i2d_fp.c"
    "crypto/asn1/a_int.c"
    "crypto/asn1/a_mbstr.c"
    "crypto/asn1/a_object.c"
    "crypto/asn1/a_octet.c"
    "crypto/asn1/a_print.c"
    "crypto/asn1/a_sign.c"
    "crypto/asn1/a_strex.c"
    "crypto/asn1/a_strnid.c"
    "crypto/asn1/a_time.c"
    "crypto/asn1/a_type.c"
    "crypto/asn1/a_utctm.c"
    "crypto/asn1/a_utf8.c"
    "crypto/asn1/a_verify.c"
    "crypto/asn1/ameth_lib.c"
    "crypto/asn1/asn1_err.c"
    "crypto/asn1/asn1_gen.c"
    "crypto/asn1/asn1_item_list.c"
    "crypto/asn1/asn1_lib.c"
    "crypto/asn1/asn1_parse.c"
    "crypto/asn1/asn_mime.c"
    "crypto/asn1/asn_moid.c"
    "crypto/asn1/asn_mstbl.c"
    "crypto/asn1/asn_pack.c"
    "crypto/asn1/bio_asn1.c"
    "crypto/asn1/bio_ndef.c"
    "crypto/asn1/d2i_param.c"
    "crypto/asn1/d2i_pr.c"
    "crypto/asn1/d2i_pu.c"
    "crypto/asn1/evp_asn1.c"
    "crypto/asn1/f_int.c"
    "crypto/asn1/f_string.c"
    "crypto/asn1/i2d_evp.c"
    "crypto/asn1/n_pkey.c"
    "crypto/asn1/nsseq.c"
    "crypto/asn1/p5_pbe.c"
    "crypto/asn1/p5_pbev2.c"
    "crypto/asn1/p5_scrypt.c"
    "crypto/asn1/p8_pkey.c"
    "crypto/asn1/t_bitst.c"
    "crypto/asn1/t_pkey.c"
    "crypto/asn1/t_spki.c"
    "crypto/asn1/tasn_dec.c"
    "crypto/asn1/tasn_enc.c"
    "crypto/asn1/tasn_fre.c"
    "crypto/asn1/tasn_new.c"
    "crypto/asn1/tasn_prn.c"
    "crypto/asn1/tasn_scn.c"
    "crypto/asn1/tasn_typ.c"
    "crypto/asn1/tasn_utl.c"
    "crypto/asn1/x_algor.c"
    "crypto/asn1/x_bignum.c"
    "crypto/asn1/x_info.c"
    "crypto/asn1/x_int64.c"
    "crypto/asn1/x_long.c"
    "crypto/asn1/x_pkey.c"
    "crypto/asn1/x_sig.c"
    "crypto/asn1/x_spki.c"
    "crypto/asn1/x_val.c"
    "crypto/asn1_dsa.c"
    "crypto/async/arch/async_null.c"
    "crypto/async/arch/async_posix.c"
    "crypto/async/arch/async_win.c"
    "crypto/async/async.c"
    "crypto/async/async_err.c"
    "crypto/async/async_wait.c"
    "crypto/bf/bf_cfb64.c"
    "crypto/bf/bf_ecb.c"
    "crypto/bf/bf_enc.c"
    "crypto/bf/bf_ofb64.c"
    "crypto/bf/bf_skey.c"
    "crypto/bio/bf_buff.c"
    "crypto/bio/bf_lbuf.c"
    "crypto/bio/bf_nbio.c"
    "crypto/bio/bf_null.c"
    "crypto/bio/bf_prefix.c"
    "crypto/bio/bf_readbuff.c"
    "crypto/bio/bio_addr.c"
    "crypto/bio/bio_cb.c"
    "crypto/bio/bio_dump.c"
    "crypto/bio/bio_err.c"
    "crypto/bio/bio_lib.c"
    "crypto/bio/bio_meth.c"
    "crypto/bio/bio_print.c"
    "crypto/bio/bio_sock.c"
    "crypto/bio/bio_sock2.c"
    "crypto/bio/bss_acpt.c"
    "crypto/bio/bss_bio.c"
    "crypto/bio/bss_conn.c"
    "crypto/bio/bss_core.c"
    "crypto/bio/bss_dgram.c"
    "crypto/bio/bss_fd.c"
    "crypto/bio/bss_file.c"
    "crypto/bio/bss_log.c"
    "crypto/bio/bss_mem.c"
    "crypto/bio/bss_null.c"
    "crypto/bio/bss_sock.c"
    "crypto/bio/ossl_core_bio.c"
    "crypto/bn/bn_add.c"
    "crypto/bn/bn_blind.c"
    "crypto/bn/bn_const.c"
    "crypto/bn/bn_conv.c"
    "crypto/bn/bn_ctx.c"
    "crypto/bn/bn_depr.c"
    "crypto/bn/bn_dh.c"
    "crypto/bn/bn_div.c"
    "crypto/bn/bn_err.c"
    "crypto/bn/bn_exp.c"
    "crypto/bn/bn_exp2.c"
    "crypto/bn/bn_gcd.c"
    "crypto/bn/bn_gf2m.c"
    "crypto/bn/bn_intern.c"
    "crypto/bn/bn_kron.c"
    "crypto/bn/bn_lib.c"
    "crypto/bn/bn_mod.c"
    "crypto/bn/bn_mont.c"
    "crypto/bn/bn_mpi.c"
    "crypto/bn/bn_mul.c"
    "crypto/bn/bn_nist.c"
    "crypto/bn/bn_prime.c"
    "crypto/bn/bn_print.c"
    "crypto/bn/bn_rand.c"
    "crypto/bn/bn_recp.c"
    "crypto/bn/bn_rsa_fips186_4.c"
    "crypto/bn/bn_shift.c"
    "crypto/bn/bn_sqr.c"
    "crypto/bn/bn_sqrt.c"
    "crypto/bn/bn_srp.c"
    "crypto/bn/bn_word.c"
    "crypto/bn/bn_x931p.c"
    "crypto/bsearch.c"
    "crypto/buffer/buf_err.c"
    "crypto/buffer/buffer.c"
    "crypto/camellia/cmll_cfb.c"
    "crypto/camellia/cmll_ctr.c"
    "crypto/camellia/cmll_ecb.c"
    "crypto/camellia/cmll_misc.c"
    "crypto/camellia/cmll_ofb.c"
    "crypto/cast/c_cfb64.c"
    "crypto/cast/c_ecb.c"
    "crypto/cast/c_enc.c"
    "crypto/cast/c_ofb64.c"
    "crypto/cast/c_skey.c"
    "crypto/cmac/cmac.c"
    "crypto/cmp/cmp_asn.c"
    "crypto/cmp/cmp_client.c"
    "crypto/cmp/cmp_ctx.c"
    "crypto/cmp/cmp_err.c"
    "crypto/cmp/cmp_hdr.c"
    "crypto/cmp/cmp_http.c"
    "crypto/cmp/cmp_msg.c"
    "crypto/cmp/cmp_protect.c"
    "crypto/cmp/cmp_server.c"
    "crypto/cmp/cmp_status.c"
    "crypto/cmp/cmp_util.c"
    "crypto/cmp/cmp_vfy.c"
    "crypto/cms/cms_asn1.c"
    "crypto/cms/cms_att.c"
    "crypto/cms/cms_cd.c"
    "crypto/cms/cms_dd.c"
    "crypto/cms/cms_dh.c"
    "crypto/cms/cms_ec.c"
    "crypto/cms/cms_enc.c"
    "crypto/cms/cms_env.c"
    "crypto/cms/cms_err.c"
    "crypto/cms/cms_ess.c"
    "crypto/cms/cms_io.c"
    "crypto/cms/cms_kari.c"
    "crypto/cms/cms_lib.c"
    "crypto/cms/cms_pwri.c"
    "crypto/cms/cms_rsa.c"
    "crypto/cms/cms_sd.c"
    "crypto/cms/cms_smime.c"
    "crypto/comp/c_zlib.c"
    "crypto/comp/comp_err.c"
    "crypto/comp/comp_lib.c"
    "crypto/conf/conf_api.c"
    "crypto/conf/conf_def.c"
    "crypto/conf/conf_err.c"
    "crypto/conf/conf_lib.c"
    "crypto/conf/conf_mall.c"
    "crypto/conf/conf_mod.c"
    "crypto/conf/conf_sap.c"
    "crypto/conf/conf_ssl.c"
    "crypto/context.c"
    "crypto/core_algorithm.c"
    "crypto/core_fetch.c"
    "crypto/core_namemap.c"
    "crypto/cpt_err.c"
    "crypto/cpuid.c"
    "crypto/crmf/crmf_asn.c"
    "crypto/crmf/crmf_err.c"
    "crypto/crmf/crmf_lib.c"
    "crypto/crmf/crmf_pbm.c"
    "crypto/cryptlib.c"
    "crypto/ct/ct_b64.c"
    "crypto/ct/ct_err.c"
    "crypto/ct/ct_log.c"
    "crypto/ct/ct_oct.c"
    "crypto/ct/ct_policy.c"
    "crypto/ct/ct_prn.c"
    "crypto/ct/ct_sct.c"
    "crypto/ct/ct_sct_ctx.c"
    "crypto/ct/ct_vfy.c"
    "crypto/ct/ct_x509v3.c"
    "crypto/ctype.c"
    "crypto/cversion.c"
    "crypto/der_writer.c"
    "crypto/des/cbc_cksm.c"
    "crypto/des/cbc_enc.c"
    "crypto/des/cfb64ede.c"
    "crypto/des/cfb64enc.c"
    "crypto/des/cfb_enc.c"
    "crypto/des/des_enc.c"
    "crypto/des/ecb3_enc.c"
    "crypto/des/ecb_enc.c"
    "crypto/des/fcrypt.c"
    "crypto/des/fcrypt_b.c"
    "crypto/des/ofb64ede.c"
    "crypto/des/ofb64enc.c"
    "crypto/des/ofb_enc.c"
    "crypto/des/pcbc_enc.c"
    "crypto/des/qud_cksm.c"
    "crypto/des/rand_key.c"
    "crypto/des/set_key.c"
    "crypto/des/str2key.c"
    "crypto/des/xcbc_enc.c"
    "crypto/dh/dh_ameth.c"
    "crypto/dh/dh_asn1.c"
    "crypto/dh/dh_backend.c"
    "crypto/dh/dh_check.c"
    "crypto/dh/dh_depr.c"
    "crypto/dh/dh_err.c"
    "crypto/dh/dh_gen.c"
    "crypto/dh/dh_group_params.c"
    "crypto/dh/dh_kdf.c"
    "crypto/dh/dh_key.c"
    "crypto/dh/dh_lib.c"
    "crypto/dh/dh_meth.c"
    "crypto/dh/dh_pmeth.c"
    "crypto/dh/dh_prn.c"
    "crypto/dh/dh_rfc5114.c"
    "crypto/dsa/dsa_ameth.c"
    "crypto/dsa/dsa_asn1.c"
    "crypto/dsa/dsa_backend.c"
    "crypto/dsa/dsa_check.c"
    "crypto/dsa/dsa_depr.c"
    "crypto/dsa/dsa_err.c"
    "crypto/dsa/dsa_gen.c"
    "crypto/dsa/dsa_key.c"
    "crypto/dsa/dsa_lib.c"
    "crypto/dsa/dsa_meth.c"
    "crypto/dsa/dsa_ossl.c"
    "crypto/dsa/dsa_pmeth.c"
    "crypto/dsa/dsa_prn.c"
    "crypto/dsa/dsa_sign.c"
    "crypto/dsa/dsa_vrf.c"
    "crypto/dso/dso_dl.c"
    "crypto/dso/dso_dlfcn.c"
    "crypto/dso/dso_err.c"
    "crypto/dso/dso_lib.c"
    "crypto/dso/dso_openssl.c"
    "crypto/dso/dso_vms.c"
    "crypto/dso/dso_win32.c"
    "crypto/ebcdic.c"
    "crypto/ec/curve25519.c"
    "crypto/ec/curve448/arch_32/f_impl32.c"
    "crypto/ec/curve448/arch_64/f_impl64.c"
    "crypto/ec/curve448/curve448.c"
    "crypto/ec/curve448/curve448_tables.c"
    "crypto/ec/curve448/eddsa.c"
    "crypto/ec/curve448/f_generic.c"
    "crypto/ec/curve448/scalar.c"
    "crypto/ec/ec2_oct.c"
    "crypto/ec/ec2_smpl.c"
    "crypto/ec/ec_ameth.c"
    "crypto/ec/ec_asn1.c"
    "crypto/ec/ec_backend.c"
    "crypto/ec/ec_check.c"
    "crypto/ec/ec_curve.c"
    "crypto/ec/ec_cvt.c"
    "crypto/ec/ec_deprecated.c"
    "crypto/ec/ec_err.c"
    "crypto/ec/ec_key.c"
    "crypto/ec/ec_kmeth.c"
    "crypto/ec/ec_lib.c"
    "crypto/ec/ec_mult.c"
    "crypto/ec/ec_oct.c"
    "crypto/ec/ec_pmeth.c"
    "crypto/ec/ec_print.c"
    "crypto/ec/ecdh_kdf.c"
    "crypto/ec/ecdh_ossl.c"
    "crypto/ec/ecdsa_ossl.c"
    "crypto/ec/ecdsa_sign.c"
    "crypto/ec/ecdsa_vrf.c"
    "crypto/ec/eck_prn.c"
    "crypto/ec/ecp_mont.c"
    "crypto/ec/ecp_nist.c"
    "crypto/ec/ecp_nistz256.c"
    "crypto/ec/ecp_oct.c"
    "crypto/ec/ecp_smpl.c"
    "crypto/ec/ecx_backend.c"
    "crypto/ec/ecx_key.c"
    "crypto/ec/ecx_meth.c"
    "crypto/encode_decode/decoder_err.c"
    "crypto/encode_decode/decoder_lib.c"
    "crypto/encode_decode/decoder_meth.c"
    "crypto/encode_decode/decoder_pkey.c"
    "crypto/encode_decode/encoder_err.c"
    "crypto/encode_decode/encoder_lib.c"
    "crypto/encode_decode/encoder_meth.c"
    "crypto/encode_decode/encoder_pkey.c"
    "crypto/engine/eng_all.c"
    "crypto/engine/eng_cnf.c"
    "crypto/engine/eng_ctrl.c"
    "crypto/engine/eng_dyn.c"
    "crypto/engine/eng_err.c"
    "crypto/engine/eng_fat.c"
    "crypto/engine/eng_init.c"
    "crypto/engine/eng_lib.c"
    "crypto/engine/eng_list.c"
    "crypto/engine/eng_openssl.c"
    "crypto/engine/eng_pkey.c"
    "crypto/engine/eng_rdrand.c"
    "crypto/engine/eng_table.c"
    "crypto/engine/tb_asnmth.c"
    "crypto/engine/tb_cipher.c"
    "crypto/engine/tb_dh.c"
    "crypto/engine/tb_digest.c"
    "crypto/engine/tb_dsa.c"
    "crypto/engine/tb_eckey.c"
    "crypto/engine/tb_pkmeth.c"
    "crypto/engine/tb_rand.c"
    "crypto/engine/tb_rsa.c"
    "crypto/err/err.c"
    "crypto/err/err_all.c"
    "crypto/err/err_all_legacy.c"
    "crypto/err/err_blocks.c"
    "crypto/err/err_prn.c"
    "crypto/ess/ess_asn1.c"
    "crypto/ess/ess_err.c"
    "crypto/ess/ess_lib.c"
    "crypto/evp/asymcipher.c"
    "crypto/evp/bio_b64.c"
    "crypto/evp/bio_enc.c"
    "crypto/evp/bio_md.c"
    "crypto/evp/bio_ok.c"
    "crypto/evp/c_allc.c"
    "crypto/evp/c_alld.c"
    "crypto/evp/cmeth_lib.c"
    "crypto/evp/ctrl_params_translate.c"
    "crypto/evp/dh_ctrl.c"
    "crypto/evp/dh_support.c"
    "crypto/evp/digest.c"
    "crypto/evp/dsa_ctrl.c"
    "crypto/evp/e_aes.c"
    "crypto/evp/e_aes_cbc_hmac_sha1.c"
    "crypto/evp/e_aes_cbc_hmac_sha256.c"
    "crypto/evp/e_aria.c"
    "crypto/evp/e_bf.c"
    "crypto/evp/e_camellia.c"
    "crypto/evp/e_cast.c"
    "crypto/evp/e_chacha20_poly1305.c"
    "crypto/evp/e_des.c"
    "crypto/evp/e_des3.c"
    "crypto/evp/e_idea.c"
    "crypto/evp/e_null.c"
    "crypto/evp/e_old.c"
    "crypto/evp/e_rc2.c"
    "crypto/evp/e_rc4.c"
    "crypto/evp/e_rc4_hmac_md5.c"
    "crypto/evp/e_rc5.c"
    "crypto/evp/e_seed.c"
    "crypto/evp/e_sm4.c"
    "crypto/evp/e_xcbc_d.c"
    "crypto/evp/ec_ctrl.c"
    "crypto/evp/ec_support.c"
    "crypto/evp/encode.c"
    "crypto/evp/evp_cnf.c"
    "crypto/evp/evp_enc.c"
    "crypto/evp/evp_err.c"
    "crypto/evp/evp_fetch.c"
    "crypto/evp/evp_key.c"
    "crypto/evp/evp_lib.c"
    "crypto/evp/evp_pbe.c"
    "crypto/evp/evp_pkey.c"
    "crypto/evp/evp_rand.c"
    "crypto/evp/evp_utils.c"
    "crypto/evp/exchange.c"
    "crypto/evp/kdf_lib.c"
    "crypto/evp/kdf_meth.c"
    "crypto/evp/kem.c"
    "crypto/evp/keymgmt_lib.c"
    "crypto/evp/keymgmt_meth.c"
    "crypto/evp/legacy_blake2.c"
    "crypto/evp/legacy_md4.c"
    "crypto/evp/legacy_md5.c"
    "crypto/evp/legacy_md5_sha1.c"
    "crypto/evp/legacy_mdc2.c"
    "crypto/evp/legacy_ripemd.c"
    "crypto/evp/legacy_sha.c"
    "crypto/evp/legacy_wp.c"
    "crypto/evp/m_null.c"
    "crypto/evp/m_sigver.c"
    "crypto/evp/mac_lib.c"
    "crypto/evp/mac_meth.c"
    "crypto/evp/names.c"
    "crypto/evp/p5_crpt.c"
    "crypto/evp/p5_crpt2.c"
    "crypto/evp/p_dec.c"
    "crypto/evp/p_enc.c"
    "crypto/evp/p_legacy.c"
    "crypto/evp/p_lib.c"
    "crypto/evp/p_open.c"
    "crypto/evp/p_seal.c"
    "crypto/evp/p_sign.c"
    "crypto/evp/p_verify.c"
    "crypto/evp/pbe_scrypt.c"
    "crypto/evp/pmeth_check.c"
    "crypto/evp/pmeth_gn.c"
    "crypto/evp/pmeth_lib.c"
    "crypto/evp/signature.c"
    "crypto/ex_data.c"
    "crypto/ffc/ffc_backend.c"
    "crypto/ffc/ffc_dh.c"
    "crypto/ffc/ffc_key_generate.c"
    "crypto/ffc/ffc_key_validate.c"
    "crypto/ffc/ffc_params.c"
    "crypto/ffc/ffc_params_generate.c"
    "crypto/ffc/ffc_params_validate.c"
    "crypto/getenv.c"
    "crypto/hmac/hmac.c"
    "crypto/http/http_client.c"
    "crypto/http/http_err.c"
    "crypto/http/http_lib.c"
    "crypto/idea/i_cbc.c"
    "crypto/idea/i_cfb64.c"
    "crypto/idea/i_ecb.c"
    "crypto/idea/i_ofb64.c"
    "crypto/idea/i_skey.c"
    "crypto/info.c"
    "crypto/init.c"
    "crypto/initthread.c"
    "crypto/kdf/kdf_err.c"
    "crypto/lhash/lh_stats.c"
    "crypto/lhash/lhash.c"
    "crypto/md4/md4_dgst.c"
    "crypto/md4/md4_one.c"
    "crypto/md5/md5_dgst.c"
    "crypto/md5/md5_one.c"
    "crypto/md5/md5_sha1.c"
    "crypto/mdc2/mdc2_one.c"
    "crypto/mdc2/mdc2dgst.c"
    "crypto/mem.c"
    "crypto/mem_sec.c"
    "crypto/modes/cbc128.c"
    "crypto/modes/ccm128.c"
    "crypto/modes/cfb128.c"
    "crypto/modes/ctr128.c"
    "crypto/modes/cts128.c"
    "crypto/modes/gcm128.c"
    "crypto/modes/ocb128.c"
    "crypto/modes/ofb128.c"
    "crypto/modes/siv128.c"
    "crypto/modes/wrap128.c"
    "crypto/modes/xts128.c"
    "crypto/o_dir.c"
    "crypto/o_fopen.c"
    "crypto/o_init.c"
    "crypto/o_str.c"
    "crypto/o_time.c"
    "crypto/objects/o_names.c"
    "crypto/objects/obj_dat.c"
    "crypto/objects/obj_err.c"
    "crypto/objects/obj_lib.c"
    "crypto/objects/obj_xref.c"
    "crypto/ocsp/ocsp_asn.c"
    "crypto/ocsp/ocsp_cl.c"
    "crypto/ocsp/ocsp_err.c"
    "crypto/ocsp/ocsp_ext.c"
    "crypto/ocsp/ocsp_http.c"
    "crypto/ocsp/ocsp_lib.c"
    "crypto/ocsp/ocsp_prn.c"
    "crypto/ocsp/ocsp_srv.c"
    "crypto/ocsp/ocsp_vfy.c"
    "crypto/ocsp/v3_ocsp.c"
    "crypto/packet.c"
    "crypto/param_build.c"
    "crypto/param_build_set.c"
    "crypto/params.c"
    "crypto/params_dup.c"
    "crypto/params_from_text.c"
    "crypto/passphrase.c"
    "crypto/pem/pem_all.c"
    "crypto/pem/pem_err.c"
    "crypto/pem/pem_info.c"
    "crypto/pem/pem_lib.c"
    "crypto/pem/pem_oth.c"
    "crypto/pem/pem_pk8.c"
    "crypto/pem/pem_pkey.c"
    "crypto/pem/pem_sign.c"
    "crypto/pem/pem_x509.c"
    "crypto/pem/pem_xaux.c"
    "crypto/pem/pvkfmt.c"
    "crypto/pkcs12/p12_add.c"
    "crypto/pkcs12/p12_asn.c"
    "crypto/pkcs12/p12_attr.c"
    "crypto/pkcs12/p12_crpt.c"
    "crypto/pkcs12/p12_crt.c"
    "crypto/pkcs12/p12_decr.c"
    "crypto/pkcs12/p12_init.c"
    "crypto/pkcs12/p12_key.c"
    "crypto/pkcs12/p12_kiss.c"
    "crypto/pkcs12/p12_mutl.c"
    "crypto/pkcs12/p12_npas.c"
    "crypto/pkcs12/p12_p8d.c"
    "crypto/pkcs12/p12_p8e.c"
    "crypto/pkcs12/p12_sbag.c"
    "crypto/pkcs12/p12_utl.c"
    "crypto/pkcs12/pk12err.c"
    "crypto/pkcs7/bio_pk7.c"
    "crypto/pkcs7/pk7_asn1.c"
    "crypto/pkcs7/pk7_attr.c"
    "crypto/pkcs7/pk7_doit.c"
    "crypto/pkcs7/pk7_lib.c"
    "crypto/pkcs7/pk7_mime.c"
    "crypto/pkcs7/pk7_smime.c"
    "crypto/pkcs7/pkcs7err.c"
    "crypto/poly1305/poly1305.c"
    "crypto/property/defn_cache.c"
    "crypto/property/property.c"
    "crypto/property/property_err.c"
    "crypto/property/property_parse.c"
    "crypto/property/property_query.c"
    "crypto/property/property_string.c"
    "crypto/provider.c"
    "crypto/provider_child.c"
    "crypto/provider_conf.c"
    "crypto/provider_core.c"
    "crypto/provider_predefined.c"
    "crypto/punycode.c"
    "crypto/rand/prov_seed.c"
    "crypto/rand/rand_deprecated.c"
    "crypto/rand/rand_err.c"
    "crypto/rand/rand_lib.c"
    "crypto/rand/rand_meth.c"
    "crypto/rand/rand_pool.c"
    "crypto/rand/randfile.c"
    "crypto/rc2/rc2_cbc.c"
    "crypto/rc2/rc2_ecb.c"
    "crypto/rc2/rc2_skey.c"
    "crypto/rc2/rc2cfb64.c"
    "crypto/rc2/rc2ofb64.c"
    "crypto/ripemd/rmd_dgst.c"
    "crypto/ripemd/rmd_one.c"
    "crypto/rsa/rsa_ameth.c"
    "crypto/rsa/rsa_asn1.c"
    "crypto/rsa/rsa_backend.c"
    "crypto/rsa/rsa_chk.c"
    "crypto/rsa/rsa_crpt.c"
    "crypto/rsa/rsa_depr.c"
    "crypto/rsa/rsa_err.c"
    "crypto/rsa/rsa_gen.c"
    "crypto/rsa/rsa_lib.c"
    "crypto/rsa/rsa_meth.c"
    "crypto/rsa/rsa_mp.c"
    "crypto/rsa/rsa_mp_names.c"
    "crypto/rsa/rsa_none.c"
    "crypto/rsa/rsa_oaep.c"
    "crypto/rsa/rsa_ossl.c"
    "crypto/rsa/rsa_pk1.c"
    "crypto/rsa/rsa_pmeth.c"
    "crypto/rsa/rsa_prn.c"
    "crypto/rsa/rsa_pss.c"
    "crypto/rsa/rsa_saos.c"
    "crypto/rsa/rsa_schemes.c"
    "crypto/rsa/rsa_sign.c"
    "crypto/rsa/rsa_sp800_56b_check.c"
    "crypto/rsa/rsa_sp800_56b_gen.c"
    "crypto/rsa/rsa_x931.c"
    "crypto/rsa/rsa_x931g.c"
    "crypto/seed/seed.c"
    "crypto/seed/seed_cbc.c"
    "crypto/seed/seed_cfb.c"
    "crypto/seed/seed_ecb.c"
    "crypto/seed/seed_ofb.c"
    "crypto/self_test_core.c"
    "crypto/sha/sha1_one.c"
    "crypto/sha/sha1dgst.c"
    "crypto/sha/sha256.c"
    "crypto/sha/sha3.c"
    "crypto/sha/sha512.c"
    "crypto/siphash/siphash.c"
    "crypto/sm2/sm2_crypt.c"
    "crypto/sm2/sm2_err.c"
    "crypto/sm2/sm2_key.c"
    "crypto/sm2/sm2_sign.c"
    "crypto/sm3/legacy_sm3.c"
    "crypto/sm3/sm3.c"
    "crypto/sm4/sm4.c"
    "crypto/sparse_array.c"
    "crypto/srp/srp_lib.c"
    "crypto/srp/srp_vfy.c"
    "crypto/stack/stack.c"
    "crypto/store/store_err.c"
    "crypto/store/store_init.c"
    "crypto/store/store_lib.c"
    "crypto/store/store_meth.c"
    "crypto/store/store_register.c"
    "crypto/store/store_result.c"
    "crypto/store/store_strings.c"
    "crypto/threads_lib.c"
    "crypto/threads_none.c"
    "crypto/threads_pthread.c"
    "crypto/threads_win.c"
    "crypto/trace.c"
    "crypto/ts/ts_asn1.c"
    "crypto/ts/ts_conf.c"
    "crypto/ts/ts_err.c"
    "crypto/ts/ts_lib.c"
    "crypto/ts/ts_req_print.c"
    "crypto/ts/ts_req_utils.c"
    "crypto/ts/ts_rsp_print.c"
    "crypto/ts/ts_rsp_sign.c"
    "crypto/ts/ts_rsp_utils.c"
    "crypto/ts/ts_rsp_verify.c"
    "crypto/ts/ts_verify_ctx.c"
    "crypto/txt_db/txt_db.c"
    "crypto/ui/ui_err.c"
    "crypto/ui/ui_lib.c"
    "crypto/ui/ui_null.c"
    "crypto/ui/ui_openssl.c"
    "crypto/ui/ui_util.c"
    "crypto/uid.c"
    "crypto/whrlpool/wp_dgst.c"
    "crypto/x509/by_dir.c"
    "crypto/x509/by_file.c"
    "crypto/x509/by_store.c"
    "crypto/x509/pcy_cache.c"
    "crypto/x509/pcy_data.c"
    "crypto/x509/pcy_lib.c"
    "crypto/x509/pcy_map.c"
    "crypto/x509/pcy_node.c"
    "crypto/x509/pcy_tree.c"
    "crypto/x509/t_crl.c"
    "crypto/x509/t_req.c"
    "crypto/x509/t_x509.c"
    "crypto/x509/v3_addr.c"
    "crypto/x509/v3_admis.c"
    "crypto/x509/v3_akeya.c"
    "crypto/x509/v3_akid.c"
    "crypto/x509/v3_asid.c"
    "crypto/x509/v3_bcons.c"
    "crypto/x509/v3_bitst.c"
    "crypto/x509/v3_conf.c"
    "crypto/x509/v3_cpols.c"
    "crypto/x509/v3_crld.c"
    "crypto/x509/v3_enum.c"
    "crypto/x509/v3_extku.c"
    "crypto/x509/v3_genn.c"
    "crypto/x509/v3_ia5.c"
    "crypto/x509/v3_info.c"
    "crypto/x509/v3_int.c"
    "crypto/x509/v3_ist.c"
    "crypto/x509/v3_lib.c"
    "crypto/x509/v3_ncons.c"
    "crypto/x509/v3_pci.c"
    "crypto/x509/v3_pcia.c"
    "crypto/x509/v3_pcons.c"
    "crypto/x509/v3_pku.c"
    "crypto/x509/v3_pmaps.c"
    "crypto/x509/v3_prn.c"
    "crypto/x509/v3_purp.c"
    "crypto/x509/v3_san.c"
    "crypto/x509/v3_skid.c"
    "crypto/x509/v3_sxnet.c"
    "crypto/x509/v3_tlsf.c"
    "crypto/x509/v3_utf8.c"
    "crypto/x509/v3_utl.c"
    "crypto/x509/v3err.c"
    "crypto/x509/x509_att.c"
    "crypto/x509/x509_cmp.c"
    "crypto/x509/x509_d2.c"
    "crypto/x509/x509_def.c"
    "crypto/x509/x509_err.c"
    "crypto/x509/x509_ext.c"
    "crypto/x509/x509_lu.c"
    "crypto/x509/x509_meth.c"
    "crypto/x509/x509_obj.c"
    "crypto/x509/x509_r2x.c"
    "crypto/x509/x509_req.c"
    "crypto/x509/x509_set.c"
    "crypto/x509/x509_trust.c"
    "crypto/x509/x509_txt.c"
    "crypto/x509/x509_v3.c"
    "crypto/x509/x509_vfy.c"
    "crypto/x509/x509_vpm.c"
    "crypto/x509/x509cset.c"
    "crypto/x509/x509name.c"
    "crypto/x509/x509rset.c"
    "crypto/x509/x509spki.c"
    "crypto/x509/x509type.c"
    "crypto/x509/x_all.c"
    "crypto/x509/x_attrib.c"
    "crypto/x509/x_crl.c"
    "crypto/x509/x_exten.c"
    "crypto/x509/x_name.c"
    "crypto/x509/x_pubkey.c"
    "crypto/x509/x_req.c"
    "crypto/x509/x_x509.c"
    "crypto/x509/x_x509a.c"
    "providers/baseprov.c"
    "providers/defltprov.c"
    "providers/nullprov.c"
    "providers/prov_running.c"
  )
  if(build_with_liblegacy)
    list(APPEND sources
      "engines/e_capi.c"
      "engines/e_padlock.c"
      "providers/legacyprov.c"
    )
  endif()
  list(APPEND sources libcommon_common_sources)
  list(APPEND sources libcommon_build_all_generated_selected_platform_sources)
  list(APPEND sources libdefault_common_sources)
  list(APPEND sources libdefault_build_all_generated_selected_platform_sources)
  list(APPEND sources libcrypto_build_all_generated_selected_platform_sources)
  if(build_with_liblegacy)
    list(APPEND sources  liblegacy_sources)
  endif()

  if(openssl_selected_platform == "linux-armv4")
    # 升级修改适配检查点21 libcrypto 不同平台c源码列表
    list(APPEND sources 
      "crypto/aes/aes_cbc.c"
      "crypto/armcap.c"
      "crypto/bn/bn_asm.c"
      "crypto/camellia/camellia.c"
      "crypto/camellia/cmll_cbc.c"
      "crypto/rc4/rc4_enc.c"
      "crypto/rc4/rc4_skey.c"
      "crypto/whrlpool/wp_block.c"
    )
    if(build_with_liblegacy)
    list(APPEND sources "engines/e_afalg.c" )
    endif()
  elseif(openssl_selected_platform == "linux-aarch64")
    # 升级修改适配检查点22 libcrypto 不同平台c源码列表
    list(APPEND sources 
      "crypto/aes/aes_cbc.c"
      "crypto/aes/aes_core.c"
      "crypto/armcap.c"
      "crypto/bn/bn_asm.c"
      "crypto/camellia/camellia.c"
      "crypto/camellia/cmll_cbc.c"
      "crypto/rc4/rc4_enc.c"
      "crypto/rc4/rc4_skey.c"
      "crypto/whrlpool/wp_block.c"
    )
    if(build_with_liblegacy)
    list(APPEND sources  "engines/e_afalg.c" )
    endif()
  elseif(openssl_selected_platform == "darwin64-x86_64-cc")
    # 升级修改适配检查点23 libcrypto 不同平台c源码列表
    list(APPEND sources
      "crypto/bn/asm/x86_64-gcc.c"
      "crypto/bn/rsaz_exp.c"
      "crypto/bn/rsaz_exp_x2.c"
    )
  elseif(openssl_selected_platform == "darwin64-arm64-cc")
    # 升级修改适配检查点24 libcrypto 不同平台c源码列表
    list(APPEND  sources 
      "crypto/aes/aes_cbc.c"
      "crypto/aes/aes_core.c"
      "crypto/armcap.c"
      "crypto/bn/bn_asm.c"
      "crypto/camellia/camellia.c"
      "crypto/camellia/cmll_cbc.c"
      "crypto/rc4/rc4_enc.c"
      "crypto/rc4/rc4_skey.c"
      "crypto/whrlpool/wp_block.c"
    )
  elseif(openssl_selected_platform == "linux-x86_64")
    # 升级修改适配检查点25 libcrypto 不同平台c源码列表
    list(APPEND  sources 
      "crypto/bn/asm/x86_64-gcc.c"
      "crypto/bn/rsaz_exp.c"
      "crypto/bn/rsaz_exp_x2.c"
    )
    if(build_with_liblegacy)
    list(APPEND sources "engines/e_afalg.c" )
    endif()
  elseif(openssl_selected_platform == "mingw64")
    # 升级修改适配检查点26 libcrypto 不同平台c源码列表
    list(APPEND sources 
      "crypto/bn/asm/x86_64-gcc.c"
      "crypto/bn/rsaz_exp.c"
      "crypto/bn/rsaz_exp_x2.c"
    )
  elseif(openssl_selected_platform == "linux64-loongarch64")
  list(APPEND sources 
      "crypto/aes/aes_cbc.c"
      "crypto/aes/aes_core.c"
      "crypto/bn/bn_asm.c"
      "crypto/camellia/camellia.c"
      "crypto/camellia/cmll_cbc.c"
      "crypto/loongarchcap.c"
      "crypto/rc4/rc4_enc.c"
      "crypto/rc4/rc4_skey.c"
      "crypto/whrlpool/wp_block.c"

      # v_check bind_engine multi defined
      "engines/e_afalg.c"

      # ChaCha20_ctr32
      "crypto/chacha/chacha_enc.c"

      # ./crypto/sha/keccak1600.c:1096 SHA3_squeeze func
      "crypto/sha/keccak1600.c"
    )

    list(APPEND sources 
      # ecp_nistz256_xxx func
      "crypto/ec/ecp_nistz256.c"

      # v_check bind_engine multi defined
      "engines/e_capi.c"
    )
  endif()

#   configs ":crypto_config_private" )
#   public_configs ":crypto_config_public" )
#   deps ":openssl_build_all_generated" )
endif()


# if(MINGW || APPLE)
#   ohos_shared_library("libcrypto_restool")
#     sources)
#     configs)
#     deps ":crypto_source" )
#     ifopenssl_selected_platform == "mingw64")
#       sources +( "crypto/dllmain.c" )
#       configs +( ":crypto_config_private" )
#     }
#     ifcompatible_with_legacy_build_system)
#       subsystem_name = "security"
#       part_name = "huks"
#     } else {
#       subsystem_name = "thirdparty"
#       part_name = "openssl"
#     }
#     public_configs ":crypto_config_public" )

# endif()

# ohos_shared_library("libcrypto_shared")
# #   sources
# #   configs
# #   deps
# #     ":crypto_source"
# #     ":openssl.cnf"
#   if(openssl_selected_platform == "mingw64")
#     sources +( "crypto/dllmain.c" )
#     configs +( ":crypto_config_private" )
#   endif()
#   if(current_os == "ios")
#     set(ldflags
#       "-Wl"
#       "-install_name"
#       "@rpath/libcrypto_openssl.framework/libcrypto_openssl"
#     )
#     output_name = "crypto_openssl"
#    else ()
#     output_name = "libcrypto_openssl"
#   endif()
#   if(compatible_with_legacy_build_system)
#     subsystem_name = "security"
#     part_name = "huks"
#   else()
#     subsystem_name = "thirdparty"
#     part_name = "openssl"
#   endif()
#   if(NOT compatible_with_legacy_build_system)
#     List(APPEND innerapi_tags
#       "platformsdk"
#       "chipsetsdk"
#     )
#   elseif()
 
# endif()

if(current_os == "ios")
  ohos_combine_darwin_framework("libcrypto_openssl")
    deps ":libcrypto_shared"
    subsystem_name = "thirdparty"
    part_name = "openssl"

endif()

set(unused_variables)
list(APPEND unused_variables  unused_variables)
list(APPEND unused_variables  crypto_config_common_private_include_dirs)
list(APPEND unused_variables  crypto_config_common_public_include_dirs)
list(APPEND unused_variables  crypto_config_common_cflags)
list(APPEND unused_variables  crypto_config_linux_armv4_cflags)
list(APPEND unused_variables  crypto_config_linux_aarch64_cflags)
list(APPEND unused_variables  crypto_config_darwin64_x86_64_cc_cflags)
list(APPEND unused_variables  crypto_config_darwin64_arm64_cc_cflags)
list(APPEND unused_variables  crypto_config_linux_x86_64_cflags)
list(APPEND unused_variables  crypto_config_mingw64_cflags)
list(APPEND unused_variables  crypto_config_linux_loongarch64_cflags)
list(APPEND unused_variables  libcommon_common_sources)
list(APPEND unused_variables  libdefault_common_sources)
list(APPEND unused_variables  libcrypto_build_all_generated_linux_armv4_sources)
list(APPEND unused_variables  libcrypto_build_all_generated_linux_aarch64_sources)
list(APPEND unused_variables  libcrypto_build_all_generated_darwin64_x86_64_cc_sources)
list(APPEND unused_variables  libcrypto_build_all_generated_darwin64_arm64_cc_sources)
list(APPEND unused_variables  libcrypto_build_all_generated_linux_x86_64_sources)
list(APPEND unused_variables  libcrypto_build_all_generated_mingw64_sources)
list(APPEND unused_variables  libcrypto_build_all_generated_linux_loongarch64_sources)

config("ssl_config_private")
  list(APPEND include_dirs crypto_config_common_private_include_dirs)
  cflags = crypto_config_common_cflags + crypto_config_current_platform_cflags +
           openssl_internal_cflags

config("ssl_config_public")
  include_dirs = crypto_config_common_public_include_dirs

ohos_source_set("ssl_source")
#   if(NOT compatible_with_legacy_build_system)
#     subsystem_name = "thirdparty"
#     part_name = "openssl"
#   endif()

  # 升级修改适配检查点27 libssl 源码列表
  set(sll_sources
    "ssl/bio_ssl.c"
    "ssl/d1_lib.c"
    "ssl/d1_msg.c"
    "ssl/d1_srtp.c"
    "ssl/methods.c"
    "ssl/pqueue.c"
    "ssl/record/dtls1_bitmap.c"
    "ssl/record/rec_layer_d1.c"
    "ssl/record/rec_layer_s3.c"
    "ssl/record/ssl3_buffer.c"
    "ssl/record/ssl3_record.c"
    "ssl/record/ssl3_record_tls13.c"
    "ssl/s3_enc.c"
    "ssl/s3_lib.c"
    "ssl/s3_msg.c"
    "ssl/ssl_asn1.c"
    "ssl/ssl_cert.c"
    "ssl/ssl_ciph.c"
    "ssl/ssl_conf.c"
    "ssl/ssl_err.c"
    "ssl/ssl_err_legacy.c"
    "ssl/ssl_init.c"
    "ssl/ssl_lib.c"
    "ssl/ssl_mcnf.c"
    "ssl/ssl_rsa.c"
    "ssl/ssl_rsa_legacy.c"
    "ssl/ssl_sess.c"
    "ssl/ssl_stat.c"
    "ssl/ssl_txt.c"
    "ssl/ssl_utst.c"
    "ssl/statem/extensions.c"
    "ssl/statem/extensions_clnt.c"
    "ssl/statem/extensions_cust.c"
    "ssl/statem/extensions_srvr.c"
    "ssl/statem/statem.c"
    "ssl/statem/statem_clnt.c"
    "ssl/statem/statem_dtls.c"
    "ssl/statem/statem_lib.c"
    "ssl/statem/statem_srvr.c"
    "ssl/t1_enc.c"
    "ssl/t1_lib.c"
    "ssl/t1_trce.c"
    "ssl/tls13_enc.c"
    "ssl/tls_depr.c"
    "ssl/tls_srp.c"
  )

#   configs ":ssl_config_private" )
#   public_configs ":ssl_config_public" )
#   deps ":openssl_build_all_generated" )

# ohos_static_library("libssl_static")
#   if!compatible_with_legacy_build_system)
#     subsystem_name = "thirdparty"
#     part_name = "openssl"
#   deps ":ssl_source" )
#   public_configs ":ssl_config_public" )
#   complete_static_lib = true



# if(current_os == "ios")
#   ohos_combine_darwin_framework("libssl_openssl")
#     deps ":libssl_shared" )
#     subsystem_name = "thirdparty"
#     part_name = "openssl"
#   }
# }

# ohos_static_library("libapps")
#   # 升级修改适配检查点28 libapps 源码列表
#   sources
#     "apps/lib/app_libctx.c"
#     "apps/lib/app_params.c"
#     "apps/lib/app_provider.c"
#     "apps/lib/app_rand.c"
#     "apps/lib/app_x509.c"
#     "apps/lib/apps.c"
#     "apps/lib/apps_ui.c"
#     "apps/lib/columns.c"
#     "apps/lib/engine.c"
#     "apps/lib/engine_loader.c"
#     "apps/lib/fmt.c"
#     "apps/lib/http_server.c"
#     "apps/lib/names.c"
#     "apps/lib/opt.c"
#     "apps/lib/s_cb.c"
#     "apps/lib/s_socket.c"
#     "apps/lib/tlssrp_depr.c"
#   )
#   ifopenssl_selected_platform == "mingw64")
#     sources +( "apps/lib/win32_init.c" )
#   }
#   if!compatible_with_legacy_build_system)
#     subsystem_name = "thirdparty"
#     part_name = "openssl"
#   }
#   configs ":crypto_config_private" )
# }

# ohos_executable("openssl")
#   # 升级修改适配检查点29 apps/openssl 源码列表
#   sources
#     "${build_all_generated_path}/apps/progs.c"
#     "apps/asn1parse.c"
#     "apps/ca.c"
#     "apps/ciphers.c"
#     "apps/cmp.c"
#     "apps/cms.c"
#     "apps/crl.c"
#     "apps/crl2pkcs7.c"
#     "apps/dgst.c"
#     "apps/dhparam.c"
#     "apps/dsa.c"
#     "apps/dsaparam.c"
#     "apps/ec.c"
#     "apps/ecparam.c"
#     "apps/enc.c"
#     "apps/engine.c"
#     "apps/errstr.c"
#     "apps/fipsinstall.c"
#     "apps/gendsa.c"
#     "apps/genpkey.c"
#     "apps/genrsa.c"
#     "apps/info.c"
#     "apps/kdf.c"
#     "apps/lib/cmp_mock_srv.c"
#     "apps/list.c"
#     "apps/mac.c"
#     "apps/nseq.c"
#     "apps/ocsp.c"
#     "apps/openssl.c"
#     "apps/passwd.c"
#     "apps/pkcs12.c"
#     "apps/pkcs7.c"
#     "apps/pkcs8.c"
#     "apps/pkey.c"
#     "apps/pkeyparam.c"
#     "apps/pkeyutl.c"
#     "apps/prime.c"
#     "apps/rand.c"
#     "apps/rehash.c"
#     "apps/req.c"
#     "apps/rsa.c"
#     "apps/rsautl.c"
#     "apps/s_client.c"
#     "apps/s_server.c"
#     "apps/s_time.c"
#     "apps/sess_id.c"
#     "apps/smime.c"
#     "apps/speed.c"
#     "apps/spkac.c"
#     "apps/srp.c"
#     "apps/storeutl.c"
#     "apps/ts.c"
#     "apps/verify.c"
#     "apps/version.c"
#     "apps/x509.c"
#   )
#   ifopenssl_selected_platform == "mingw64")
#     sources +( "${build_all_generated_path}/apps/openssl.rc" )
#   }
#   deps
#     ":libapps"
#     ":set(libcrypto_shared"
#     ":libssl_shared"
#     ":openssl.cnf"
#     ":openssl_build_all_generated"
#   )
#   ifcompatible_with_legacy_build_system)
#     subsystem_name = "security"
#     part_name = "huks"
#   } else {
#     subsystem_name = "thirdparty"
#     part_name = "openssl"
#   }
#   configs ":crypto_config_private" )
# }
# 升级修改适配检查点 汇总
#
# libcommon =
#     libcommon 生成的源码列表(7) +
#     libcommon 原目录源码列表(17)
#
# libdefault =
#     libdefault 生成的源码列表(8) +
#     libdefault 原目录源码列表(18)
#
# liblegacy =
#     liblegacy 源码列表(19)
#
# libcrypto =
#     libcrypto 不同平台汇编代码(123456) +
#     libcrypto 不同平台c源码列表(212223242526) +
#     libcrypto 原目录源码列表(20) +
#     libcommon +
#     libdefault +
#     liblegacy
#
# libssl =
#     libssl 源码列表(27)
#
# libapps =
#     libapps 源码列表(28)
#
# apps/openssl =
#     apps/openssl 源码列表(29) +
#     libapps
#
# 编译选项 =
#     内部公共头文件目录列表(9) +
#     内部公共编译选项宏列表(10) +
#     内部不同平台编译选项列表(111213141516)
