import 'dart:io';

import 'package:archive/archive.dart';

extractSpecificFileFromZip(
  String zipFilePath,
  String fileNameToExtract,
  String outputDirectory,
) async {
  var bytes = File(zipFilePath).readAsBytesSync();

  var archive = ZipDecoder().decodeBytes(bytes);
  print('extractSpecificFileFromZip: ${zipFilePath} ${bytes.length}');
  for (var file in archive) {
    print('zip extracted: ${file.name}');
    if (file.name == fileNameToExtract) {
      var outputFile = File(outputDirectory);
      await outputFile.writeAsBytes(file.content, flush: true);
    }
  }
}
