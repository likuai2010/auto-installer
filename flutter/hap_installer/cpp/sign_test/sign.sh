#!/bin/bash

export hapPath=./unsigned.hap
export certPath=./xiaobai-debug.cer
export profilePath=./xiaobai-debug_org_ohosdev_anime.p7b
export keystoreFile=../../assets/store/xiaobai.p12
export keystorePwd=xiaobai123
export outFile=./signed.hap

./signtool sign-app -mode localSign -keyAlias xiaobai -appCertFile ${certPath} -profileFile ${profilePath} -inFile ${hapPath} -signAlg SHA256withECDSA -keystoreFile ${keystoreFile} -keystorePwd ${keystorePwd} -keyPwd ${keystorePwd} -outFile ${outFile} -signCode 1