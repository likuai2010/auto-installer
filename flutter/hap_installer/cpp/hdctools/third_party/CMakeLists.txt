cmake_minimum_required(VERSION 3.9)

project(libuv LANGUAGES C)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")


set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_C_STANDARD 90)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include_directories(include src src/unix)

set(common_source 
  "src/fs-poll.c"
  "src/idna.c"
  "src/inet.c"
  "src/random.c"
  "src/strscpy.c"
  "src/threadpool.c"
  "src/thread-common.c"
  "src/timer.c"
  "src/uv-common.c"
  "src/uv-data-getter-setters.c"
  "src/version.c"
  "src/strtok.c"
)

if(!MINGW )
  set(nonwin_srcs 
    "src/unix/async.c"
    "src/unix/core.c"
    "src/unix/dl.c"
    "src/unix/fs.c"
    "src/unix/getaddrinfo.c"
    "src/unix/getnameinfo.c"
    "src/unix/loop.c"
    "src/unix/loop-watcher.c"
    "src/unix/pipe.c"
    "src/unix/poll.c"
    "src/unix/process.c"
    "src/unix/random-devurandom.c"
    "src/unix/signal.c"
    "src/unix/stream.c"
    "src/unix/tcp.c"
    "src/unix/thread.c"
    "src/unix/tty.c"
    "src/unix/udp.c"
  )
set(cflags "-Wno-unused-parameter")
list(defines )
if(OHOS || LINUX)
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
elseif(MINGW || MSVC)
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
  list(libs 
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
endif()

if(APPLE)
  list(APPEND common_source
  "src/unix/bsd-ifaddrs.c"
  "src/unix/darwin-proctitle.c"
  "src/unix/darwin.c"
  "src/unix/fsevents.c"
  "src/unix/kqueue.c"
  "src/unix/log_unix.c"
  "src/unix/os390-proctitle.c"
  "src/unix/random-getentropy.c"
  "src/unix/trace_unix.c"
  )
elseif(MINGW || MSVC)
  list(APPEND common_source
  "src/win/async.c"
  "src/win/core.c"
  "src/win/detect-wakeup.c"
  "src/win/dl.c"
  "src/win/error.c"
  "src/win/fs-event.c"
  "src/win/fs.c"
  "src/win/getaddrinfo.c"
  "src/win/getnameinfo.c"
  "src/win/handle.c"
  "src/win/log_win.c"
  "src/win/loop-watcher.c"
  "src/win/pipe.c"
  "src/win/poll.c"
  "src/win/process-stdio.c"
  "src/win/process.c"
  "src/win/signal.c"
  "src/win/snprintf.c"
  "src/win/stream.c"
  "src/win/tcp.c"
  "src/win/thread.c"
  "src/win/trace_win.c"
  "src/win/tty.c"
  "src/win/udp.c"
  "src/win/util.c"
  "src/win/winapi.c"
  "src/win/winsock.c"
  )
elseif(OHOS || ANDROID)
  list(APPEND common_source
  "src/unix/linux.c"
  "src/unix/procfs-exepath.c"
  "src/unix/proctitle.c"
  "src/unix/random-getentropy.c"
  "src/unix/random-getrandom.c"
  "src/unix/random-sysctl-linux.c"
  )
endif()
endif()
message(1111 ${common_source})
add_library(uv STATIC ${common_source})
target_link_libraries(uv PRIVATE ${LD_FLAGS} pthread dl)

