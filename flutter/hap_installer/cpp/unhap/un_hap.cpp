
#include "contrib/minizip/unzip.h"
#include <string>

// int main(int argc, char **args)
// {
//     return 0;
// }

int _extractFile(unzFile zipfile, const char *destPath)
{
    if (unzOpenCurrentFile(zipfile) != UNZ_OK)
    {
        unzClose(zipfile);
        return 102;
    }
    FILE *dest_file = fopen(destPath, "wb");
    if (dest_file == NULL)
    {
        unzCloseCurrentFile(zipfile);
        unzClose(zipfile);
        return 103;
    }

    // 读取文件内容并写入目标文件
    char buffer[8192];
    int bytes_read;
    while ((bytes_read = unzReadCurrentFile(zipfile, buffer, sizeof(buffer))) > 0)
    {
        fwrite(buffer, 1, bytes_read, dest_file);
    }
    fclose(dest_file);
    unzCloseCurrentFile(zipfile);
    return 0;
}

extern "C" int extractFileByHap(const char *source, const char *fileName, const char *destination)
{
    unzFile zipfile = unzOpen(source);
    std::string message = "";

    if (zipfile == NULL)
    {
        return 100;
    }
    if (unzLocateFile(zipfile, fileName, 1) != UNZ_OK)
    {
        unzClose(zipfile);
        return 101;
    }
    int ret = _extractFile(zipfile, destination);
    unzClose(zipfile);
    return ret;
}

// 解压 ZIP 文件中的所有文件
extern "C" int unzipByApp(const char *zipFilePath, const char *outputDir)
{
    unzFile zipFile = unzOpen(zipFilePath);
    if (zipFile == NULL)
    {
        return 100;
    }

    int err = unzGoToFirstFile(zipFile);
    if (err != UNZ_OK)
    {
        unzClose(zipFile);
        return err;
    }
    do
    {
        // 获取当前文件信息
        char filename[256];
        unz_file_info fileInfo;
        err = unzGetCurrentFileInfo(zipFile, &fileInfo, filename, sizeof(filename), nullptr, 0, nullptr, 0);
        if (err != UNZ_OK)
        {
            continue;
        }
        // 拼接目标路径
        std::string destPath = std::string(outputDir) + "/" + filename;
        err = _extractFile(zipFile, destPath.c_str());

    } while (unzGoToNextFile(zipFile) == UNZ_OK);

    unzClose(zipFile);
    return 0;
}