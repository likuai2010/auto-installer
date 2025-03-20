
#include "params_run_tool.h"
#include "hap_signer_tool.h"
#include "contrib/minizip/unzip.h"

using namespace OHOS::SignatureTools;


extern "C" int sign_hap(int argc, char *args[])
{
    return ParamsRunTool::ProcessCmd((char **)args, argc) ? 0 : -1;
}

int unzip(const char *source, const char *fileName, const char *destination)
{
    unzFile zipfile = unzOpen(source);
    std::string message = "";

    if (zipfile == NULL)
    {
        message = message + "无法打开 ZIP 文件: " + source;
        printf(message.c_str());
        return 100;
    }

    if (unzLocateFile(zipfile, fileName, 1) != UNZ_OK)
    {
        unzClose(zipfile);
        message = message + "未找到文件: " + destination;
        printf(message.c_str());
        return 101;
    }
    if (unzOpenCurrentFile(zipfile) != UNZ_OK)
    {
        message = message + "无法打开文件: " + destination;
        printf(message.c_str());
        unzClose(zipfile);
        return 102;
    }
    FILE *dest_file = fopen(destination, "wb");
    if (dest_file == NULL)
    {
        printf("无法创建目标文件: %s\n", destination);
        unzCloseCurrentFile(zipfile);
        unzClose(zipfile);
        return 103;
    }
    char buffer[4096];
    int bytes_read;
    while ((bytes_read = unzReadCurrentFile(zipfile, buffer, sizeof(buffer))) > 0)
    {
        fwrite(buffer, 1, bytes_read, dest_file);
    }
    fclose(dest_file);
    unzCloseCurrentFile(zipfile);
    unzClose(zipfile);
    return 0;
}
