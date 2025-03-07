#!/bin/bash

export hapPath=/Users/fiber/Documents/unsigned.hap
export certPath=/Users/fiber/Documents/xiaobai-debug.cer
export profilePath=/Users/fiber/Documents/xiaobai-debug_org_ohosdev_anime.p7b
export keystoreFile=/Users/fiber/DevEcoStudioProjects/autoInstaller/entry/src/main/resources/resfile/store/xiaobai.p12
export keystorePwd=xiaobai123
export outFile=./signed.hap
./signtool sign-app -mode localSign -keyAlias xiaobai -appCertFile ${certPath} -profileFile ${profilePath} -inFile ${hapPath} -signAlg SHA256withECDSA -keystoreFile ${keystoreFile} -keystorePwd ${keystorePwd} -keyPwd ${keystorePwd} -outFile ${outFile} -signCode 1