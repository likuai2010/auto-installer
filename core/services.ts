
class EnvStep{
    name: string
    finish: boolean
    error?: string
    progress: string = ""
}

class EnvInfo{
    steps:EnvStep[]
    
}
class AccountStep{
    name: string
    value: string = ""
    finish: boolean
    error?: string
}

class AccountInfo{
    steps: AccountStep[]
}

class buildStep{
    name: string
    value: string = ""
    finish: boolean
    error?: string
}

class buildInfo{
    steps: buildStep[]
}

export class CoreService {
    envInfo: EnvInfo =  {
        steps: [
            {name:"安装docker", finish: false, progress:''},
            {name:"命令行工具", finish: false, progress:''}
        ],
    }

    accountInfo: AccountInfo =  {
        steps: [
            { name: "登陆华为账号", finish: false, value:''},
            { name: "ClientID", finish: false, value:'' },
            { name: "ClientKey", finish: false, value:'' },
            { name: "创建应用", finish: false, value:'' },
        ]
    }
    buildInfo: buildInfo =  {
        steps: [
            { name: "构建应用", finish: false, value:''},
            { name: "上传应用", finish: false, value:'' },
            { name: "发布版本", finish: false, value:'' },
            { name: "版本审核", finish: false, value:'' },
        ]
    }

    getEnvInfo(): EnvInfo{
        return this.envInfo;
    }
    getAccountInfo(): AccountInfo{
        return this.accountInfo;
    }
    getBuildInfo(){
        return this.buildInfo;
    }
}