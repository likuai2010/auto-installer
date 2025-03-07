/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

#include <fstream>
#include <filesystem>

#include "constant.h"
#include "file_utils.h"
#include "sign_head.h"
#include "block_head.h"
#include "verify_hap.h"
#include "verify_code_signature.h"
#include "hash_utils.h"
#include "sign_content_info.h"
#include "signature_block_tags.h"
#include "verify_elf.h"
#ifdef __APPLE__
#include <libkern/OSByteOrder.h>
#define be16toh(x) OSSwapBigToHostInt16(x)
#define le16toh(x) OSSwapLittleToHostInt16(x)
#define be32toh(x) OSSwapBigToHostInt32(x)
#define le32toh(x) OSSwapLittleToHostInt32(x)
#define be64toh(x) OSSwapBigToHostInt64(x)
#define le64toh(x) OSSwapLittleToHostInt64(x)
#endif
#ifdef _WIN32
#include <winsock2.h>
#include <windows.h>
#include <stdint.h>
#include <intrin.h>
#define be16toh(x) ntohs(x)
#define le16toh(x) (x)
#define be32toh(x) ntohl(x)
#define le32toh(x) (x)
#define be64toh(x) _byteswap_uint64(x)
#define le64toh(x) (x)
#endif

namespace OHOS {
namespace SignatureTools {

const int8_t VerifyElf::SIGNATURE_BLOCK = 0;
const int8_t VerifyElf::PROFILE_NOSIGNED_BLOCK = 1;
const int8_t VerifyElf::PROFILE_SIGNED_BLOCK = 2;
const int8_t VerifyElf::KEY_ROTATION_BLOCK = 3;
const int8_t VerifyElf::CODESIGNING_BLOCK_TYPE = 3;

bool VerifyElf::Verify(Options* options)
{
    // check param
    if (options == nullptr) {
        PrintErrorNumberMsg("VERIFY_ERROR", VERIFY_ERROR, "Param options is null.");
        return false;
    }
    if (!CheckParams(options)) {
        SIGNATURE_TOOLS_LOGE("verify elf check params failed!");
        return false;
    }
    std::string filePath = options->GetString(Options::IN_FILE);
    bool checkSignFileFlag = CheckSignFile(filePath);
    if (!checkSignFileFlag) {
        SIGNATURE_TOOLS_LOGE("check input elf file %s failed!", filePath.c_str());
        return false;
    }
    // verify elf
    std::vector<int8_t> profileVec;
    Pkcs7Context pkcs7Context;
    bool verifyElfFileFlag = VerifyElfFile(filePath, profileVec, options, pkcs7Context);
    if (!verifyElfFileFlag) {
        SIGNATURE_TOOLS_LOGE("verify elf file %s failed!", filePath.c_str());
        return false;
    }
    // write certificate and p7b file
    VerifyHap hapVerify(false);
    int32_t writeVerifyOutputFlag = hapVerify.WriteVerifyOutput(pkcs7Context, profileVec, options);
    if (writeVerifyOutputFlag != RET_OK) {
        SIGNATURE_TOOLS_LOGE("write elf output failed on verify elf!");
        return false;
    }
    return true;
}

bool VerifyElf::VerifyElfFile(const std::string& elfFile, std::vector<int8_t>& profileVec,
                              Options* options, Pkcs7Context& pkcs7Context)
{
    SignBlockInfo signBlockInfo(false);
    bool getSignBlockInfoFlag = GetSignBlockInfo(elfFile, signBlockInfo, ELF);
    if (!getSignBlockInfoFlag) {
        SIGNATURE_TOOLS_LOGE("get signBlockInfo failed on verify elf %s", elfFile.c_str());
        return false;
    }
    // verify profile
    std::string profileJson;
    bool verifyP7b = VerifyP7b(signBlockInfo.GetSignBlockMap(), options, pkcs7Context, profileVec, profileJson);
    if (!verifyP7b) {
        SIGNATURE_TOOLS_LOGE("verify profile failed on verify elf %s", elfFile.c_str());
        return false;
    }
    // verify code sign
    bool findFlag =
        signBlockInfo.GetSignBlockMap().find(CODESIGNING_BLOCK_TYPE) != signBlockInfo.GetSignBlockMap().end();
    if (findFlag) {
        SigningBlock codesign = signBlockInfo.GetSignBlockMap().find(CODESIGNING_BLOCK_TYPE)->second;
        bool verifyElfFlag = VerifyCodeSignature::VerifyElf(elfFile, codesign.GetOffset(), codesign.GetLength(),
                                                            ELF, profileJson);
        if (!verifyElfFlag) {
            SIGNATURE_TOOLS_LOGE("code signing failed on verify elf %s", elfFile.c_str());
            return false;
        }
    }
    return true;
}

bool VerifyElf::VerifyP7b(std::unordered_map<int8_t, SigningBlock>& signBlockMap,
                          Options* options, Pkcs7Context& pkcs7Context,
                          std::vector<int8_t>& profileVec, std::string& profileJson)
{
    if (signBlockMap.find(PROFILE_NOSIGNED_BLOCK) != signBlockMap.end()) {
        // verify unsigned profile
        const std::vector<int8_t>& profileByte = signBlockMap.find(PROFILE_NOSIGNED_BLOCK)->second.GetValue();
        std::string fromByteStr(profileByte.begin(), profileByte.end());
        profileJson = fromByteStr;
        profileVec = profileByte;
        SIGNATURE_TOOLS_LOGW("profile is not signed.");
    } else if (signBlockMap.find(PROFILE_SIGNED_BLOCK) != signBlockMap.end()) {
        // verify signed profile
        SigningBlock profileSign = signBlockMap.find(PROFILE_SIGNED_BLOCK)->second;
        const std::vector<int8_t>& profileByte = profileSign.GetValue();
        bool getRawContentFlag = GetRawContent(profileByte, profileJson);
        if (!getRawContentFlag) {
            SIGNATURE_TOOLS_LOGE("get profile content failed on verify elf!");
            return false;
        }
        VerifyHap hapVerify(false);
        std::unique_ptr<ByteBuffer> profileBuffer =
            std::make_unique<ByteBuffer>(reinterpret_cast<const char*>(profileByte.data()), profileByte.size());
        bool resultFlag = hapVerify.VerifyAppPkcs7(pkcs7Context, *profileBuffer);
        if (!resultFlag) {
            SIGNATURE_TOOLS_LOGE("verify elf profile failed on verify elf!");
            return false;
        }
        profileVec = profileByte;
        SIGNATURE_TOOLS_LOGI("verify profile success.");
    } else {
        SIGNATURE_TOOLS_LOGW("can not found profile sign block.");
    }
    return true;
}

bool VerifyElf::GetSignBlockInfo(const std::string& file, SignBlockInfo& signBlockInfo,
                                 const std::string fileType)
{
    // read file
    std::uintmax_t fileSize = std::filesystem::file_size(file);
    std::ifstream fileStream(file, std::ios::binary);
    if (!fileStream.is_open()) {
        PrintErrorNumberMsg("IO_ERROR", IO_ERROR, "open file: " + file + "failed");
        return false;
    }
    std::vector<char>* fileBytes = new std::vector<char>(fileSize, 0);
    fileStream.read(fileBytes->data(), fileBytes->size());
    if (fileStream.fail() && !fileStream.eof()) {
        PrintErrorNumberMsg("IO_ERROR", IO_ERROR, "Error occurred while reading data");
        fileStream.close();
        delete fileBytes;
        return false;
    }
    fileStream.close();
    // get BlockData
    BlockData blockData(0, 0);
    bool getSignBlockData = GetSignBlockData(*((std::vector<int8_t>*)fileBytes), blockData, fileType);
    if (!getSignBlockData) {
        SIGNATURE_TOOLS_LOGE("get signBlockData failed on verify elf/bin file %s", file.c_str());
        delete fileBytes;
        return false;
    }
    // get SignBlockMap
    if (fileType == ELF) {
        GetElfSignBlock(*((std::vector<int8_t>*)fileBytes), blockData, signBlockInfo.GetSignBlockMap());
    } else {
        GetBinSignBlock(*((std::vector<int8_t>*)fileBytes), blockData, signBlockInfo.GetSignBlockMap());
    }
    // get bin file digest
    bool needGenerateDigest = signBlockInfo.GetNeedGenerateDigest();
    if (needGenerateDigest) {
        const std::vector<int8_t>& signatrue = signBlockInfo.GetSignBlockMap().find(0)->second.GetValue();
        bool getFileDigest = GetFileDigest(*((std::vector<int8_t>*)fileBytes), signatrue, signBlockInfo);
        if (!getFileDigest) {
            SIGNATURE_TOOLS_LOGE("getFileDigest failed on verify bin file %s", file.c_str());
            delete fileBytes;
            return false;
        }
    }
    delete fileBytes;
    return true;
}

bool VerifyElf::GetFileDigest(std::vector<int8_t>& fileBytes, const std::vector<int8_t>& signatrue,
                              SignBlockInfo& signBlockInfo)
{
    std::string binDigest;
    bool getRawContentFlag = GetRawContent(signatrue, binDigest);
    if (!getRawContentFlag) {
        SIGNATURE_TOOLS_LOGE("getBinDigest failed on verify bin digest!");
        return false;
    }
    std::vector<int8_t> rawDigest(binDigest.begin(), binDigest.end());
    signBlockInfo.SetRawDigest(rawDigest);
    GenerateFileDigest(fileBytes, signBlockInfo);
    return true;
}

bool VerifyElf::GenerateFileDigest(std::vector<int8_t>& fileBytes, SignBlockInfo& signBlockInfo)
{
    // get algId
    std::vector<int8_t>& rawDigest = signBlockInfo.GetRawDigest();
    std::unique_ptr<ByteBuffer> digBuffer = std::make_unique<ByteBuffer>(rawDigest.size());
    digBuffer->PutData(rawDigest.data(), rawDigest.size());
    digBuffer->Flip();
    int32_t algOffset = 10;
    int16_t algId = 0;
    const char* bufferPtr = digBuffer->GetBufferPtr();
    algId = static_cast<int16_t>(be16toh(*reinterpret_cast<const int16_t*>(bufferPtr + algOffset)));
    // generate digest
    int32_t fileLength = signBlockInfo.GetSignBlockMap().find(0)->second.GetOffset();
    std::string digAlg = HashUtils::GetHashAlgName(algId);
    std::vector<int8_t> generatedDig = HashUtils::GetDigestFromBytes(fileBytes, fileLength, digAlg);
    if (generatedDig.empty()) {
        SIGNATURE_TOOLS_LOGE("generate bin file digest failed on verify bin");
        return false;
    }
    SignContentInfo contentInfo;
    contentInfo.AddContentHashData(0, SignatureBlockTags::HASH_ROOT_4K, algId, generatedDig.size(), generatedDig);
    std::vector<int8_t> dig = contentInfo.GetByteContent();
    if (dig.empty()) {
        SIGNATURE_TOOLS_LOGE("generate file digest is null on verify bin");
        return false;
    }
    signBlockInfo.SetFileDigest(dig);
    return true;
}

bool VerifyElf::GetSignBlockData(std::vector<int8_t>& bytes, BlockData& blockData,
                                 const std::string fileType)
{
    int64_t offset = 0;
    bool checkMagicAndVersionFlag = CheckMagicAndVersion(bytes, offset, fileType);
    if (!checkMagicAndVersionFlag) {
        SIGNATURE_TOOLS_LOGE("check magic and version failed, file type: %s", fileType.c_str());
        return false;
    }
    int32_t intByteLength = 4;
    std::vector<int8_t> blockSizeByte(bytes.begin() + offset, bytes.begin() + offset + intByteLength);
    offset += intByteLength;
    std::vector<int8_t> blockNumByte(bytes.begin() + offset, bytes.begin() + offset + intByteLength);
    if (fileType == BIN) {
        std::reverse(blockSizeByte.begin(), blockSizeByte.end());
        std::reverse(blockNumByte.begin(), blockNumByte.end());
    }
    std::unique_ptr<ByteBuffer> blockNumBf = std::make_unique<ByteBuffer>(blockNumByte.size());
    blockNumBf->PutData(blockNumByte.data(), blockNumByte.size());
    blockNumBf->Flip();
    int32_t blockNum = 0;
    blockNumBf->GetInt32(blockNum);
    std::unique_ptr<ByteBuffer> blockSizeBf = std::make_unique<ByteBuffer>(blockSizeByte.size());
    blockSizeBf->PutData(blockSizeByte.data(), blockSizeByte.size());
    blockSizeBf->Flip();
    int32_t blockSize = 0;
    blockSizeBf->GetInt32(blockSize);
    int64_t blockStart = 0;
    if (fileType == BIN) {
        blockStart = bytes.size() - blockSize;
    } else {
        blockStart = bytes.size() - SignHead::SIGN_HEAD_LEN - blockSize;
    }
    blockData.SetBlockNum(blockNum);
    blockData.SetBlockStart(blockStart);
    return true;
}

bool VerifyElf::CheckMagicAndVersion(std::vector<int8_t>& bytes, int64_t& offset, const std::string fileType)
{
    std::string magicStr = (fileType == ELF ? SignHead::ELF_MAGIC : SignHead::MAGIC);
    offset = bytes.size() - SignHead::SIGN_HEAD_LEN;
    std::vector<int8_t> magicByte(bytes.begin() + offset, bytes.begin() + offset + magicStr.size());
    offset += magicStr.size();
    std::vector<int8_t> versionByte(bytes.begin() + offset, bytes.begin() + offset + SignHead::VERSION.size());
    offset += SignHead::VERSION.size();
    std::vector<int8_t> magicVec(magicStr.begin(), magicStr.end());
    for (int i = 0; i < magicStr.size(); i++) {
        if (magicVec[i] != magicByte[i]) {
            PrintErrorNumberMsg("VERIFY_ERROR", VERIFY_ERROR, "magic verify failed!");
            return false;
        }
    }
    std::vector<int8_t> versionVec(SignHead::VERSION.begin(), SignHead::VERSION.end());
    for (int i = 0; i < SignHead::VERSION.size(); i++) {
        if (versionVec[i] != versionByte[i]) {
            PrintErrorNumberMsg("VERIFY_ERROR", VERIFY_ERROR, "sign version verify failed!");
            return false;
        }
    }
    return true;
}

void VerifyElf::GetElfSignBlock(std::vector<int8_t>& bytes, BlockData& blockData,
                                std::unordered_map<int8_t, SigningBlock>& signBlockMap)
{
    int32_t headBlockLen = SignHead::ELF_BLOCK_LEN;
    int64_t offset = blockData.GetBlockStart();
    for (int i = 0; i < blockData.GetBlockNum(); i++) {
        std::vector<int8_t> blockByte(bytes.begin() + offset, bytes.begin() + offset + headBlockLen);
        std::unique_ptr<ByteBuffer> blockBuffer = std::make_unique<ByteBuffer>(blockByte.size());
        blockBuffer->PutData(blockByte.data(), blockByte.size());
        blockBuffer->Flip();
        int8_t type = 0;
        int8_t tag = 0;
        int16_t empValue = 0;
        int32_t length = 0;
        int32_t blockOffset = 0;
        blockBuffer->GetByte((int8_t*)&type, sizeof(int8_t));
        blockBuffer->GetByte((int8_t*)&tag, sizeof(int8_t));
        blockBuffer->GetInt16(empValue);
        blockBuffer->GetInt32(length);
        blockBuffer->GetInt32(blockOffset);
        std::vector<int8_t> value(bytes.begin() + blockData.GetBlockStart() + blockOffset,
                                  bytes.begin() + blockData.GetBlockStart() + blockOffset + length);
        SigningBlock signingBlock(type, value, blockData.GetBlockStart() + blockOffset);
        signBlockMap.insert(std::make_pair(type, signingBlock));
        offset += headBlockLen;
    }
}

void VerifyElf::GetBinSignBlock(std::vector<int8_t>& bytes, BlockData& blockData,
                                std::unordered_map<int8_t, SigningBlock>& signBlockMap)
{
    int32_t headBlockLen = SignHead::BIN_BLOCK_LEN;
    int32_t offset = blockData.GetBlockStart();
    for (int i = 0; i < blockData.GetBlockNum(); i++) {
        std::vector<int8_t> blockByte(bytes.begin() + offset, bytes.begin() + offset + headBlockLen);
        std::unique_ptr<ByteBuffer> blockBuffer = std::make_unique<ByteBuffer>(blockByte.size());
        blockBuffer->PutData(blockByte.data(), blockByte.size());
        blockBuffer->Flip();
        int8_t type = 0;
        int8_t tag = 0;
        int16_t length = 0;
        int32_t blockOffset = 0;
        blockBuffer->GetByte((int8_t*)&type, sizeof(int8_t));
        blockBuffer->GetByte((int8_t*)&tag, sizeof(int8_t));
        const char* bufferPtr = blockBuffer->GetBufferPtr();
        int bfLengthIdx = 2;
        int bfBlockIdx = 4;
        length = static_cast<int16_t>(be16toh(*reinterpret_cast<const int16_t*>(bufferPtr + bfLengthIdx)));
        blockOffset = static_cast<int32_t>(be32toh(*reinterpret_cast<const int32_t*>(bufferPtr + bfBlockIdx)));
        if (length == 0) {
            length = bytes.size() - SignHead::SIGN_HEAD_LEN - blockOffset;
        }
        std::vector<int8_t> value(bytes.begin() + blockOffset, bytes.begin() + blockOffset + length);
        SigningBlock signingBlock(type, value, blockOffset);
        signBlockMap.insert(std::make_pair(type, signingBlock));
        offset += headBlockLen;
    }
}

bool VerifyElf::CheckParams(Options* options)
{
    bool certEmpty = options->GetString(Options::OUT_CERT_CHAIN).empty();
    if (certEmpty) {
        PrintErrorNumberMsg("VERIFY_ERROR", VERIFY_ERROR, "Missing parameter: " + Options::OUT_CERT_CHAIN + "s.");
        return false;
    }
    bool profileEmpty = options->GetString(Options::OUT_PROFILE).empty();
    if (profileEmpty) {
        PrintErrorNumberMsg("VERIFY_ERROR", VERIFY_ERROR, "Missing parameter: " + Options::OUT_PROFILE + "s.");
        return false;
    }
    bool proofEmpty = options->GetString(Options::PROOF_FILE).empty();
    if (proofEmpty) {
        SIGNATURE_TOOLS_LOGW("Missing parameter: %s.",
                             Options::PROOF_FILE.c_str());
    }
    return true;
}

bool VerifyElf::CheckSignFile(const std::string& signedFile)
{
    if (signedFile.empty()) {
        PrintErrorNumberMsg("VERIFY_ERROR", VERIFY_ERROR, "Not found verify file path " + signedFile);
        return false;
    }
    bool validFlag = FileUtils::IsValidFile(signedFile);
    if (!validFlag) {
        SIGNATURE_TOOLS_LOGE("signed file is invalid.");
        return false;
    }
    return true;
}

bool VerifyElf::GetRawContent(const std::vector<int8_t>& contentVec, std::string& rawContent)
{
    PKCS7Data p7Data;
    int parseFlag = p7Data.Parse(contentVec);
    if (parseFlag < 0) {
        SIGNATURE_TOOLS_LOGE("parse content failed!");
        return false;
    }
    int verifyFlag = p7Data.Verify();
    if (verifyFlag < 0) {
        SIGNATURE_TOOLS_LOGE("verify content failed!");
        return false;
    }
    int getContentFlag = p7Data.GetContent(rawContent);
    if (getContentFlag < 0) {
        SIGNATURE_TOOLS_LOGE("get p7Data raw content failed!");
        return false;
    }
    return true;
}

} // namespace SignatureTools
} // namespace OHOS