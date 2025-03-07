cmake_minimum_required(VERSION 3.9)

project(libuv LANGUAGES C)


include_directories(source/include source/src source/src/unix)

set(common_source 
  "source/src/fs-poll.c"
  "source/src/idna.c"
  "source/src/inet.c"
  "source/src/random.c"
  "source/src/strscpy.c"
  "source/src/threadpool.c"
  "source/src/thread-common.c"
  "source/src/timer.c"
  "source/src/uv-common.c"
  "source/src/uv-data-getter-setters.c"
  "source/src/version.c"
  "source/src/strtok.c"
)
message(common_source ${common_source}
)
set(defines "" "-D_GNU_SOURCE")
set(libs )
set(cflags "-Wno-unused-parameter" )
if(NOT MINGW)
  set(nonwin_srcs 
    "source/src/unix/async.c"
    "source/src/unix/core.c"
    "source/src/unix/dl.c"
    "source/src/unix/fs.c"
    "source/src/unix/getaddrinfo.c"
    "source/src/unix/getnameinfo.c"
    "source/src/unix/loop.c"
    "source/src/unix/loop-watcher.c"
    "source/src/unix/pipe.c"
    "source/src/unix/poll.c"
    "source/src/unix/process.c"
    "source/src/unix/random-devurandom.c"
    "source/src/unix/signal.c"
    "source/src/unix/stream.c"
    "source/src/unix/tcp.c"
    "source/src/unix/thread.c"
    "source/src/unix/tty.c"
    "source/src/unix/udp.c"
  )
endif()
if(OHOS OR LINUX)
  list(APPEND cflags 
    "-Wno-incompatible-pointer-types"
    "-D_GNU_SOURCE"
    "-D_POSIX_C_SOURCE=200112"
  )
  if(OHOS)
    list(APPEND defines  
    "-DUSE_FFRT" 
    "-DASYNC_STACKTRACE" 
    "-DUV_STATISTIC" 
    )
    list(APPEND cflags 
      "-Wno-frame-address"  # for use of __builtin_return_address
    )
    # if (use_ohos_dfx && is_ohos && !is_emulator) {
    #   defines += [ "USE_OHOS_DFX" ]
    # }
  endif()
elseif(MINGW OR MSVC)
  list(APPEND cflags 
  "-Wno-missing-braces"
  "-Wno-implicit-function-declaration"
  "-Wno-error=return-type"
  "-Wno-error=sign-compare"
  "-Wno-error=unused-variable"
  "-Wno-error=unknown-pragmas"
  "-Wno-unused-variable"
  )
  list(APPEND defines  
  "-DWIN32_LEAN_AND_MEAN"
  "-D_WIN32_WINNT=0x0600"
  "-D_CRT_DECLARE_NONSTDC_NAMES=0"
  )
  list(APPEND libs 
  "psapi"
  "user32"
  "advapi32"
  "iphlpapi"
  "userenv"
  "ws2_32"
  "dbghelp"
  "ole32"
  "shell32"
  libwinpthread.a 
  libgcc_s.a
  libstdc++.a
  )
else()
list(APPEND cflags 
"-D_GNU_SOURCE"
"-D_POSIX_C_SOURCE=200112"
)
endif()

if(APPLE)
  list(APPEND common_source
  "source/src/unix/bsd-ifaddrs.c"
  "source/src/unix/darwin-proctitle.c"
  "source/src/unix/darwin.c"
  "source/src/unix/fsevents.c"
  "source/src/unix/kqueue.c"
  "source/src/unix/log_unix.c"
  "source/src/unix/os390-proctitle.c"
  "source/src/unix/random-getentropy.c"
  "source/src/unix/trace_unix.c"
  )
elseif(MINGW OR MSVC)
  list(APPEND common_source
  
  "source/src/win/async.c"
  "source/src/win/core.c"
  "source/src/win/detect-wakeup.c"
  "source/src/win/dl.c"
  "source/src/win/error.c"
  "source/src/win/fs-event.c"
  "source/src/win/fs.c"
  "source/src/win/getaddrinfo.c"
  "source/src/win/getnameinfo.c"
  "source/src/win/handle.c"
  "source/src/win/log_win.c"
  "source/src/win/loop-watcher.c"
  "source/src/win/pipe.c"
  "source/src/win/poll.c"
  "source/src/win/process-stdio.c"
  "source/src/win/process.c"
  "source/src/win/signal.c"
  "source/src/win/snprintf.c"
  "source/src/win/stream.c"
  "source/src/win/tcp.c"
  "source/src/win/thread.c"
  "source/src/win/trace_win.c"
  "source/src/win/tty.c"
  "source/src/win/udp.c"
  "source/src/win/util.c"
  "source/src/win/winapi.c"
  "source/src/win/winsock.c"
  )
elseif(OHOS OR ANDROID)
  list(APPEND common_source
  ${nonwin_srcs}
  "source/src/unix/linux.c"
  "source/src/unix/procfs-exepath.c"
  "source/src/unix/proctitle.c"
  "source/src/unix/random-getentropy.c"
  "source/src/unix/random-getrandom.c"
  "source/src/unix/random-sysctl-linux.c"
  )
  if(OHOS)
    list(APPEND common_source 
        "src/unix/ohos/trace_ohos.c"
    )
  endif()
  if(ANDROID)
    list(APPEND common_source 
      "source/src/win/log_win.c"
      "source/src/win/trace_win.c"
    )
  endif()

endif()
set(uv_defines)
if(CMAKE_SYSTEM_NAME STREQUAL "Android")
  list(APPEND uv_libraries dl)
endif()

message(source3: ${ANDROID} ${common_source})
add_definitions(${defines} )

add_library(uv STATIC ${common_source})
target_link_libraries(uv PRIVATE ${LD_FLAGS} ${libs} ${uv_libraries} )

