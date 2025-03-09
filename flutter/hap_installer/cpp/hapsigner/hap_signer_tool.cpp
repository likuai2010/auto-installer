
#include "params_run_tool.h"
#include "hap_signer_tool.h"
#include "contrib/minizip/unzip.h"

using namespace OHOS::SignatureTools;

static const char **split(char *input, int &size)
{
    std::vector<const char *> params;
    char *temp = strtok(input, " ");
    while (temp != nullptr)
    {
        params.push_back(temp);
        temp = strtok(nullptr, " ");
    }
    size = params.size();
    const char **paramsArray = new const char *[params.size() + 1]; // +1 为了存储 nullptr
    for (size_t i = 0; i < params.size(); ++i)
    {
        paramsArray[i] = const_cast<char *>(params[i]); // 转换 const char* 为 char*
    }
    return paramsArray;
}
bool signHap(char *params)
{
    int count;
    const char **params = split(params, count);
    return ParamsRunTool::ProcessCmd((char **)params, count) ? 0 : -1;
}
void unzip(const char *source, const char *fileName, const char *destination)
{
    unzFile zipfile = unzOpen(source);
    if (zipfile == NULL)
    {
        printf("无法打开 ZIP 文件: %s\n", source);
        return;
    }

    if (unzLocateFile(zipfile, fileName, 1) != UNZ_OK)
    {
        printf("未找到文件: %s\n", destination);
        unzClose(zipfile);
        return;
    }
    if (unzOpenCurrentFile(zipfile) != UNZ_OK)
    {
        printf("无法打开文件: %s\n", destination);
        unzClose(zipfile);
        return;
    }
    FILE *dest_file = fopen(destination, "wb");
    if (dest_file == NULL)
    {
        printf("无法创建目标文件: %s\n", destination);
        unzCloseCurrentFile(zipfile);
        unzClose(zipfile);
        return;
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
    printf("成功提取: %s\n", destination);
}
