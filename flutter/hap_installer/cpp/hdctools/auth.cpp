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
#include "auth.h"
#include <openssl/evp.h>
#include <openssl/objects.h>
#include <openssl/pem.h>
#include <openssl/rsa.h>
#include <openssl/sha.h>
#include <openssl/err.h>
#include <fstream>
#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
#include "password.h"
#endif

using namespace Hdc;
#define BIGNUMTOBIT 32

namespace HdcAuth {
// ---------------------------------------Cheat compiler---------------------------------------------------------
#ifdef HDC_HOST

bool AuthVerify(uint8_t *token, uint8_t *sig, int siglen)
{
    return false;
};
bool PostUIConfirm(string publicKey)
{
    return false;
}

#else  // daemon

bool GenerateKey(const char *file)
{
    return false;
};
int AuthSign(void *rsa, const unsigned char *token, size_t tokenSize, void *sig)
{
    return 0;
};
int GetPublicKeyFileBuf(unsigned char *data, size_t len)
{
    return 0;
}

#endif
// ------------------------------------------------------------------------------------------------

const uint32_t RSANUMBYTES = 512;  // 4096 bit key length
const uint32_t RSANUMWORDS = (RSANUMBYTES / sizeof(uint32_t));
struct RSAPublicKey {
    int wordModulusSize;            // Length of n[] in number of uint32_t */
    uint32_t rsaN0inv;              // -1 / n[0] mod 2^32
    uint32_t modulus[RSANUMWORDS];  // modulus as little endian array
    uint32_t rr[RSANUMWORDS];       // R^2 as little endian array
    BN_ULONG exponent;                   // 3 or 65537
};

#ifdef HDC_HOST
// Convert OpenSSL RSA private key to pre-computed RSAPublicKey format
int RSA2RSAPublicKey(RSA *rsa, RSAPublicKey *publicKey)
{
    int result = 1;
    unsigned int i;
    BN_CTX *ctx = BN_CTX_new();
    BIGNUM *r32 = BN_new();
    BIGNUM *rsaRR = BN_new();
    BIGNUM *rsaR = BN_new();
    BIGNUM *rsaRem = BN_new();
    BIGNUM *rsaN0inv = BN_new();
#ifdef OPENSSL_IS_BORINGSSL
    // boringssl
    BIGNUM *n = BN_new();
    BN_copy(n, rsa->n);
    publicKey->exponent = BN_get_word(rsa->e);
#else
    // openssl
#if OPENSSL_VERSION_NUMBER >= 0x10100005L
    BIGNUM *n = (BIGNUM *)RSA_get0_n(rsa);
    publicKey->exponent = BN_get_word(RSA_get0_e(rsa));
#else
    BIGNUM *n = BN_new();
    BN_copy(n, rsa->n);
    publicKey->exponent = BN_get_word(rsa->e);
#endif

#endif  // OPENSSL_IS_BORINGSSL
    while (true) {
        if (RSA_size(rsa) != RSANUMBYTES) {
            result = 0;
            break;
        }

        BN_set_bit(r32, BIGNUMTOBIT);
        BN_set_bit(rsaR, RSANUMWORDS * BIGNUMTOBIT);
        BN_mod_sqr(rsaRR, rsaR, n, ctx);
        BN_div(nullptr, rsaRem, n, r32, ctx);
        BN_mod_inverse(rsaN0inv, rsaRem, r32, ctx);
        publicKey->wordModulusSize = RSANUMWORDS;
        publicKey->rsaN0inv = 0 - BN_get_word(rsaN0inv);
        for (i = 0; i < RSANUMWORDS; ++i) {
            BN_div(rsaRR, rsaRem, rsaRR, r32, ctx);
            publicKey->rr[i] = BN_get_word(rsaRem);
            BN_div(n, rsaRem, n, r32, ctx);
            publicKey->modulus[i] = BN_get_word(rsaRem);
        }
        break;
    }

    BN_free(rsaR);
    BN_free(rsaRR);
    BN_free(n);
    BN_free(r32);
    BN_free(rsaN0inv);
    BN_free(rsaRem);
    BN_CTX_free(ctx);
    return result;
}

int GetUserInfo(char *buf, size_t len)
{
    char hostname[BUF_SIZE_DEFAULT];
    char username[BUF_SIZE_DEFAULT];
    uv_passwd_t pwd;
    int ret = -1;
    size_t bufSize = sizeof(hostname);
    if (uv_os_gethostname(hostname, &bufSize) < 0 && EOK != strcpy_s(hostname, sizeof(hostname), "unknown")) {
        return ERR_API_FAIL;
    }
    if (!uv_os_get_passwd(&pwd) && !strcpy_s(username, sizeof(username), pwd.username)) {
        ret = 0;
    }
    uv_os_free_passwd(&pwd);
    if (ret < 0 && EOK != strcpy_s(username, sizeof(username), "unknown")) {
        return ERR_API_FAIL;
    }
    if (snprintf_s(buf, len, len - 1, " %s@%s", username, hostname) < 0) {
        return ERR_BUF_OVERFLOW;
    }
    return RET_SUCCESS;
}

int WritePublicKeyfile(RSA *private_key, const char *private_key_path)
{
    RSAPublicKey publicKey;
    char info[BUF_SIZE_DEFAULT];
    int ret = 0;
    string path = private_key_path + string(".pub");

    ret = RSA2RSAPublicKey(private_key, &publicKey);
    if (!ret) {
        WRITE_LOG(LOG_DEBUG, "Failed to convert to publickey\n");
        return 0;
    }
    vector<uint8_t> vec = Base::Base64Encode((const uint8_t *)&publicKey, sizeof(RSAPublicKey));
    if (!vec.size()) {
        return 0;
    }
    GetUserInfo(info, sizeof(info));
    vec.insert(vec.end(), (uint8_t *)info, (uint8_t *)info + strlen(info));
    ret = Base::WriteBinFile(path.c_str(), vec.data(), vec.size(), true);
    return ret >= 0 ? 1 : 0;
}

bool GenerateKey(const char *file)
{
#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
    Base::PrintMessage("[E002105] Unsupport command]");
    return false;
#endif
    EVP_PKEY *publicKey = EVP_PKEY_new();
    BIGNUM *exponent = BN_new();
    RSA *rsa = RSA_new();
    int bits = 4096;
    mode_t old_mask;
    FILE *fKey = nullptr;
    bool ret = false;

    while (true) {
        WRITE_LOG(LOG_DEBUG, "generate_key '%s'\n", file);
        if (!publicKey || !exponent || !rsa) {
            WRITE_LOG(LOG_DEBUG, "Failed to allocate key");
            break;
        }

        BN_set_word(exponent, RSA_F4);
        RSA_generate_key_ex(rsa, bits, exponent, nullptr);
        EVP_PKEY_set1_RSA(publicKey, rsa);
        old_mask = umask(077);  // 077:permission

        fKey = Base::Fopen(file, "w");
        if (!fKey) {
            WRITE_LOG(LOG_DEBUG, "Failed to open '%s'\n", file);
            umask(old_mask);
            break;
        }
        umask(old_mask);
        if (!PEM_write_PrivateKey(fKey, publicKey, nullptr, nullptr, 0, nullptr, nullptr)) {
            WRITE_LOG(LOG_DEBUG, "Failed to write key");
            break;
        }
        if (!WritePublicKeyfile(rsa, file)) {
            WRITE_LOG(LOG_DEBUG, "Failed to write public key");
            break;
        }
        ret = true;
        break;
    }

    EVP_PKEY_free(publicKey);
    BN_free(exponent);
    if (fKey)
        fclose(fKey);
    return ret;
}

bool ReadKey(const char *file, list<void *> *listPrivateKey)
{
    FILE *f = nullptr;
    bool ret = false;

    if (file == nullptr || listPrivateKey == nullptr) {
        WRITE_LOG(LOG_FATAL, "file or listPrivateKey is null");
        return ret;
    }
    while (true) {
        if (!(f = fopen(file, "r"))) {
            break;
        }
        RSA *rsa = RSA_new();
        if (!PEM_read_RSAPrivateKey(f, &rsa, nullptr, nullptr)) {
            RSA_free(rsa);
            break;
        }
        listPrivateKey->push_back((void *)rsa);
        ret = true;
        break;
    }
    if (f) {
        fclose(f);
    }
    return ret;
}

bool GetUserKeyPath(string &path)
{
    struct stat status;
    const char harmoneyPath[] = ".harmony";
    const char hdcKeyFile[] = "hdckey";
    char buf[BUF_SIZE_DEFAULT];
    size_t len = BUF_SIZE_DEFAULT;
    // $home
    if (uv_os_tmpdir(buf, &len) < 0)
        return false;
    string dir = string(buf) + Base::GetPathSep() + string(harmoneyPath) + Base::GetPathSep();
    path = Base::CanonicalizeSpecPath(dir);
    if (path.empty()) {
        path = dir;
    } else {
        path += Base::GetPathSep(); // bugfix for unix platform create key file not in dir.
    }
    if (stat(path.c_str(), &status)) {
        uv_fs_t req;
        uv_fs_mkdir(nullptr, &req, path.c_str(), 0750, nullptr);  // 0750:permission
        uv_fs_req_cleanup(&req);
        uv_fs_stat(nullptr, &req, path.c_str(), nullptr);
        uv_fs_req_cleanup(&req);
        if (req.result < 0) {
            WRITE_LOG(LOG_FATAL, "Cannot mkdir '%s'", path.c_str());
            return false;
        }
    }
    path += hdcKeyFile;
    return true;
}

bool LoadHostUserKey(list<void *> *listPrivateKey)
{
    struct stat status;
    string path;
    if (!GetUserKeyPath(path)) {
        return false;
    }
    if (stat(path.c_str(), &status) == -1) {
        if (!GenerateKey(path.c_str())) {
            WRITE_LOG(LOG_DEBUG, "Failed to generate new key");
            return false;
        }
    }
    if (!ReadKey(path.c_str(), listPrivateKey)) {
        return false;
    }
    return true;
}

int AuthSign(void *rsa, const unsigned char *token, size_t tokenSize, void *sig)
{
    unsigned int len;
    if (!RSA_sign(NID_sha256, token, tokenSize, (unsigned char *)sig, &len, (RSA *)rsa)) {
        return 0;
    }
    return static_cast<int>(len);
}

int GetPublicKeyFileBuf(unsigned char *data, size_t len)
{
    string path;
    int ret;

    if (!GetUserKeyPath(path)) {
        return 0;
    }
    path += ".pub";
    ret = Base::ReadBinFile(path.c_str(), (void **)data, len);
    if (ret <= 0) {
        return 0;
    }
    data[ret] = '\0';
    return ret + 1;
}

#else  // daemon

bool RSAPublicKey2RSA(const uint8_t *keyBuf, RSA **key)
{
    const int pubKeyModulusSize = 256;
    const int pubKeyModulusSizeWords = pubKeyModulusSize / 4;

    const RSAPublicKey *keyStruct = reinterpret_cast<const RSAPublicKey *>(keyBuf);
    bool ret = false;
    uint8_t modulusBuffer[pubKeyModulusSize];
    RSA *newKey = RSA_new();
    if (!newKey) {
        goto cleanup;
    }
    if (keyStruct->wordModulusSize != pubKeyModulusSizeWords) {
        goto cleanup;
    }
    if (memcpy_s(modulusBuffer, sizeof(modulusBuffer), keyStruct->modulus, sizeof(modulusBuffer)) != EOK) {
        goto cleanup;
    }
    Base::ReverseBytes(modulusBuffer, sizeof(modulusBuffer));

#ifdef OPENSSL_IS_BORINGSSL
    // boringssl
    newKey->n = BN_bin2bn(modulusBuffer, sizeof(modulusBuffer), nullptr);
    newKey->e = BN_new();
    if (!newKey->e || !BN_set_word(newKey->e, keyStruct->exponent) || !newKey->n) {
        goto cleanup;
    }
#else
    // openssl
#if OPENSSL_VERSION_NUMBER >= 0x10100005L
    RSA_set0_key(newKey, BN_bin2bn(modulusBuffer, sizeof(modulusBuffer), nullptr), BN_new(), BN_new());
#else
    newKey->n = BN_bin2bn(modulusBuffer, sizeof(modulusBuffer), nullptr);
    newKey->e = BN_new();
    if (!newKey->e || !BN_set_word(newKey->e, keyStruct->exponent) || !newKey->n) {
        goto cleanup;
    }
#endif
#endif

    *key = newKey;
    ret = true;

cleanup:
    if (!ret && newKey) {
        RSA_free(newKey);
    }
    return ret;
}

void ReadDaemonKeys(const char *file, list<void *> *listPublicKey)
{
    char buf[BUF_SIZE_DEFAULT2] = { 0 };
    char *sep = nullptr;
    int ret;
    FILE *f = Base::Fopen(file, "re");
    if (!f) {
        WRITE_LOG(LOG_DEBUG, "Can't open '%s'", file);
        return;
    }
    while (fgets(buf, sizeof(buf), f)) {
        RSAPublicKey *key = new RSAPublicKey();
        if (!key) {
            break;
        }
        sep = strpbrk(buf, " \t");
        if (sep) {
            *sep = '\0';
        }
        ret = Base::Base64DecodeBuf(reinterpret_cast<uint8_t *>(buf), strlen(buf), reinterpret_cast<uint8_t *>(key));
        if (ret != sizeof(RSAPublicKey)) {
            WRITE_LOG(LOG_DEBUG, "%s: Invalid base64 data ret=%d", file, ret);
            delete key;
            continue;
        }

        if (key->wordModulusSize != RSANUMWORDS) {
            WRITE_LOG(LOG_DEBUG, "%s: Invalid key len %d\n", file, key->wordModulusSize);
            delete key;
            continue;
        }
        listPublicKey->push_back(key);
    }
    fclose(f);
}

bool AuthVerify(uint8_t *token, uint8_t *sig, int siglen)
{
    list<void *> listPublicKey;
    uint8_t authKeyIndex = 0;
    void *ptr = nullptr;
    int ret = 0;
    int childRet = 0;
    while (KeylistIncrement(&listPublicKey, authKeyIndex, &ptr)) {
        RSA *rsa = nullptr;
        if (!RSAPublicKey2RSA((const uint8_t *)ptr, &rsa)) {
            break;
        }
        childRet = RSA_verify(NID_sha256, reinterpret_cast<const unsigned char *>(token),
                              RSA_TOKEN_SIZE, reinterpret_cast<const unsigned char *>(sig),
                              siglen, rsa);
        RSA_free(rsa);
        if (childRet) {
            ret = 1;
            break;
        }
    }
    FreeKey(true, &listPublicKey);
    return ret;
}

void LoadDaemonKey(list<void *> *listPublicKey)
{
#ifdef HDC_PCDEBUG
    char keyPaths[][BUF_SIZE_SMALL] = { "/root/.harmony/hdckey.pub" };
#else
    char keyPaths[][BUF_SIZE_SMALL] = { "/data/service/el1/public/hdc/hdc_keys" };
#endif
    int num = sizeof(keyPaths) / sizeof(keyPaths[0]);
    struct stat buf;

    for (int i = 0; i < num; ++i) {
        char *p = keyPaths[i];
        if (!stat(p, &buf)) {
            WRITE_LOG(LOG_DEBUG, "Loading keys from '%s'", p);
            ReadDaemonKeys(p, listPublicKey);
        }
    }
}

bool PostUIConfirm(string publicKey)
{
    // Because the Hi3516 development board has no UI support for the time being, all public keys are received and
    // By default, the system UI will record the public key /data/misc/hdc/hdckey/data/misc/hdc/hdckey
    return true;
}
#endif  // HDC_HOST

// --------------------------------------common code------------------------------------------
bool KeylistIncrement(list<void *> *listKey, uint8_t &authKeyIndex, void **out)
{
    if (!listKey->size()) {
#ifdef HDC_HOST
        LoadHostUserKey(listKey);
#else
        LoadDaemonKey(listKey);
#endif
    }
    if (authKeyIndex == listKey->size()) {
        // all finish
        return false;
    }
    auto listIndex = listKey->begin();
    std::advance(listIndex, ++authKeyIndex);
    *out = *listIndex;
    if (!*out) {
        return false;
    }
    return true;
}

void FreeKey(bool publicOrPrivate, list<void *> *listKey)
{
    for (auto &&v : *listKey) {
        if (publicOrPrivate) {
            delete (RSAPublicKey *)v;
            v = nullptr;
        } else {
            RSA_free((RSA *)v);
            v = nullptr;
        }
    }
    listKey->clear();
}

#ifdef HDC_HOST
EVP_PKEY *GenerateNewKey(void)
{
    bool success = false;
    int bits = RSA_KEY_BITS;
    RSA *rsa = RSA_new();
    BIGNUM *e = BN_new();
    EVP_PKEY *evp = EVP_PKEY_new();

    while (true) {
        if (!evp || !e || !rsa) {
            WRITE_LOG(LOG_FATAL, "allocate key failed");
            break;
        }

        BN_set_word(e, RSA_F4);
        if (!RSA_generate_key_ex(rsa, bits, e, nullptr)) {
            WRITE_LOG(LOG_FATAL, "generate rsa key failed");
            break;
        }
        if (!EVP_PKEY_set1_RSA(evp, rsa)) {
            WRITE_LOG(LOG_FATAL, "evp set rsa failed");
            break;
        }

        WRITE_LOG(LOG_INFO, "generate key pair success");
        success = true;
        break;
    }

    if (e)
        BN_free(e);
    if (success) {
        return evp;
    }

    // if fail, need free rsa and evp
    if (rsa)
        RSA_free(rsa);
    if (evp)
        EVP_PKEY_free(evp);

    return nullptr;
}

static bool WritePublicFile(const std::string& fileName, EVP_PKEY *evp)
{
    FILE *fp = nullptr;
    fp = Base::Fopen(fileName.c_str(), "w");
    if (fp == nullptr) {
        WRITE_LOG(LOG_FATAL, "open %s failed", fileName.c_str());
        return false;
    }
    if (!PEM_write_PUBKEY(fp, evp)) {
        WRITE_LOG(LOG_FATAL, "write public key file %s failed", fileName.c_str());
        (void)fclose(fp);
        return false;
    }
    (void)fclose(fp);
    return true;
}

#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
static bool WritePrivatePwdFile(const std::string& fileName, const std::string& encryptPwd)
{
    return Base::WriteToFile(fileName, encryptPwd, std::ios::out | std::ios::trunc);
}
#endif

static bool WritePrivateFile(const std::string& fileName, EVP_PKEY *evp)
{
    FILE *fp = nullptr;
#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
    Hdc::HdcPassword pwd(HDC_PRIVATE_KEY_FILE_PWD_KEY_ALIAS);
    pwd.GeneratePassword();
    if (!pwd.ResetPwdKey()) {
        WRITE_LOG(LOG_FATAL, "reset pwd key failed");
        return false;
    }
    if (!pwd.EncryptPwd()) {
        WRITE_LOG(LOG_FATAL, "encrypt pwd failed");
        return false;
    }
    std::pair<uint8_t*, int> pwdValue = pwd.GetPassword();
#endif
    fp = Base::Fopen(fileName.c_str(), "w");
    if (fp == nullptr) {
        WRITE_LOG(LOG_FATAL, "open %s failed", fileName.c_str());
        return false;
    }
#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
    if (!PEM_write_PrivateKey(fp, evp, EVP_aes_256_cbc(), pwdValue.first, pwdValue.second, nullptr, nullptr)) {
#else
    if (!PEM_write_PrivateKey(fp, evp, nullptr, nullptr, 0, nullptr, nullptr)) {
#endif
        WRITE_LOG(LOG_FATAL, "write private key failed");
        (void)fclose(fp);
        return false;
    }
    (void)fclose(fp);
#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
    if (!WritePrivatePwdFile(fileName + ".key", pwd.GetEncryptPassword())) {
        WRITE_LOG(LOG_FATAL, "write private key pwd failed");
        return false;
    }
#endif
    return true;
}

bool GenerateKeyPair(const string& prikey_filename, const string& pubkey_filename)
{
    bool ret = false;
    EVP_PKEY *evp = nullptr;
#ifdef __OHOS__
    mode_t old_mask = umask(027);  // 027:permission
#else
    mode_t old_mask = umask(077);  // 077:permission
#endif

    while (true) {
        evp = GenerateNewKey();
        if (!evp) {
            WRITE_LOG(LOG_FATAL, "generate new key failed");
            break;
        }

        if (!WritePublicFile(pubkey_filename, evp)) {
            break;
        }

        if (!WritePrivateFile(prikey_filename, evp)) {
            break;
        }
        WRITE_LOG(LOG_INFO, "generate key pair success");
        ret = true;
        break;
    }

    if (evp) {
        EVP_PKEY_free(evp);
    }
    umask(old_mask);
    return ret;
}

bool LoadPublicKey(const string& pubkey_filename, string &pubkey)
{
    bool ret = false;
    BIO *bio = nullptr;
    EVP_PKEY *evp = nullptr;
    FILE *file_pubkey = nullptr;

    do {
        file_pubkey = Base::Fopen(pubkey_filename.c_str(), "r");
        if (!file_pubkey) {
            WRITE_LOG(LOG_FATAL, "open file %s failed", pubkey_filename.c_str());
            break;
        }
        evp = PEM_read_PUBKEY(file_pubkey, NULL, NULL, NULL);
        if (!evp) {
            WRITE_LOG(LOG_FATAL, "read pubkey from %s failed", pubkey_filename.c_str());
            break;
        }
        bio = BIO_new(BIO_s_mem());
        if (!bio) {
            WRITE_LOG(LOG_FATAL, "alloc bio mem failed");
            break;
        }
        if (!PEM_write_bio_PUBKEY(bio, evp)) {
            WRITE_LOG(LOG_FATAL, "write bio failed");
            break;
        }
        size_t len = 0;
        char buf[RSA_KEY_BITS] = {0};
        if (BIO_read_ex(bio, buf, sizeof(buf), &len) <= 0) {
            WRITE_LOG(LOG_FATAL, "read bio failed");
            break;
        }
        pubkey = string(buf, len);
        ret = true;
        WRITE_LOG(LOG_INFO, "load pubkey from file(%s) success", pubkey_filename.c_str());
    } while (0);

    if (evp) {
        EVP_PKEY_free(evp);
        evp = nullptr;
    }
    if (bio) {
        BIO_free(bio);
        bio = nullptr;
    }
    if (file_pubkey) {
        fclose(file_pubkey);
        file_pubkey = nullptr;
    }
    return ret;
}

bool TryLoadPublicKey(string &pubkey)
{
    string prikey_filename;
    struct stat status;
    if (!GetUserKeyPath(prikey_filename)) {
        WRITE_LOG(LOG_FATAL, "get key path failed");
        return false;
    }
    string pubkey_filename = prikey_filename + ".pub";
    if (stat(prikey_filename.c_str(), &status) == -1) {
        if (!GenerateKeyPair(prikey_filename, pubkey_filename)) {
            WRITE_LOG(LOG_FATAL, "generate new key failed");
            return false;
        }
    }
    if (!LoadPublicKey(pubkey_filename, pubkey)) {
        WRITE_LOG(LOG_FATAL, "load key failed");
        return false;
    }

    WRITE_LOG(LOG_INFO, "load pubkey success");

    return true;
}

bool GetHostName(string &hostname)
{
    int ret;
    char buf[BUF_SIZE_DEFAULT] = {0};
    size_t bufsize = sizeof(buf);

    ret = uv_os_gethostname(buf, &bufsize);
    if (ret != 0) {
        WRITE_LOG(LOG_FATAL, "get hostname failed: %d", ret);
        return false;
    }

    hostname = string(buf, bufsize);

    WRITE_LOG(LOG_INFO, "hostname: %s", hostname.c_str());

    return true;
}

bool GetPublicKeyinfo(string &pubkey_info)
{
    string hostname;
    if (!GetHostName(hostname)) {
        WRITE_LOG(LOG_FATAL, "gethostname failed");
        return false;
    }
    string pubkey;
    if (!HdcAuth::TryLoadPublicKey(pubkey)) {
        WRITE_LOG(LOG_FATAL, "load public key failed");
        return false;
    }
    pubkey_info = hostname;
    pubkey_info.append(HDC_HOST_DAEMON_BUF_SEPARATOR);
    pubkey_info.append(pubkey);

    WRITE_LOG(LOG_INFO, "Get pubkey info success");

    return true;
}

#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
bool ReadEncryptKeyFile(const std::string& privateKeyFile, std::vector<uint8_t>& fileData, int needFileLength)
{
    std::string privateKeyKeyFile = privateKeyFile + ".key";
    std::ifstream inFile(privateKeyKeyFile.c_str(), std::ios::binary);
    if (!inFile) {
        WRITE_LOG(LOG_FATAL, "open file %s failed", privateKeyKeyFile.c_str());
        return false;
    }
    fileData.resize(needFileLength);
    inFile.read(reinterpret_cast<char*>(fileData.data()), needFileLength);
    if (inFile.eof() || inFile.fail()) {
        WRITE_LOG(LOG_FATAL, "read file %s failed", privateKeyKeyFile.c_str());
        inFile.close();
        return false;
    }
    inFile.close();
    return true;
}

static uint8_t* GetPlainPwd(const std::string& privateKeyFile)
{
    std::vector<uint8_t> encryptPwd;
    Hdc::HdcPassword pwd(HDC_PRIVATE_KEY_FILE_PWD_KEY_ALIAS);

    if (!ReadEncryptKeyFile(privateKeyFile, encryptPwd, pwd.GetEncryptPwdLength())) {
        return nullptr;
    }
    if (!pwd.DecryptPwd(encryptPwd)) {
        return nullptr;
    }
    std::pair<uint8_t*, int> plainPwd = pwd.GetPassword();
    if (plainPwd.first == nullptr) {
        return nullptr;
    }
    uint8_t *localPwd = new(std::nothrow)uint8_t[plainPwd.second + 1];
    if (localPwd == nullptr) {
        WRITE_LOG(LOG_FATAL, "out of mem %d", plainPwd.second);
        return nullptr;
    }
    memcpy_s(localPwd, plainPwd.second, plainPwd.first, plainPwd.second);
    localPwd[plainPwd.second] = '\0';
    return localPwd;
}
#endif

static bool LoadPrivateKey(const string& prikey_filename, RSA **rsa, EVP_PKEY **evp)
{
    FILE *file_prikey = nullptr;
    bool ret = false;
    *rsa = nullptr;
    *evp = nullptr;
#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
    char *pwd = reinterpret_cast<char*>(GetPlainPwd(prikey_filename));
    if (pwd == nullptr) {
        return false;
    }
#endif
    do {
        file_prikey = Base::Fopen(prikey_filename.c_str(), "r");
        if (!file_prikey) {
            WRITE_LOG(LOG_FATAL, "open file %s failed", prikey_filename.c_str());
            break;
        }
#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
        *evp = PEM_read_PrivateKey(file_prikey, NULL, NULL, pwd);
#else
        *evp = PEM_read_PrivateKey(file_prikey, NULL, NULL, NULL);
#endif
        if (*evp == nullptr) {
            WRITE_LOG(LOG_FATAL, "read prikey from %s failed", prikey_filename.c_str());
            break;
        }
        *rsa = EVP_PKEY_get1_RSA(*evp);
        ret = true;
        WRITE_LOG(LOG_FATAL, "load prikey success");
    } while (0);

#ifdef HDC_SUPPORT_ENCRYPT_PRIVATE_KEY
    memset_s(pwd, strlen(pwd), 0, strlen(pwd));
    delete[] pwd;
#endif
    if (file_prikey) {
        fclose(file_prikey);
        file_prikey = nullptr;
    }
    return ret;
}

static bool MakeRsaSign(EVP_PKEY_CTX *ctx, string &result, unsigned char *digest, int digestLen)
{
    size_t signResultLen = 0;
    int signOutLen = 0;

    // Determine the buffer length
    if (EVP_PKEY_sign(ctx, nullptr, &signResultLen, digest, digestLen) <= 0) {
        WRITE_LOG(LOG_FATAL, "get sign result length failed");
        return false;
    }
    try {
        std::unique_ptr<unsigned char[]> signResult = std::make_unique<unsigned char[]>(signResultLen);
        std::unique_ptr<unsigned char[]> signOut = std::make_unique<unsigned char[]>(signResultLen * 2);
        if (EVP_PKEY_sign(ctx, signResult.get(), &signResultLen, digest, digestLen) <=0) {
            WRITE_LOG(LOG_FATAL, "sign failed");
            return false;
        }
        signOutLen = EVP_EncodeBlock(signOut.get(), signResult.get(), signResultLen);
        result = string(reinterpret_cast<char *>(signOut.get()), signOutLen);
    } catch (std::exception &e) {
        WRITE_LOG(LOG_FATAL, "sign failed for exception %s", e.what());
        return false;
    }

    WRITE_LOG(LOG_INFO, "sign success");
    return true;
}

static bool RsaSign(string &buf, EVP_PKEY *signKey)
{
    unsigned char sha512Hash[SHA512_DIGEST_LENGTH];
    EVP_PKEY_CTX *ctx = nullptr;
    bool signRet = false;

    do {
        ctx = EVP_PKEY_CTX_new(signKey, nullptr);
        if (ctx == nullptr) {
            WRITE_LOG(LOG_FATAL, "EVP_PKEY_CTX_new failed");
            break;
        }
        if (EVP_PKEY_sign_init(ctx) <= 0) {
            WRITE_LOG(LOG_FATAL, "EVP_PKEY_CTX_new failed");
            break;
        }
        if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_PSS_PADDING) <= 0 ||
            EVP_PKEY_CTX_set_rsa_pss_saltlen(ctx, RSA_PSS_SALTLEN_DIGEST) <= 0) {
            WRITE_LOG(LOG_FATAL, "set saltlen or padding failed");
            break;
        }
        if (EVP_PKEY_CTX_set_signature_md(ctx, EVP_sha512()) <= 0) {
            WRITE_LOG(LOG_FATAL, "EVP_PKEY_CTX_set_signature_md failed");
            break;
        }
        SHA512(reinterpret_cast<const unsigned char *>(buf.c_str()), buf.size(), sha512Hash);
        signRet = MakeRsaSign(ctx, buf, sha512Hash, sizeof(sha512Hash));
    } while (0);

    if (ctx != nullptr) {
        EVP_PKEY_CTX_free(ctx);
    }
    return signRet;
}

static bool RsaEncrypt(string &buf, RSA *rsa)
{
    int signOriSize;
    int signOutSize;
    unsigned char signOri[BUF_SIZE_DEFAULT2] = { 0 };
    unsigned char *signOut = nullptr;
    int inSize = buf.size();
    const unsigned char *in = reinterpret_cast<const unsigned char *>(buf.c_str());

    signOriSize = RSA_private_encrypt(inSize, in, signOri, rsa, RSA_PKCS1_PADDING);
    if (signOriSize <= 0) {
        WRITE_LOG(LOG_FATAL, "encrypt failed");
        return false;
    }
    signOut = new(std::nothrow) unsigned char[signOriSize * 2];
    if (signOut == nullptr) {
        WRITE_LOG(LOG_FATAL, "alloc mem failed");
        return false;
    }
    signOutSize = EVP_EncodeBlock(signOut, signOri, signOriSize);
    if (signOutSize <= 0) {
        WRITE_LOG(LOG_FATAL, "encode buf failed");
        delete[] signOut;
        signOut = nullptr;
        return false;
    }

    buf = string(reinterpret_cast<char *>(signOut), signOutSize);
    WRITE_LOG(LOG_INFO, "sign success");
    delete[] signOut;
    signOut = nullptr;

    return true;
}

bool RsaSignAndBase64(string &buf, AuthVerifyType type)
{
    RSA *rsa = nullptr;
    EVP_PKEY *evp = nullptr;
    string prikeyFileName;
    bool signResult = false;

    if (!GetUserKeyPath(prikeyFileName)) {
        WRITE_LOG(LOG_FATAL, "get key path failed");
        return false;
    }
    if (!LoadPrivateKey(prikeyFileName, &rsa, &evp)) {
        WRITE_LOG(LOG_FATAL, "load prikey from file(%s) failed", prikeyFileName.c_str());
        return false;
    }
    if (type == AuthVerifyType::RSA_3072_SHA512) {
        signResult = RsaSign(buf, evp);
    } else {
        signResult = RsaEncrypt(buf, rsa);
    }
    if (rsa != nullptr) {
        RSA_free(rsa);
    }
    if (evp != nullptr) {
        EVP_PKEY_free(evp);
    }
    
    return signResult;
}

int RsaPrikeyDecryptPsk(const unsigned char* in, int inLen, unsigned char* out, int outBufSize)
{
    if (in == nullptr || out == nullptr) {
        WRITE_LOG(LOG_FATAL, "RsaPrikeyDecryptPsk IO buf is alloc failed");
        return -1;
    }
    if (inLen > BUF_SIZE_DEFAULT2 || inLen <= 0) {
        WRITE_LOG(LOG_FATAL, "invalid encryptToken, length is %d", inLen);
        return -1;
    }
    if (outBufSize < PSK_MAX_PSK_LEN) {
        WRITE_LOG(LOG_FATAL, "out buffer is too small");
        return -1;
    }
    RSA *rsa = nullptr;
    EVP_PKEY *evp = nullptr;
    string prikeyFileName;
    int outLen = -1;
    do {
        if (!GetUserKeyPath(prikeyFileName)) {
            WRITE_LOG(LOG_FATAL, "get key path failed");
            break;
        }
        if (!LoadPrivateKey(prikeyFileName, &rsa, &evp)) {
            WRITE_LOG(LOG_FATAL, "load prikey from file(%s) failed", prikeyFileName.c_str());
            break;
        }
        unsigned char tokenDecode[BUF_SIZE_DEFAULT] = { 0 };
        int tbytes = EVP_DecodeBlock(tokenDecode, in, inLen);
        if (tbytes <= 0) {
            WRITE_LOG(LOG_FATAL, "base64 decode PreShared Key failed");
            break;
        }
        outLen = RSA_private_decrypt(tbytes, tokenDecode, out, rsa, RSA_PKCS1_OAEP_PADDING);
        if (outLen < 0) {
            WRITE_LOG(LOG_FATAL, "RSA_private_decrypt failed(%lu)", ERR_get_error());
            break;
        }
    } while (0);
    if (rsa != nullptr) {
        RSA_free(rsa);
    }
    if (evp != nullptr) {
        EVP_PKEY_free(evp);
    }
    return outLen;
}

#else // DAEMON
int RsaPubkeyEncryptPsk(const unsigned char* in, int inLen, unsigned char* out, int outBufSize, const string& pubkey)
{
    if (in == nullptr || out == nullptr) {
        WRITE_LOG(LOG_FATAL, "RsaPubkeyEncryptPsk IO buf is alloc failed");
        return -1;
    }
    BIO *bio = nullptr;
    RSA *rsa = nullptr;
    int outLen = -1;
    do {
        bio = BIO_new(BIO_s_mem());
        if (bio == nullptr) {
            WRITE_LOG(LOG_FATAL, "RsaPubkeyEncryptPsk create bio failed");
            break;
        }
        int wbytes = BIO_write(bio, reinterpret_cast<const unsigned char *>(pubkey.c_str()), pubkey.length());
        if (wbytes <= 0) {
            WRITE_LOG(LOG_FATAL, "RsaPubkeyEncryptPsk bio write failed %d ", wbytes);
            break;
        }
        rsa = PEM_read_bio_RSA_PUBKEY(bio, nullptr, nullptr, nullptr);
        if (rsa == nullptr) {
            WRITE_LOG(LOG_FATAL, "RsaPubkeyEncryptPsk rsa failed");
            break;
        }
        unsigned char encryptedBuf[BUF_SIZE_DEFAULT2] = { 0 };
        int encryptedBufSize = RSA_public_encrypt(inLen, in, encryptedBuf, rsa, RSA_PKCS1_OAEP_PADDING);
        if (encryptedBufSize <= 0 || (outBufSize < ((encryptedBufSize + 2) / 3 * 4))) { // (x+2)/3*4 base64 encode size
            WRITE_LOG(LOG_FATAL, "encrypt PreShared Key failed, encryptedBufSize: %d", encryptedBufSize);
            break;
        }
        outLen = EVP_EncodeBlock(out, encryptedBuf, encryptedBufSize);
        if (outLen <= 0) {
            WRITE_LOG(LOG_FATAL, "base64 encode PreShared Key failed");
            break;
        }
    } while (0);

    if (bio != nullptr) {
        BIO_free(bio);
    }
    if (rsa != nullptr) {
        RSA_free(rsa);
    }
    return outLen;
}
#endif // HDC_HOST
}
