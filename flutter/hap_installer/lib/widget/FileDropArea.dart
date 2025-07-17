

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileDropArea extends StatefulWidget {
  final ValueChanged<PlatformFile> onSearch;
  final Widget child;
  const FileDropArea({Key? key, required this.child, required this.onSearch}) : super(key: key);

  @override
  _FileDropAreaState createState() => _FileDropAreaState();
}


class _FileDropAreaState extends State<FileDropArea> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) async {
        var file = details.files.first;
        widget.onSearch(PlatformFile(path: file.path, name: file.name, size: 0));
        setState(() async {
          _dragging = false;
        });
      },
      onDragEntered: (details) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (details) {
        setState(() {
          _dragging = false;
        });
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          widget.child,
          _dragging ? const Text('在此处释放文件'): Container()
        ],
      ),
    );
  }
}

