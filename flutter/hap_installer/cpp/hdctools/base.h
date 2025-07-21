/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef HDC_BASE_H
#define HDC_BASE_H
#include "common.h"

#ifdef HDC_HILOG
#ifdef LOG_DOMAIN
#undef LOG_DOMAIN
#endif // LOG_DOMAIN

#define LOG_DOMAIN 0xD002D13
#ifdef LOG_TAG
#undef LOG_TAG
#endif // LOG_TAG

#define LOG_TAG "HDC_LOG"

#define HDC_LOG_DEBUG(...) ((void)HILOG_IMPL(LOG_CORE, LogLevel::LOG_DEBUG, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define HDC_LOG_INFO(...) ((void)HILOG_IMPL(LOG_CORE, LogLevel::LOG_INFO, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define HDC_LOG_WARN(...) ((void)HILOG_IMPL(LOG_CORE, LogLevel::LOG_WARN, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define HDC_LOG_ERROR(...) ((void)HILOG_IMPL(LOG_CORE, LogLevel::LOG_ERROR, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))
#define HDC_LOG_FATAL(...) ((void)HILOG_IMPL(LOG_CORE, LogLevel::LOG_FATAL, LOG_DOMAIN, LOG_TAG, __VA_ARGS__))

#endif // HDC_HILOG

namespace Hdc {
namespace Base {
    uint8_t GetLogLevel();
    extern bool g_isBackgroundServer;
    extern uint8_t g_logLevel;
    void SetLogLevel(const uint8_t logLevel);
    void SetTempDir(string tempDir);
    
    uint8_t GetLogLevelByEnv();
    void PrintMessage(const char *fmt, ...);
    void PrintMessageAndWriteLog(const char *fmt, ...);
    // tcpHandle can't be const as it's passed into uv_tcp_keepalive
    void SetTcpOptions(uv_tcp_t *tcpHandle, int bufMaxSize = HDC_SOCKETPAIR_SIZE);
#ifdef HOST_OHOS
    void SetUdsOptions(uv_pipe_t *udsHandle, int bufMaxSize = HDC_SOCKETPAIR_SIZE);
#endif
    // Realloc need to update origBuf&origSize which can't be const
    void ReallocBuf(uint8_t **origBuf, int *nOrigSize, size_t sizeWanted);
    // handle&sendHandle must keep sync with uv_write
    int SendToStreamEx(uv_stream_t *handleStream, const uint8_t *buf, const int bufLen, uv_stream_t *handleSend,
                       const void *finishCallback, const void *pWriteReqData);
    int SendToStream(uv_stream_t *handleStream, const uint8_t *buf, const int bufLen);
    int SendToPollFd(int fd, const uint8_t *buf, const int bufLen);
    // As an uv_write_cb it must keep the same as prototype
    void SendCallback(uv_write_t *req, int status);
    // As an uv_alloc_cb it must keep the same as prototype
    void AllocBufferCallback(uv_handle_t *handle, size_t sizeSuggested, uv_buf_t *buf);
    uint64_t GetRuntimeMSec();
    string GetRandomString(const uint16_t expectedLen);
#ifndef HDC_HOST
    string GetSecureRandomString(const uint16_t expectedLen);
#endif
    int GetRandomNum(const int min, const int max);
    uint32_t GetRandomU32();
    uint64_t GetRandom(const uint64_t min = 0, const uint64_t max = UINT64_MAX);
    uint32_t GetSecureRandom(void);
    int ConnectKey2IPPort(const char *connectKey, char *outIP, uint16_t *outPort, size_t outSize);
    // As an uv_work_cb it must keep the same as prototype
    int StartWorkThread(uv_loop_t *loop, uv_work_cb pFuncWorkThread, uv_after_work_cb pFuncAfterThread,
                        void *pThreadData);
    // As an uv_work_cb it must keep the same as prototype
    void FinishWorkThread(uv_work_t *req, int status);
    int GetMaxBufSize();
    bool TryCloseLoop(uv_loop_t *ptrLoop, const char *callerName);
    bool TryCloseChildLoop(uv_loop_t *ptrLoop, const char *callerName);
    void TryCloseHandle(const uv_handle_t *handle);
    void TryCloseHandle(const uv_handle_t *handle, uv_close_cb closeCallBack);
    void TryCloseHandle(const uv_handle_t *handle, bool alwaysCallback, uv_close_cb closeCallBack);
    void DispUvStreamInfo(const uv_stream_t *handle, const char *prefix);
    char **SplitCommandToArgs(const char *cmdStringLine, int *slotIndex);
    bool RunPipeComand(const char *cmdString, char *outBuf, uint16_t sizeOutBuf, bool ignoreTailLf);
    // results need to save in buf which can't be const
    int ReadBinFile(const char *pathName, void **buf, const size_t bufLen);
    int WriteBinFile(const char *pathName, const uint8_t *buf, const size_t bufLen, bool newFile = false);
    void CloseIdleCallback(uv_handle_t *handle);
    void CloseTimerCallback(uv_handle_t *handle);
    int ProgramMutex(const char *procname, bool checkOrNew);
    // result needs to save results which can't be const
    void SplitString(const string &origString, const string &seq, vector<string> &resultStrings);
    string GetShellPath();
    uint64_t HostToNet(uint64_t val);
    uint64_t NetToHost(uint64_t val);
    string GetFullFilePath(string &s);
    string GetPathWithoutFilename(const string &s);
    int CreateSocketPair(int *fds);
    void CloseSocketPair(int *fds);
    int StringEndsWith(string s, string sub);
    void BuildErrorString(const char *localPath, const char *op, const char *err, string &str);
    const char *GetFileType(mode_t mode);
    bool CheckDirectoryOrPath(const char *localPath, bool pathOrDir, bool readWrite, string &errStr, mode_t &fm);
    bool CheckDirectoryOrPath(const char *localPath, bool pathOrDir, bool readWrite);
    int Base64EncodeBuf(const uint8_t *input, const int length, uint8_t *bufOut);
    vector<uint8_t> Base64Encode(const uint8_t *input, const int length);
    int Base64DecodeBuf(const uint8_t *input, const int length, uint8_t *bufOut);
    string Base64Decode(const uint8_t *input, const int length);
    string UnicodeToUtf8(const char *src, bool reverse = false);
    void ReverseBytes(void *start, int size);
    string Convert2HexStr(uint8_t arr[], int length);
    string CanonicalizeSpecPath(string &src);
    bool TryCreateDirectory(const string &path, string &err);
    // Just zero a POD type, such as a structure or union
    // If it contains c++ struct such as stl-string or others, please use 'T = {}' to initialize struct
    template<class T> int ZeroStruct(T &structBuf)
    {
        return memset_s(&structBuf, sizeof(T), 0, sizeof(T));
    }
    // just zero a statically allocated array of POD or built-in types
    template<class T, size_t N> int ZeroArray(T (&arrayBuf)[N])
    {
        return memset_s(arrayBuf, sizeof(T) * N, 0, sizeof(T) * N);
    }
    // just zero memory buf, such as pointer
    template<class T> int ZeroBuf(T &arrayBuf, int size)
    {
        return memset_s(arrayBuf, size, 0, size);
    }
    // clang-format off
    const string StringFormat(const char * const formater, ...);
    const string StringFormat(const char * const formater, va_list &vaArgs);
    // clang-format on
    string GetVersion();
    bool IdleUvTask(uv_loop_t *loop, void *data, uv_idle_cb cb);
    bool TimerUvTask(uv_loop_t *loop, void *data, uv_timer_cb cb, int repeatTimeout = UV_DEFAULT_INTERVAL);
    bool DelayDo(uv_loop_t *loop, const int delayMs, const uint8_t flag, string msg, void *data,
                 std::function<void(const uint8_t, string &, const void *)> cb);
    inline bool DelayDoSimple(uv_loop_t *loop, const int delayMs,
                              std::function<void(const uint8_t, string &, const void *)> cb)
    {
        return DelayDo(loop, delayMs, 0, "", nullptr, cb);
    }
    inline bool DoNextLoop(uv_loop_t *loop, void *data, std::function<void(const uint8_t, string &, const void *)> cb)
    {
        return DelayDo(loop, 0, 0, "", data, cb);
    }

    // Trim from right side
    inline string &RightTrim(string &s, const string &w = WHITE_SPACES)
    {
        s.erase(s.find_last_not_of(w) + 1);
        return s;
    }

    // Trim from left side
    inline string &LeftTrim(string &s, const string &w = WHITE_SPACES)
    {
        s.erase(0, s.find_first_not_of(w));
        return s;
    }

    // Trim from both sides
    inline string &Trim(string &s, const string &w = WHITE_SPACES)
    {
        return LeftTrim(RightTrim(s, w), w);
    }

    inline bool IsDigitString(const std::string& str)
    {
        return std::all_of(str.begin(), str.end(), ::isdigit);
    }

    bool IsValidIpv4(const std::string& ip);

    // Trim from both sides and paired
    string &ShellCmdTrim(string &cmd);

    string ReplaceAll(string str, const string from, const string to);
    uint8_t CalcCheckSum(const uint8_t *data, int len);
    string GetFileNameAny(string &path);
    string GetCwd();
    string GetTmpDir();
    inline string GetTarToolName()
    {
        return LOG_COMPRESS_TOOL_NAME;
    }
    inline string GetTarParams()
    {
        return LOG_COMPRESS_TOOL_PARAMS;
    }
    void GetTimeString(string& timeString);
#ifndef HDC_HILOG
    void SetLogCache(bool enable);
    void RemoveLogFile();
    void RemoveLogCache();
    void RollLogFile(const char *path);
    void ChmodLogFile();
    bool CreateLogDir();
    bool CompressLogFile(string fileName);
    void CompressLogFiles();
    void RemoveOlderLogFiles();
    vector<string> GetDirFileName();
    string GetCompressLogFileName(string fileName);
    uint32_t GetLogOverCount(vector<string> files, uint64_t limitDirSize);
    string GetLogDirName();
    string GetLogNameWithTime();
    inline string GetTarBinFile()
    {
#ifdef _WIN32
        return LOG_COMPRESS_TOOL_BIN_WIN32;
#else
        return LOG_COMPRESS_TOOL_BIN_UNIX;
#endif
    }
#endif
    uv_os_sock_t DuplicateUvSocket(uv_tcp_t *tcp);
#ifdef HOST_OHOS
    uv_os_sock_t DuplicateUvPipe(uv_pipe_t *pipe);
#endif
    bool IsRoot();
    char GetPathSep();
    string GetHdcAbsolutePath();
    bool IsAbsolutePath(string &path);
    inline int GetMaxBufSize()
    {
        return MAX_SIZE_IOBUF;
    }
    inline int GetUsbffsBulkSize()
    {
        return MAX_USBFFS_BULK;
    }
    inline int GetMaxBufSizeStable()
    {
        return MAX_SIZE_IOBUF_STABLE;
    }
    inline int GetUsbffsBulkSizeStable()
    {
        return MAX_USBFFS_BULK_STABLE;
    }

    int CloseFd(int &fd);
    void InitProcess(void);
    void DeInitProcess(void);
#ifdef HDC_SUPPORT_FLASHD
    // deprecated, remove later
    inline bool SetHdcProperty(const char *key, const char *value)
    {
        return false;
    }
    // deprecated, remove later
    inline bool GetHdcProperty(const char *key, char *value, uint16_t sizeOutBuf)
    {
        return false;
    }
#endif

    int ReadFromFd(int fd, void *buf, size_t count);
    int WriteToFd(int fd, const void *buf, size_t count);

    #define DAEOMN_AUTH_SUCCESS "SUCCESS"
    #define DAEOMN_UNAUTHORIZED "DAEMON_UNAUTH"

    #define TLV_TAG_LEN 16
    #define TLV_VAL_LEN 16
    #define TLV_MIN_LEN (TLV_TAG_LEN + TLV_VAL_LEN)
    #define TAG_DEVNAME "devname"
    #define TAG_HOSTNAME "hostname"
    #define TAG_PUBKEY "pubkey"
    #define TAG_EMGMSG "emgmsg"
    #define TAG_TOKEN "token"
    #define TAG_DAEOMN_AUTHSTATUS "daemonauthstatus"
    #define TAG_AUTH_TYPE "authtype"
    #define TAG_FEATURE_SHELL_OPT "1200" // CMD_UNITY_EXECUTE_EX
    #define TAG_SUPPORT_FEATURE "supportfeatures"
    void TrimSubString(string &str, string substr);
    bool TlvAppend(string &tlv, string tag, string val);
    bool TlvToStringMap(string tlv, std::map<string, string> &tlvmap);
    FILE *Fopen(const char *fileName, const char *mode);
    void AddDeletedSessionId(uint32_t sessionId);
    bool IsSessionDeleted(uint32_t sessionId);
    bool CheckBundleName(const string &bundleName);
    void CloseOpenFd(void);
    const std::set<uint32_t> REGISTERD_TAG_SET = {
        TAG_SHELL_BUNDLE,
        TAG_SHELL_CMD,
    };
    bool CanPrintCmd(const uint16_t command);
    void UpdateEnvCache();
    #define FEATURE_HEARTBEAT "heartbeat"
    #define FEATURE_ENCRYPT_TCP "encrypt_tcp"
    using HdcFeatureSet = std::vector<std::string>;
    const HdcFeatureSet& GetSupportFeature(void);
    std::string FeatureToString(const HdcFeatureSet& feature);
    void StringToFeatureSet(const std::string featureStr, HdcFeatureSet& features);
    bool IsSupportFeature(const HdcFeatureSet& features, std::string feature);
    void UpdateHeartbeatSwitchCache();
    bool GetheartbeatSwitch();
    bool WriteToFile(const std::string& fileName, const std::string &content, std::ios_base::openmode mode);
    void UpdateCmdLogSwitch();
    bool GetCmdLogSwitch();
    std::string CmdLogStringFormat(uint32_t targetSessionId, const std::string& cmdStr);
    void ProcessCmdLogs();
    void UpdateEncrpytTCPCache();
    bool GetEncrpytTCPSwitch();
}  // namespace base
}  // namespace Hdc

#endif  // HDC_BASE_H
