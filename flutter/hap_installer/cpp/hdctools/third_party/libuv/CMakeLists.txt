cmake_minimum_required(VERSION 3.9)

project(libuv LANGUAGES C)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")


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
set(nonwin_srcs)
if(NOT MINGW)
  list(APPEND nonwin_srcs 
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
set(cflags "-Wno-unused-parameter")
set(defines )
if(OHOS OR LINUX)
  list(APPEND cflags 
    "-Wno-incompatible-pointer-types"
    "-D_GNU_SOURCE"
    "-D_POSIX_C_SOURCE=200112"
  )
  if(OHOS)
    list(APPEND defines  "USE_FFRT" "ASYNC_STACKTRACE" "UV_STATISTIC" )
    list(APPEND cflags 
      "-Wno-frame-address"
    )
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
  "WIN32_LEAN_AND_MEAN"
  "_WIN32_WINNT=0x0600"
  "_CRT_DECLARE_NONSTDC_NAMES=0"
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
  )
elseif(ANDROID)
list(APPEND defines -D_GNU_SOURCE)
endif()

if(APPLE)
  list(APPEND common_source 
  ${nonwin_srcs}
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
    list(APPEND common_source "source/src/unix/ohos/trace_ohos.c" )
    # if (is_ohos && enable_async_stack) {
    #   sources += [ "src/dfx/async_stack/libuv_async_stack.c" ]
    # }
  endif()
  if (ANDROID) 
    list(APPEND common_source "source/src/win/log_win.c"  "source/src/win/trace_win.c" )
  endif()
  
elseif(LINUX)
list(APPEND common_source
  ${nonwin_srcs}
  "source/src/unix/linux.c"
  "source/src/unix/log_unix.c"
  "source/src/unix/procfs-exepath.c"
  "source/src/unix/proctitle.c"
  "source/src/unix/random-getrandom.c"
  "source/src/unix/random-sysctl-linux.c"
  "source/src/unix/trace_unix.c"
)
endif()
message(2222 ${ANDROID} ${LINUX})
add_library(uv STATIC ${common_source})
target_link_libraries(uv PRIVATE ${LD_FLAGS} ${libs})

