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
#include "server.h"
#include "host_updater.h"


namespace Hdc {
HdcServer::HdcServer(bool serverOrDaemonIn)
    : HdcSessionBase(serverOrDaemonIn)
{
    clsTCPClt = nullptr;
    clsUSBClt = nullptr;
#ifdef HDC_SUPPORT_UART
    clsUARTClt = nullptr;
#endif
    clsServerForClient = nullptr;
    uv_rwlock_init(&daemonAdmin);
    uv_rwlock_init(&forwardAdmin);
}

HdcServer::~HdcServer()
{
    WRITE_LOG(LOG_DEBUG, "~HdcServer");
    uv_rwlock_destroy(&daemonAdmin);
    uv_rwlock_destroy(&forwardAdmin);
}

void HdcServer::ClearInstanceResource()
{
    TryStopInstance();
    Base::TryCloseLoop(&loopMain, "HdcServer::~HdcServer");
    if (clsTCPClt) {
        delete clsTCPClt;
    }
    if (clsUSBClt) {
        delete clsUSBClt;
    }
#ifdef HDC_SUPPORT_UART
    if (clsUARTClt) {
        delete clsUARTClt;
    }
#endif
    if (clsServerForClient) {
        delete (static_cast<HdcServerForClient *>(clsServerForClient));
    }
}

void HdcServer::TryStopInstance()
{
    ClearSessions();
    if (clsTCPClt) {
        clsTCPClt->Stop();
    }
    if (clsUSBClt) {
        clsUSBClt->Stop();
    }
#ifdef HDC_SUPPORT_UART
    if (clsUARTClt) {
        clsUARTClt->Stop();
    }
#endif
    if (clsServerForClient) {
        ((HdcServerForClient *)clsServerForClient)->Stop();
    }
    ReMainLoopForInstanceClear();
    ClearMapDaemonInfo();
}

bool HdcServer::Initial(const char *listenString)
{
    if (Base::ProgramMutex(SERVER_NAME.c_str(), false) != 0) {
        WRITE_LOG(LOG_FATAL, "Other instance already running, program mutex failed");
        return false;
    }
    Base::RemoveLogFile();
    clsServerForClient = new HdcServerForClient(true, listenString, this, &loopMain);
    int rc = (static_cast<HdcServerForClient *>(clsServerForClient))->Initial();
    if (rc != RET_SUCCESS) {
        WRITE_LOG(LOG_FATAL, "clsServerForClient Initial failed");
        return false;
    }
    clsUSBClt->InitLogging(ctxUSB);
    clsTCPClt = new HdcHostTCP(true, this);
    clsUSBClt = new HdcHostUSB(true, this, ctxUSB);
//     if (clsUSBClt->Initial() != RET_SUCCESS) {
//         WRITE_LOG(LOG_FATAL, "clsUSBClt Initial failed");
//         return false;
//     }
    // || !clsUSBClt
    if (!clsServerForClient || !clsTCPClt ) {
        WRITE_LOG(LOG_FATAL, "Class init failed");
        return false;
    }

#ifdef HDC_SUPPORT_UART
    clsUARTClt = new HdcHostUART(*this);
    if (!clsUARTClt) {
        WRITE_LOG(LOG_FATAL, "Class init failed");
        return false;
    }
    if (clsUARTClt->Initial() != RET_SUCCESS) {
        WRITE_LOG(LOG_FATAL, "clsUARTClt Class init failed.");
        return false;
    }
#endif
    return true;
}

bool HdcServer::PullupServerWin32(const char *path, const char *listenString)
{
    bool retVal = false;
#ifdef _WIN32
    char buf[BUF_SIZE_SMALL] = "";
    char shortPath[MAX_PATH] = "";
    std::string strPath = Base::UnicodeToUtf8(path, true);
    int ret = GetShortPathName(strPath.c_str(), shortPath, MAX_PATH);
    std::string runPath = shortPath;
    if (ret == 0) {
        int err = GetLastError();
        constexpr int bufSize = 1024;
        char buffer[bufSize] = { 0 };
        strerror_s(buffer, bufSize, err);
        WRITE_LOG(LOG_WARN, "GetShortPath path:[%s] errmsg:%s", path, buffer);
        string uvPath = path;
        runPath = uvPath.substr(uvPath.find_last_of("/\\") + 1);
    }
    WRITE_LOG(LOG_DEBUG, "server shortpath:[%s] runPath:[%s]", shortPath, runPath.c_str());
    // here we give a dummy option first, because getopt will assume the first option is command. it
    // begin from 2nd args.
    if (sprintf_s(buf, sizeof(buf), "dummy -l %d -s %s -m", Base::GetLogLevelByEnv(), listenString) < 0) {
        return retVal;
    }
    WRITE_LOG(LOG_DEBUG, "Run server in debug-forground, cmd:%s, args:%s", runPath.c_str(), buf);
    STARTUPINFO si = {};
    si.cb = sizeof(STARTUPINFO);
    PROCESS_INFORMATION pi = {};
#ifndef HDC_DEBUG
    si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;
#endif
    if (!CreateProcess(runPath.c_str(), buf, nullptr, nullptr, false, CREATE_NEW_CONSOLE, nullptr, nullptr, &si, &pi)) {
        WRITE_LOG(LOG_WARN, "CreateProcess failed with cmd:%s, args:%s, Error Code %d", runPath.c_str(), buf,
                  GetLastError());
        retVal = false;
    } else {
        retVal = true;
    }
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
#endif
    return retVal;
}

// Only detects that the default call is in the loop address, the other tubes are not
bool HdcServer::PullupServer(const char *listenString)
{
    char path[BUF_SIZE_SMALL] = "";
    size_t nPathSize = sizeof(path);
    int ret = uv_exepath(path, &nPathSize);
    if (ret < 0) {
        constexpr int bufSize = 1024;
        char buf[bufSize] = { 0 };
        uv_err_name_r(ret, buf, bufSize);
        WRITE_LOG(LOG_WARN, "uvexepath ret:%d error:%s", ret, buf);
        return false;
    }
    Base::CreateLogDir();

#ifdef _WIN32
    if (!PullupServerWin32(path, listenString)) {
        return false;
    }
#else
    pid_t pc = fork();  // create process as daemon process
    if (pc < 0) {
        return false;
    } else if (!pc) {
        int i;
        const int maxFD = 1024;
        for (i = 0; i < maxFD; ++i) {
            // close file pipe
            int fd = i;
            Base::CloseFd(fd);
        }
        execl(path, "hdc", "-m", "-s", listenString, nullptr);
        exit(0);
        return true;
    }
    // orig process
#endif
    // wait little time, util backend-server work ready
    uv_sleep(TIME_BASE);
    return true;
}

void HdcServer::ClearMapDaemonInfo()
{
    map<string, HDaemonInfo>::iterator iter;
    uv_rwlock_rdlock(&daemonAdmin);
    for (iter = mapDaemon.begin(); iter != mapDaemon.end();) {
        string sKey = iter->first;
        HDaemonInfo hDi = iter->second;
        delete hDi;
        ++iter;
    }
    uv_rwlock_rdunlock(&daemonAdmin);
    uv_rwlock_wrlock(&daemonAdmin);
    mapDaemon.clear();
    uv_rwlock_wrunlock(&daemonAdmin);
}

void HdcServer::BuildDaemonVisableLine(HDaemonInfo hdi, bool fullDisplay, string &out)
{
    if (fullDisplay) {
        string sConn = conTypeDetail[CONN_UNKNOWN];
        if (hdi->connType < CONN_UNKNOWN) {
            sConn = conTypeDetail[hdi->connType];
        }

        string sStatus = conStatusDetail[STATUS_UNKNOW];
        if (hdi->connStatus < STATUS_UNAUTH) {
            if (hdi->connStatus == STATUS_CONNECTED && hdi->daemonAuthStatus == DAEOMN_UNAUTHORIZED) {
                sStatus = conStatusDetail[STATUS_UNAUTH];
            } else {
                sStatus = conStatusDetail[hdi->connStatus];
            }
        }

        string devname = hdi->devName;
        if (devname.empty()) {
            devname = "unknown...";
        }
        out = Base::StringFormat("%s\t\t%s\t%s\t%s\n", hdi->connectKey.c_str(), sConn.c_str(), sStatus.c_str(),
                                 devname.c_str());
    } else {
        if (hdi->connStatus == STATUS_CONNECTED) {
            out = Base::StringFormat("%s", hdi->connectKey.c_str());
            if (hdi->daemonAuthStatus == DAEOMN_UNAUTHORIZED) {
                out.append("\tUnauthorized");
            }
            out.append("\n");
        }
    }
}

string HdcServer::GetDaemonMapList(uint8_t opType)
{
    string ret;
    bool fullDisplay = false;
    if (opType == OP_GET_STRLIST_FULL) {
        fullDisplay = true;
    }
    uv_rwlock_rdlock(&daemonAdmin);
    map<string, HDaemonInfo>::iterator iter;
    string echoLine;
    for (iter = mapDaemon.begin(); iter != mapDaemon.end(); ++iter) {
        HDaemonInfo di = iter->second;
        if (!di) {
            continue;
        }
        echoLine = "";
        BuildDaemonVisableLine(di, fullDisplay, echoLine);
        ret += echoLine;
    }
    uv_rwlock_rdunlock(&daemonAdmin);
    return ret;
}

void HdcServer::GetDaemonMapOnlyOne(HDaemonInfo &hDaemonInfoInOut)
{
    uv_rwlock_rdlock(&daemonAdmin);
    string key;
    for (auto &i : mapDaemon) {
        if (i.second->connStatus == STATUS_CONNECTED) {
            if (key == STRING_EMPTY) {
                key = i.first;
            } else {
                key = STRING_EMPTY;
                break;
            }
        }
    }
    if (key.size() > 0) {
        hDaemonInfoInOut = mapDaemon[key];
    }
    uv_rwlock_rdunlock(&daemonAdmin);
}

void HdcServer::AdminDaemonMapForWait(const string &connectKey, HDaemonInfo &hDaemonInfoInOut)
{
    map<string, HDaemonInfo>::iterator iter;
    for (iter = mapDaemon.begin(); iter != mapDaemon.end(); ++iter) {
        HDaemonInfo di = iter->second;
        if (di->connStatus == STATUS_CONNECTED) {
            if (!connectKey.empty() && connectKey != di->connectKey) {
                continue;
            }
            hDaemonInfoInOut = di;
            return;
        }
    }
    return;
}

string HdcServer::AdminDaemonMap(uint8_t opType, const string &connectKey, HDaemonInfo &hDaemonInfoInOut)
{
    string sRet;
    switch (opType) {
        case OP_ADD: {
            HDaemonInfo pdiNew = new(std::nothrow) HdcDaemonInformation();
            if (pdiNew == nullptr) {
                WRITE_LOG(LOG_FATAL, "AdminDaemonMap new pdiNew failed");
                break;
            }
            *pdiNew = *hDaemonInfoInOut;
            uv_rwlock_wrlock(&daemonAdmin);
            if (!mapDaemon[hDaemonInfoInOut->connectKey]) {
                mapDaemon[hDaemonInfoInOut->connectKey] = pdiNew;
            }
            uv_rwlock_wrunlock(&daemonAdmin);
            break;
        }
        case OP_GET_STRLIST:
        case OP_GET_STRLIST_FULL: {
            sRet = GetDaemonMapList(opType);
            break;
        }
        case OP_QUERY: {
            uv_rwlock_rdlock(&daemonAdmin);
            if (mapDaemon.count(connectKey)) {
                hDaemonInfoInOut = mapDaemon[connectKey];
            }
            uv_rwlock_rdunlock(&daemonAdmin);
            break;
        }
        case OP_REMOVE: {
            uv_rwlock_wrlock(&daemonAdmin);
            if (mapDaemon.count(connectKey)) {
                mapDaemon.erase(connectKey);
            }
            uv_rwlock_wrunlock(&daemonAdmin);
            break;
        }
        case OP_GET_ANY: {
            uv_rwlock_rdlock(&daemonAdmin);
            map<string, HDaemonInfo>::iterator iter;
            for (iter = mapDaemon.begin(); iter != mapDaemon.end(); ++iter) {
                HDaemonInfo di = iter->second;
                // usb will be auto connected
                if (di->connStatus == STATUS_READY || di->connStatus == STATUS_CONNECTED) {
                    hDaemonInfoInOut = di;
                    break;
                }
            }
            uv_rwlock_rdunlock(&daemonAdmin);
            break;
        }
        case OP_WAIT_FOR_ANY: {
            uv_rwlock_rdlock(&daemonAdmin);
            AdminDaemonMapForWait(connectKey, hDaemonInfoInOut);
            uv_rwlock_rdunlock(&daemonAdmin);
            break;
        }
        case OP_GET_ONLY: {
            GetDaemonMapOnlyOne(hDaemonInfoInOut);
            break;
        }
        case OP_UPDATE: {  // Cannot update the Object HDi lower key value by direct value
            uv_rwlock_wrlock(&daemonAdmin);
            HDaemonInfo hdi = mapDaemon[hDaemonInfoInOut->connectKey];
            if (hdi) {
                *mapDaemon[hDaemonInfoInOut->connectKey] = *hDaemonInfoInOut;
            }
            uv_rwlock_wrunlock(&daemonAdmin);
            break;
        }
        default:
            break;
    }
    return sRet;
}

void HdcServer::NotifyInstanceSessionFree(HSession hSession, bool freeOrClear)
{
    HDaemonInfo hdiOld = nullptr;
    AdminDaemonMap(OP_QUERY, hSession->connectKey, hdiOld);
    if (hdiOld == nullptr) {
        WRITE_LOG(LOG_FATAL, "NotifyInstanceSessionFree hdiOld nullptr");
        return;
    }
    if (!freeOrClear) {  // step1
        // update
        HdcDaemonInformation diNew = *hdiOld;
        diNew.connStatus = STATUS_OFFLINE;
        HDaemonInfo hdiNew = &diNew;
        AdminDaemonMap(OP_UPDATE, hSession->connectKey, hdiNew);
        CleanForwardMap(hSession->sessionId);
    } else {  // step2
        string usbMountPoint = hdiOld->usbMountPoint;
        // The waiting time must be longer than DEVICE_CHECK_INTERVAL. Wait the method WatchUsbNodeChange
        // to finish execution. Otherwise, the main thread and the session worker thread will conflict
        constexpr int waitDaemonReconnect = DEVICE_CHECK_INTERVAL + DEVICE_CHECK_INTERVAL;
        auto funcDelayUsbNotify = [this, usbMountPoint](const uint8_t flag, string &msg, const void *) -> void {
            string s = usbMountPoint;
            clsUSBClt->RemoveIgnoreDevice(s);
        };
        if (usbMountPoint.size() > 0) {
            // wait time for daemon reconnect
            // If removed from maplist, the USB module will be reconnected, so it needs to wait for a while
            Base::DelayDoSimple(&loopMain, waitDaemonReconnect, funcDelayUsbNotify);
        }
    }
}

void HdcServer::GetDaemonAuthType(HSession hSession, SessionHandShake &handshake)
{
    /*
     * check if daemon support RSA_3072_SHA512 for auth
     * it the value is not RSA_3072_SHA512, we use old auth algorithm
     * Notice, If deamon is old version 'handshake.buf' will be 'hSession->tokenRSA',
     * the length of hSession->tokenRSA less than min len(TLV_MIN_LEN), so there no
     * problem
    */
    std::map<string, string> tlvmap;
    hSession->verifyType = AuthVerifyType::RSA_ENCRYPT;
    if (!Base::TlvToStringMap(handshake.buf, tlvmap)) {
        WRITE_LOG(LOG_INFO, "the deamon maybe old version for %u session, so use rsa encrypt", hSession->sessionId);
        return;
    }
    if (tlvmap.find(TAG_AUTH_TYPE) == tlvmap.end() ||
        tlvmap[TAG_AUTH_TYPE] != std::to_string(AuthVerifyType::RSA_3072_SHA512)) {
        WRITE_LOG(LOG_FATAL, "the buf is invalid for %u session, so use rsa encrypt", hSession->sessionId);
        return;
    }
    hSession->verifyType = AuthVerifyType::RSA_3072_SHA512;
    WRITE_LOG(LOG_INFO, "daemon auth type is rsa_3072_sha512 for %u session", hSession->sessionId);
}

bool HdcServer::HandServerAuth(HSession hSession, SessionHandShake &handshake)
{
    string bufString;
    switch (handshake.authType) {
        case AUTH_PUBLICKEY: {
            WRITE_LOG(LOG_INFO, "recive get publickey cmd");
            GetDaemonAuthType(hSession, handshake);
            if (!HdcAuth::GetPublicKeyinfo(handshake.buf)) {
                WRITE_LOG(LOG_FATAL, "load public key failed");
                return false;
            }
            handshake.authType = AUTH_PUBLICKEY;
            bufString = SerialStruct::SerializeToString(handshake);
            Send(hSession->sessionId, 0, CMD_KERNEL_HANDSHAKE,
                 reinterpret_cast<uint8_t *>(const_cast<char *>(bufString.c_str())), bufString.size());

            WRITE_LOG(LOG_INFO, "send pubkey over");
            return true;
        }
        case AUTH_SIGNATURE: {
            WRITE_LOG(LOG_INFO, "recive auth signture cmd");
            if (!HdcAuth::RsaSignAndBase64(handshake.buf, hSession->verifyType)) {
                WRITE_LOG(LOG_FATAL, "sign failed");
                return false;
            }
            handshake.authType = AUTH_SIGNATURE;
            bufString = SerialStruct::SerializeToString(handshake);
            Send(hSession->sessionId, 0, CMD_KERNEL_HANDSHAKE,
                 reinterpret_cast<uint8_t *>(const_cast<char *>(bufString.c_str())), bufString.size());
            WRITE_LOG(LOG_INFO, "response auth signture success");
            return true;
        }
        default:
            WRITE_LOG(LOG_FATAL, "invalid auth type %d", handshake.authType);
            return false;
    }
}

void HdcServer::UpdateHdiInfo(Hdc::HdcSessionBase::SessionHandShake &handshake, const string &connectKey)
{
    HDaemonInfo hdiOld = nullptr;
    AdminDaemonMap(OP_QUERY, connectKey, hdiOld);
    if (!hdiOld) {
        return;
    }
    HdcDaemonInformation diNew = *hdiOld;
    HDaemonInfo hdiNew = &diNew;
    // update
    hdiNew->connStatus = STATUS_CONNECTED;
    WRITE_LOG(LOG_INFO, "handshake info is : %s", handshake.ToDebugString().c_str());
    WRITE_LOG(LOG_INFO, "handshake.buf = %s", handshake.buf.c_str());
    if (handshake.version < "Ver: 3.0.0b") {
        if (!handshake.buf.empty()) {
            hdiNew->devName = handshake.buf;
        }
    } else {
        std::map<string, string> tlvmap;
        if (Base::TlvToStringMap(handshake.buf, tlvmap)) {
            if (tlvmap.find(TAG_DEVNAME) != tlvmap.end()) {
                hdiNew->devName = tlvmap[TAG_DEVNAME];
                WRITE_LOG(LOG_INFO, "devname = %s", hdiNew->devName.c_str());
            }
            if (tlvmap.find(TAG_EMGMSG) != tlvmap.end()) {
                hdiNew->emgmsg = tlvmap[TAG_EMGMSG];
                WRITE_LOG(LOG_INFO, "emgmsg = %s", hdiNew->emgmsg.c_str());
            }
            if (tlvmap.find(TAG_DAEOMN_AUTHSTATUS) != tlvmap.end()) {
                hdiNew->daemonAuthStatus = tlvmap[TAG_DAEOMN_AUTHSTATUS];
                WRITE_LOG(LOG_INFO, "daemonauthstatus = %s", hdiNew->daemonAuthStatus.c_str());
            }
        } else {
            WRITE_LOG(LOG_FATAL, "TlvToStringMap failed");
        }
    }
    hdiNew->version = handshake.version;
    AdminDaemonMap(OP_UPDATE, connectKey, hdiNew);
}

bool HdcServer::ServerSessionHandshake(HSession hSession, uint8_t *payload, int payloadSize)
{
    // session handshake step3
    string s = string(reinterpret_cast<char *>(payload), payloadSize);
    Hdc::HdcSessionBase::SessionHandShake handshake;
    SerialStruct::ParseFromString(handshake, s);
#ifdef HDC_DEBUG
    WRITE_LOG(LOG_DEBUG, "handshake.banner:%s, payload:%s(%d)", handshake.banner.c_str(), s.c_str(), payloadSize);
#endif

    if (handshake.banner == HANDSHAKE_FAILED.c_str()) {
        WRITE_LOG(LOG_FATAL, "Handshake failed");
        return false;
    }

    if (handshake.banner != HANDSHAKE_MESSAGE.c_str()) {
        WRITE_LOG(LOG_DEBUG, "Hello failed");
        return false;
    }
    if (handshake.authType != AUTH_OK) {
        if (!HandServerAuth(hSession, handshake)) {
            WRITE_LOG(LOG_WARN, "Auth failed");
            return false;
        }
        return true;
    }
    // handshake auth OK
    UpdateHdiInfo(handshake, hSession->connectKey);
    hSession->handshakeOK = true;
    return true;
}

// call in child thread
bool HdcServer::FetchCommand(HSession hSession, const uint32_t channelId, const uint16_t command, uint8_t *payload,
                             const int payloadSize)
{
    bool ret = true;
    HdcServerForClient *sfc = static_cast<HdcServerForClient *>(clsServerForClient);
    if (command == CMD_KERNEL_HANDSHAKE) {
        ret = ServerSessionHandshake(hSession, payload, payloadSize);
        WRITE_LOG(LOG_DEBUG, "Session handshake %s connType:%d", ret ? "successful" : "failed",
                  hSession->connType);
        return ret;
    }
    // When you first initialize, ChannelID may be 0
    HChannel hChannel = sfc->AdminChannel(OP_QUERY_REF, channelId, nullptr);
    if (!hChannel) {
        if (command == CMD_KERNEL_CHANNEL_CLOSE) {
            // Daemon close channel and want to notify server close channel also, but it may has been
            // closed by herself
            WRITE_LOG(LOG_WARN, "Die channelId :%lu recv CMD_KERNEL_CHANNEL_CLOSE", channelId);
        } else {
            // Client may be ctrl+c and Server remove channel. notify server async
            WRITE_LOG(LOG_DEBUG, "channelId :%lu die", channelId);
        }
        uint8_t flag = 0;
        Send(hSession->sessionId, channelId, CMD_KERNEL_CHANNEL_CLOSE, &flag, 1);
        return ret;
    }
    if (hChannel->isDead) {
        WRITE_LOG(LOG_FATAL, "FetchCommand channelId:%u isDead", channelId);
        --hChannel->ref;
        return ret;
    }
    switch (command) {
        case CMD_KERNEL_ECHO_RAW: {  // Native shell data output
            sfc->EchoClientRaw(hChannel, payload, payloadSize);
            break;
        }
        case CMD_KERNEL_ECHO: {
            MessageLevel level = static_cast<MessageLevel>(*payload);
            string s(reinterpret_cast<char *>(payload + 1), payloadSize - 1);
            sfc->EchoClient(hChannel, level, s.c_str());
            WRITE_LOG(LOG_INFO, "CMD_KERNEL_ECHO size:%d channelId:%u", payloadSize - 1, channelId);
            break;
        }
        case CMD_KERNEL_CHANNEL_CLOSE: {
            WRITE_LOG(LOG_DEBUG, "CMD_KERNEL_CHANNEL_CLOSE channelid:%u", channelId);
            // Forcibly closing the tcp handle here may result in incomplete data reception on the client side
            ClearOwnTasks(hSession, channelId);
            // crossthread free
            sfc->PushAsyncMessage(channelId, ASYNC_FREE_CHANNEL, nullptr, 0);
            if (*payload != 0) {
                --(*payload);
                Send(hSession->sessionId, channelId, CMD_KERNEL_CHANNEL_CLOSE, payload, 1);
            }
            break;
        }
        case CMD_FORWARD_SUCCESS: {
            // add to local
            HdcForwardInformation di;
            HForwardInfo pdiNew = &di;
            pdiNew->channelId = channelId;
            pdiNew->sessionId = hSession->sessionId;
            pdiNew->connectKey = hSession->connectKey;
            pdiNew->forwardDirection = (reinterpret_cast<char *>(payload))[0] == '1';
            pdiNew->taskString = reinterpret_cast<char *>(payload);
            AdminForwardMap(OP_ADD, STRING_EMPTY, pdiNew);
            Base::TryCloseHandle((uv_handle_t *)&hChannel->hChildWorkTCP);  // detch client channel
            break;
        }
        case CMD_FILE_INIT:
        case CMD_FILE_CHECK:
        case CMD_FILE_BEGIN:
        case CMD_FILE_DATA:
        case CMD_FILE_FINISH:
        case CMD_FILE_MODE:
        case CMD_DIR_MODE:
        case CMD_APP_INIT:
        case CMD_APP_CHECK:
        case CMD_APP_BEGIN:
        case CMD_APP_DATA:
        case CMD_APP_FINISH:
            if (hChannel->fromClient) {
                // server directly passthrough app command to client if remote file mode, else go default
                sfc->SendCommandToClient(hChannel, command, payload, payloadSize);
                break;
            }
        default: {
            HSession hSessionByQuery = AdminSession(OP_QUERY, hChannel->targetSessionId, nullptr);
            if (!hSessionByQuery) {
                ret = false;
                break;
            }
            ret = DispatchTaskData(hSessionByQuery, channelId, command, payload, payloadSize);
            break;
        }
    }
    --hChannel->ref;
    return ret;
}

void HdcServer::BuildForwardVisableLine(bool fullOrSimble, HForwardInfo hfi, string &echo)
{
    string buf;
    if (fullOrSimble) {
        buf = Base::StringFormat("%s    %s    %s\n", hfi->connectKey.c_str(), hfi->taskString.substr(OFFSET).c_str(),
                                 hfi->forwardDirection ? "[Forward]" : "[Reverse]");
    } else {
        buf = Base::StringFormat("%s\n", hfi->taskString.c_str());
    }
    echo += buf;
}

string HdcServer::AdminForwardMap(uint8_t opType, const string &taskString, HForwardInfo &hForwardInfoInOut)
{
    string sRet;
    switch (opType) {
        case OP_ADD: {
            HForwardInfo pfiNew = new(std::nothrow) HdcForwardInformation();
            if (pfiNew == nullptr) {
                WRITE_LOG(LOG_FATAL, "AdminForwardMap new pfiNew failed");
                break;
            }
            *pfiNew = *hForwardInfoInOut;
            uv_rwlock_wrlock(&forwardAdmin);
            if (!mapForward[hForwardInfoInOut->taskString]) {
                mapForward[hForwardInfoInOut->taskString] = pfiNew;
            }
            uv_rwlock_wrunlock(&forwardAdmin);
            break;
        }
        case OP_GET_STRLIST:
        case OP_GET_STRLIST_FULL: {
            uv_rwlock_rdlock(&forwardAdmin);
            map<string, HForwardInfo>::iterator iter;
            for (iter = mapForward.begin(); iter != mapForward.end(); ++iter) {
                HForwardInfo di = iter->second;
                if (!di) {
                    continue;
                }
                BuildForwardVisableLine(opType == OP_GET_STRLIST_FULL, di, sRet);
            }
            uv_rwlock_rdunlock(&forwardAdmin);
            break;
        }
        case OP_QUERY: {
            uv_rwlock_rdlock(&forwardAdmin);
            if (mapForward.count(taskString)) {
                hForwardInfoInOut = mapForward[taskString];
            }
            uv_rwlock_rdunlock(&forwardAdmin);
            break;
        }
        case OP_REMOVE: {
            uv_rwlock_wrlock(&forwardAdmin);
            if (mapForward.count(taskString)) {
                mapForward.erase(taskString);
            }
            uv_rwlock_wrunlock(&forwardAdmin);
            break;
        }
        default:
            break;
    }
    return sRet;
}

void HdcServer::CleanForwardMap(uint32_t sessionId)
{
    uv_rwlock_rdlock(&forwardAdmin);
    map<string, HForwardInfo>::iterator iter;
    for (iter = mapForward.begin(); iter != mapForward.end();) {
        HForwardInfo di = iter->second;
        if (!di) {
            continue;
        }
        if (sessionId == 0 || sessionId == di->sessionId) {
            iter = mapForward.erase(iter);
        } else {
            iter++;
        }
    }
    uv_rwlock_rdunlock(&forwardAdmin);
}

void HdcServer::UsbPreConnect(uv_timer_t *handle)
{
    HSession hSession = (HSession)handle->data;
    bool stopLoop = false;
    HdcServer *hdcServer = (HdcServer *)hSession->classInstance;
    while (true) {
        WRITE_LOG(LOG_DEBUG, "HdcServer::UsbPreConnect");
        HDaemonInfo pDi = nullptr;
        if (hSession->connectKey == "any") {
            hdcServer->AdminDaemonMap(OP_GET_ANY, hSession->connectKey, pDi);
        } else {
            hdcServer->AdminDaemonMap(OP_QUERY, hSession->connectKey, pDi);
        }
        if (!pDi || !pDi->usbMountPoint.size()) {
            break;
        }
        HdcHostUSB *hdcHostUSB = (HdcHostUSB *)hSession->classModule;
        hdcHostUSB->ConnectDetectDaemon(hSession, pDi);
        stopLoop = true;
        break;
    }
    if (stopLoop && !uv_is_closing((const uv_handle_t *)handle)) {
        uv_close((uv_handle_t *)handle, Base::CloseTimerCallback);
    }
}
#ifdef HDC_SUPPORT_UART
void HdcServer::UartPreConnect(uv_timer_t *handle)
{
    WRITE_LOG(LOG_DEBUG, "%s", __FUNCTION__);
    HSession hSession = (HSession)handle->data;
    bool stopLoop = false;
    HdcServer *hdcServer = (HdcServer *)hSession->classInstance;
    const int uartConnectRetryMax = 100; // max 6s
    while (true) {
        if (hSession->hUART->retryCount > uartConnectRetryMax) {
            WRITE_LOG(LOG_DEBUG, "%s failed because max retry limit %d", __FUNCTION__,
                      hSession->hUART->retryCount);
            hdcServer->FreeSession(hSession->sessionId);
            stopLoop = true;
            break;
        }
        hSession->hUART->retryCount++;
        HDaemonInfo pDi = nullptr;

        WRITE_LOG(LOG_DEBUG, "%s query %s", __FUNCTION__, hSession->ToDebugString().c_str());
        hdcServer->AdminDaemonMap(OP_QUERY, hSession->connectKey, pDi);
        if (!pDi) {
            WRITE_LOG(LOG_DEBUG, "%s not found", __FUNCTION__);
            break;
        }
        HdcHostUART *hdcHostUART = (HdcHostUART *)hSession->classModule;
        hdcHostUART->ConnectDaemonByUart(hSession, pDi);
        WRITE_LOG(LOG_DEBUG, "%s ConnectDaemonByUart done", __FUNCTION__);

        stopLoop = true;
        break;
    }
    if (stopLoop) {
        uv_close((uv_handle_t *)handle, Base::CloseTimerCallback);
    }
}

void HdcServer::CreatConnectUart(HSession hSession)
{
    uv_timer_t *waitTimeDoCmd = new(std::nothrow) uv_timer_t;
    if (waitTimeDoCmd == nullptr) {
        WRITE_LOG(LOG_FATAL, "CreatConnectUart new waitTimeDoCmd failed");
        return;
    }
    uv_timer_init(&loopMain, waitTimeDoCmd);
    waitTimeDoCmd->data = hSession;
    uv_timer_start(waitTimeDoCmd, UartPreConnect, UV_TIMEOUT, UV_REPEAT);
}
#endif
// -1,has old,-2 error
int HdcServer::CreateConnect(const string &connectKey, bool isCheck)
{
    uint8_t connType = 0;
    if (connectKey.find(":") != std::string::npos) { // TCP
        connType = CONN_TCP;
    }
#ifdef HDC_SUPPORT_UART
    else if (connectKey.find("COM") == 0 ||
             connectKey.find("/dev/ttyUSB") == 0 ||
             connectKey.find("/dev/cu.") == 0) { // UART
        connType = CONN_SERIAL;
    }
#endif
    else { // Not support
        return ERR_NO_SUPPORT;
    }
    HDaemonInfo hdi = nullptr;
    if (connectKey == "any") {
        return RET_SUCCESS;
    }
    AdminDaemonMap(OP_QUERY, connectKey, hdi);
    if (hdi == nullptr) {
        HdcDaemonInformation di = {};
        di.connectKey = connectKey;
        di.connType = connType;
        di.connStatus = STATUS_UNKNOW;
        HDaemonInfo pDi = reinterpret_cast<HDaemonInfo>(&di);
        AdminDaemonMap(OP_ADD, "", pDi);
        AdminDaemonMap(OP_QUERY, connectKey, hdi);
    }
    if (!hdi || hdi->connStatus == STATUS_CONNECTED) {
        WRITE_LOG(LOG_FATAL, "Connected return");
        return ERR_GENERIC;
    }
    HSession hSession = nullptr;
    if (connType == CONN_TCP) {
        hSession = clsTCPClt->ConnectDaemon(connectKey, isCheck);
    } else if (connType == CONN_SERIAL) {
#ifdef HDC_SUPPORT_UART
        clsUARTClt->SetCheckFlag(isCheck);
        hSession = clsUARTClt->ConnectDaemon(connectKey);
#endif
    } else {
        hSession = MallocSession(true, CONN_USB, clsUSBClt);
        if (!hSession) {
            WRITE_LOG(LOG_FATAL, "CreateConnect malloc usb session failed %s", Hdc::MaskString(connectKey).c_str());
            return ERR_BUF_ALLOC;
        }
        hSession->connectKey = connectKey;
        uv_timer_t *waitTimeDoCmd = new(std::nothrow) uv_timer_t;
        if (waitTimeDoCmd == nullptr) {
            WRITE_LOG(LOG_FATAL, "CreateConnect new waitTimeDoCmd failed");
            FreeSession(hSession->sessionId);
            return ERR_GENERIC;
        }
        uv_timer_init(&loopMain, waitTimeDoCmd);
        waitTimeDoCmd->data = hSession;
        uv_timer_start(waitTimeDoCmd, UsbPreConnect, 500, 500);
    }
    if (!hSession) {
        WRITE_LOG(LOG_FATAL, "CreateConnect hSession nullptr");
        return ERR_BUF_ALLOC;
    }
    HDaemonInfo hdiQuery = nullptr;
    AdminDaemonMap(OP_QUERY, connectKey, hdiQuery);
    if (hdiQuery) {
        HdcDaemonInformation diNew = *hdiQuery;
        diNew.hSession = hSession;
        HDaemonInfo hdiNew = &diNew;
        AdminDaemonMap(OP_UPDATE, hdiQuery->connectKey, hdiNew);
    }
    return RET_SUCCESS;
}

void HdcServer::AttachChannel(HSession hSession, const uint32_t channelId)
{
    int ret = 0;
    HdcServerForClient *hSfc = static_cast<HdcServerForClient *>(clsServerForClient);
    HChannel hChannel = hSfc->AdminChannel(OP_QUERY_REF, channelId, nullptr);
    if (!hChannel) {
        WRITE_LOG(LOG_DEBUG, "AttachChannel hChannel null channelId:%u", channelId);
        return;
    }
    uv_tcp_init(&hSession->childLoop, &hChannel->hChildWorkTCP);
    hChannel->hChildWorkTCP.data = hChannel;
    hChannel->targetSessionId = hSession->sessionId;
    if ((ret = uv_tcp_open((uv_tcp_t *)&hChannel->hChildWorkTCP, hChannel->fdChildWorkTCP)) < 0) {
        constexpr int bufSize = 1024;
        char buf[bufSize] = { 0 };
        uv_err_name_r(ret, buf, bufSize);
        WRITE_LOG(LOG_WARN, "Hdcserver AttachChannel uv_tcp_open failed %s, channelid:%d fdChildWorkTCP:%d",
                  buf, hChannel->channelId, hChannel->fdChildWorkTCP);
        Base::TryCloseHandle((uv_handle_t *)&hChannel->hChildWorkTCP);
        --hChannel->ref;
        return;
    }
    Base::SetTcpOptions((uv_tcp_t *)&hChannel->hChildWorkTCP);
    uv_read_start((uv_stream_t *)&hChannel->hChildWorkTCP, hSfc->AllocCallback, hSfc->ReadStream);
    --hChannel->ref;
};

void HdcServer::DeatchChannel(HSession hSession, const uint32_t channelId)
{
    HdcServerForClient *hSfc = static_cast<HdcServerForClient *>(clsServerForClient);
    // childCleared has not set, no need OP_QUERY_REF
    HChannel hChannel = hSfc->AdminChannel(OP_QUERY, channelId, nullptr);
    if (!hChannel) {
        ClearOwnTasks(hSession, channelId);
        uint8_t count = 0;
        Send(hSession->sessionId, channelId, CMD_KERNEL_CHANNEL_CLOSE, &count, 1);
        WRITE_LOG(LOG_WARN, "DeatchChannel hChannel null channelId:%u", channelId);
        return;
    }
    if (hChannel->childCleared) {
        WRITE_LOG(LOG_DEBUG, "Childchannel has already freed, cid:%u", channelId);
        return;
    }
    // The own task for this channel must be clear before free channel
    ClearOwnTasks(hSession, channelId);
    uint8_t count = 0;
    Send(hSession->sessionId, hChannel->channelId, CMD_KERNEL_CHANNEL_CLOSE, &count, 1);
    WRITE_LOG(LOG_DEBUG, "Childchannel begin close, cid:%u, sid:%u", hChannel->channelId, hSession->sessionId);
    if (uv_is_closing((const uv_handle_t *)&hChannel->hChildWorkTCP)) {
        Base::DoNextLoop(&hSession->childLoop, hChannel, [](const uint8_t flag, string &msg, const void *data) {
            HChannel hChannel = (HChannel)data;
            hChannel->childCleared = true;
            WRITE_LOG(LOG_DEBUG, "Childchannel free direct, cid:%u", hChannel->channelId);
        });
    } else {
        if (hChannel->hChildWorkTCP.loop == NULL) {
            WRITE_LOG(LOG_DEBUG, "Childchannel loop is null, cid:%u", hChannel->channelId);
        }
        Base::TryCloseHandle((uv_handle_t *)&hChannel->hChildWorkTCP, [](uv_handle_t *handle) -> void {
            HChannel hChannel = (HChannel)handle->data;
            hChannel->childCleared = true;
            WRITE_LOG(LOG_DEBUG, "Childchannel free callback, cid:%u", hChannel->channelId);
        });
    }
};

bool HdcServer::ServerCommand(const uint32_t sessionId, const uint32_t channelId, const uint16_t command,
                              uint8_t *bufPtr, const int size)
{
    HdcServerForClient *hSfc = static_cast<HdcServerForClient *>(clsServerForClient);
    HChannel hChannel = hSfc->AdminChannel(OP_QUERY, channelId, nullptr);
    HSession hSession = AdminSession(OP_QUERY, sessionId, nullptr);
    if (!hChannel || !hSession) {
        return false;
    }
    return FetchCommand(hSession, channelId, command, bufPtr, size);
}

// clang-format off
bool HdcServer::RedirectToTask(HTaskInfo hTaskInfo, HSession hSession, const uint32_t channelId,
                               const uint16_t command, uint8_t *payload, const int payloadSize)
// clang-format on
{
    bool ret = true;
    hTaskInfo->ownerSessionClass = this;
    switch (command) {
        case CMD_UNITY_BUGREPORT_INIT:
        case CMD_UNITY_BUGREPORT_DATA:
            ret = TaskCommandDispatch<HdcHostUnity>(hTaskInfo, TYPE_UNITY, command, payload, payloadSize);
            break;
        case CMD_FILE_INIT:
        case CMD_FILE_BEGIN:
        case CMD_FILE_CHECK:
        case CMD_FILE_DATA:
        case CMD_FILE_FINISH:
        case CMD_FILE_MODE:
        case CMD_DIR_MODE:
            ret = TaskCommandDispatch<HdcFile>(hTaskInfo, TASK_FILE, command, payload, payloadSize);
            break;
        case CMD_FORWARD_INIT:
        case CMD_FORWARD_CHECK:
        case CMD_FORWARD_CHECK_RESULT:
        case CMD_FORWARD_ACTIVE_MASTER:
        case CMD_FORWARD_ACTIVE_SLAVE:
        case CMD_FORWARD_DATA:
        case CMD_FORWARD_FREE_CONTEXT:
            ret = TaskCommandDispatch<HdcHostForward>(hTaskInfo, TASK_FORWARD, command, payload, payloadSize);
            break;
        case CMD_APP_INIT:
        case CMD_APP_SIDELOAD:
        case CMD_APP_BEGIN:
        case CMD_APP_FINISH:
        case CMD_APP_UNINSTALL:
            ret = TaskCommandDispatch<HdcHostApp>(hTaskInfo, TASK_APP, command, payload, payloadSize);
            break;
        case CMD_FLASHD_UPDATE_INIT:
        case CMD_FLASHD_FLASH_INIT:
        case CMD_FLASHD_CHECK:
        case CMD_FLASHD_BEGIN:
        case CMD_FLASHD_DATA:
        case CMD_FLASHD_FINISH:
        case CMD_FLASHD_ERASE:
        case CMD_FLASHD_FORMAT:
        case CMD_FLASHD_PROGRESS:
            ret = TaskCommandDispatch<HostUpdater>(hTaskInfo, TASK_FLASHD, command, payload, payloadSize);
            break;
        default:
            // ignore unknown command
            break;
    }
    return ret;
}

bool HdcServer::RemoveInstanceTask(const uint8_t op, HTaskInfo hTask)
{
    bool ret = true;
    switch (hTask->taskType) {
        case TYPE_SHELL:
            WRITE_LOG(LOG_DEBUG, "Server not enable unity/shell");
            break;
        case TYPE_UNITY:
            ret = DoTaskRemove<HdcHostUnity>(hTask, op);
            break;
        case TASK_FILE:
            ret = DoTaskRemove<HdcFile>(hTask, op);
            break;
        case TASK_FORWARD:
            ret = DoTaskRemove<HdcHostForward>(hTask, op);
            break;
        case TASK_APP:
            ret = DoTaskRemove<HdcHostApp>(hTask, op);
            break;
        case TASK_FLASHD:
            ret = DoTaskRemove<HostUpdater>(hTask, op);
            break;
        default:
            ret = false;
            break;
    }
    return ret;
}

void HdcServer::EchoToClientsForSession(uint32_t targetSessionId, const string &echo)
{
    HdcServerForClient *hSfc = static_cast<HdcServerForClient *>(clsServerForClient);
    WRITE_LOG(LOG_INFO, "%s:%u %s", __FUNCTION__, targetSessionId, echo.c_str());
    hSfc->EchoToAllChannelsViaSessionId(targetSessionId, echo);
}
}  // namespace Hdc
