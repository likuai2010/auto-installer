import 'dart:io';

import 'package:archive/archive.dart';

extractSpecificFileFromZip(
  String zipFilePath,
  String fileNameToExtract,
  String outputDirectory,
) async {
  // 读取ZIP文件
  var bytes = File(zipFilePath).readAsBytesSync();

  // 解压缩ZIP文件
  var archive = ZipDecoder().decodeBytes(bytes);
  print('extractSpecificFileFromZip: ${zipFilePath} ${bytes.length}');
  // 遍历解压后的文件
  for (var file in archive) {
    print('zip extracted: ${file.name}');
    if (file.name == fileNameToExtract) {
      // 保存解压出来的文件
      var outputFile = File(outputDirectory);
      await outputFile.writeAsBytes(file.content, flush: true);
    }
  }
}
