import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:process_run/stdio.dart';

class DownloadDialog extends StatefulWidget {
  DownloadDialog({required this.javaPath});
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
    if(Platform.isLinux){
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
        
        final savePath = File("${widget.javaPath}$file");
        setState(() {
          _progress = null;
          _status = "安装中...";
        });
        await extractFileToDisk(
          savePath.path,
          savePath.parent.path,
          callback: (_) {},
        );
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
        "https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jre/x64/windows/OpenJDK17U-jre_x64_windows_hotspot_17.0.14_7.zip"; 
    if (Platform.isLinux) {
        url = "https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jre/x64/linux/OpenJDK17U-jre_x64_linux_hotspot_17.0.14_7.tar.gz"; 
    }
   
    try {
      Dio dio = Dio();
      await dio.download(
        url,
        savePath.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
              _status = "下载中... ${((_progress!) * 100).toStringAsFixed(0)}%";
            });
          }
        },
      );

      setState(() {
        _status = "下载完成";
      });

      // 下载完成后可以提示用户或进行其他操作
    } catch (e) {
      setState(() {
        _status = "下载失败!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("安装java环境"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: _progress),
          SizedBox(height: 10),
          Text(_status),
        ],
      ),
      actions: <Widget>[
        installButton(),
        TextButton(
          child: Text("取消"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
