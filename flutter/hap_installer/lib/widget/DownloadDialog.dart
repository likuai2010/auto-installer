import 'dart:io';

import 'package:flutter/material.dart';

import 'package:archive/archive_io.dart';
import 'package:hap_installer/hdc/common.dart';

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({super.key, required this.javaPath});
  final String javaPath;
  @override
  _DownloadDialogState createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  double? _progress = 0.0;
  String _status = "开始下载...";
  String file = ".zip";
  @override
  void initState() {
    super.initState();
    if (Platform.isLinux) {
      file = ".tar.gz";
    }
    _downloadJRE();
  }

  Widget installButton() {
    if (_progress != 1) {
      return Container();
    }
    return TextButton(
      onPressed: () async {
      
        setState(() {
          _progress = null;
          _status = "安装中...";
        });
        final savePath = File("${widget.javaPath}$file");
        await extractFileToDisk(savePath.path, savePath.parent.path);
        setState(() {
          _progress = 1;
          _status = "安装完成";
        });
        Navigator.pop(context);
      },
      child: Text("安装"),
    );
  }

  Future<void> _downloadJRE() async {
    final savePath = File("${widget.javaPath}$file");
    if (await savePath.exists()) {
      setState(() {
        _progress = 1;
        _status = "下载完成";
      });
      return;
    }
    String url =
        "https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jre/x64/windows/OpenJDK17U-jre_x64_windows_hotspot_${JavaVersion}.zip";
    if (Platform.isLinux) {
      url =
          "https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jre/x64/linux/OpenJDK17U-jre_x64_linux_hotspot_${JavaVersion}.tar.gz";
    }

    try {
      await download(url, savePath.path, (received, total) {
        if (total != -1) {
          setState(() {
            _progress = received / total;
            _status = "下载中... ${((_progress!) * 100).toStringAsFixed(0)}%";
          });
        }
      });
      setState(() {
        _status = "下载完成";
      });
    } catch (e) {
      setState(() {
        _status = "下载失败: $e";
      });
    }
  }

  download(
    String url,
    String filePath,
    Function(int received, int total) onReceiveProgress,
  ) async {
    final httpClient = HttpClient();
    final uri = Uri.parse(url);
    final request = await httpClient.openUrl("GET", uri);
    final response = await request.close();
    final contentLength = response.contentLength;
    int receivedLength = 0;
    final bytes = <int>[];
    await for (var data in response) {
      bytes.addAll(data);
      receivedLength += data.length;
      if (contentLength != -1) {
        onReceiveProgress(receivedLength, contentLength);
      }
    }
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("安装java环境"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: _progress),
          const SizedBox(height: 10),
          Text(_status),
        ],
      ),
      actions: <Widget>[
        installButton(),
        TextButton(
          child: const Text("取消"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
