#!/bin/bash

export hapPath=./unsigned.hap
export certPath=./xiaobai-debug.cer
export profilePath=./xiaobai-debug_org_ohosdev_anime.p7b
export keystoreFile=../../assets/store/xiaobai.p12
export keystorePwd=xiaobai123
export outFile=./signed.hap


./signtool.exe sign-app -mode localSign -keyAlias xiaobai -appCertFile ${certPath} -profileFile ${profilePath} -inFile ${hapPath} -signAlg "SHA256withECDSA" -keystoreFile ${keystoreFile} -keystorePwd ${keystorePwd} -keyPwd ${keystorePwd} -outFile ${outFile} -signCode 1


./signtool.exe sign-app -mode localSign -keyAlias xiaobai -appCertFile ./xiaobai-debug.cer -profileFile ./xiaobai-debug_org_ohosdev_anime.p7b -inFile ./unsigned.hap -signAlg "SHA256withECDSA" -keystoreFile ../../assets/store/xiaobai.p12 -keystorePwd xiaobai123-keyPwd xiaobai123 -outFile ./signed.hap -signCode 1