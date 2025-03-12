
#include "params_run_tool.h"
#include "hap_signer_tool.h"
#include "contrib/minizip/unzip.h"

using namespace OHOS::SignatureTools;


extern "C" int sign_hap(int argc, char *args[])
{
    return ParamsRunTool::ProcessCmd((char **)args, argc) ? 0 : -1;
}


const char *unzip(const char *source, const char *fileName, const char *destination)
{
    unzFile zipfile = unzOpen(source);
    std::string message = "";

    if (zipfile == NULL)
    {
        message = message + "无法打开 ZIP 文件: " + source;
        return message.c_str();
    }

    if (unzLocateFile(zipfile, fileName, 1) != UNZ_OK)
    {
        unzClose(zipfile);
        message = message + "未找到文件: " + destination;
        return message.c_str();
    }
    if (unzOpenCurrentFile(zipfile) != UNZ_OK)
    {
        message = message + "无法打开文件: " + destination;
        unzClose(zipfile);
        return message.c_str();
    }
    FILE *dest_file = fopen(destination, "wb");
    if (dest_file == NULL)
    {
        printf("无法创建目标文件: %s\n", destination);
        message = message + "无法创建目标文件: " + destination;
        unzCloseCurrentFile(zipfile);
        unzClose(zipfile);
        return message.c_str();
    }
    // 从 ZIP 文件中读取数据并写入目标文件
    char buffer[4096];
    int bytes_read;
    while ((bytes_read = unzReadCurrentFile(zipfile, buffer, sizeof(buffer))) > 0)
    {
        fwrite(buffer, 1, bytes_read, dest_file);
    }
    fclose(dest_file);
    unzCloseCurrentFile(zipfile);
    unzClose(zipfile);
    return "提取成功";
}
