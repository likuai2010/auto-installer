const { app } = require('electron');
const path = require('node:path')
const fs = require('node:fs')
const https = require('https');
class DownloadHelper{
    downloadAndInstallFile(mainWindow, fileUrl) {
        const filePath = path.join(app.getPath('downloads'), 'installer.exe');
        const file = fs.createWriteStream(filePath);
        https.get(fileUrl, (response) => {
            const totalBytes = parseInt(response.headers['content-length'], 10);
            let downloadedBytes = 0;
            response.pipe(file);
            response.on('data', (chunk) => {
                downloadedBytes += chunk.length;
                const progress = downloadedBytes / totalBytes;
                // 更新窗口任务栏进度
                mainWindow.setProgressBar(progress);
                // 发送进度更新到渲染进程
                mainWindow.webContents.send('download-progress', progress);
            });
    
            file.on('finish', () => {
                file.close();
                mainWindow.setProgressBar(-1);  // 清除任务栏进度条
                console.log('Download completed');
                //
            });
        }).on('error', (err) => {
            fs.unlink(filePath, () => {}); // 删除不完整的文件
            console.error('Download failed', err.message);
        });
    }
    installFile(filePath) {
        const { exec } = require('child_process');
        
        exec(filePath, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error executing file: ${error}`);
                return;
            }
            console.log(`Output: ${stdout}`);
            console.error(`Error: ${stderr}`);
        });
    }
}

module.exports = { DownloadHelper }