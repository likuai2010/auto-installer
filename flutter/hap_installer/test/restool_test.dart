import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hap_installer/viewmodels/restool.dart';

void main() {
  group('ResourceItem values', () {
    final cases = <(String, List<int>, String)>[
      ('empty data', [], ''),
      ('only a NUL terminator', [0], ''),
      ('UTF-8 text', utf8.encode('应用名称'), '应用名称'),
      ('NUL-terminated text', [...utf8.encode('Harmony X'), 0], 'Harmony X'),
    ];

    for (final (description, bytes, expected) in cases) {
      test(description, () {
        final item = ResourceItem();
        item.SetData(InputMemoryStream(bytes), bytes.length);
        expect(item.getValueString(), expected);
      });
    }
  });

  for (final legacy in [true, false]) {
    test('${legacy ? 'legacy' : 'V2'} table preserves an empty string resource',
        () {
      final resources = ResourceTable.LoadResTable(
        InputMemoryStream(_emptyStringIndex(legacy: legacy)),
      );

      expect(resources.keys, [0x01000cc8]);
      final item = resources[0x01000cc8]!.single;
      expect(item.name, 'xsettings_x_data_desc');
      expect(item.type, ResType.STRING);
      expect(item.getValueString(), '');
    });
  }
}

// A minimal resources.index containing the empty string that triggered the crash.
List<int> _emptyStringIndex({required bool legacy}) {
  const id = 0x01000cc8;
  final name = utf8.encode('xsettings_x_data_desc');
  final output = OutputMemoryStream();
  final version = utf8.encode(legacy ? 'Restool 1.0' : 'RestoolV2 6.1.0.003');
  output.writeBytes([...version, ...List.filled(128 - version.length, 0)]);

  if (legacy) {
    const idSetOffset = 136 + 12;
    const recordOffset = idSetOffset + 8 + 8;
    final recordSize = 12 + 2 + 2 + name.length;
    output.writeUint32(recordOffset + recordSize);
    output.writeUint32(1);
    output.writeBytes(ascii.encode('KEYS'));
    output.writeUint32(idSetOffset);
    output.writeUint32(0);
    output.writeBytes(ascii.encode('IDSS'));
    output.writeUint32(1);
    output.writeUint32(id);
    output.writeUint32(recordOffset);
    output.writeUint32(recordSize);
    output.writeUint32(ResType.STRING.value);
    output.writeUint32(id);
    output.writeUint16(0);
    output.writeUint16(name.length);
    output.writeBytes(name);
  } else {
    final idSetSize = 16 + 12 + 12 + name.length;
    final resourceOffset = 140 + 12 + idSetSize;
    final dataOffset = resourceOffset + 20;
    output.writeUint32(dataOffset + 2);
    output.writeUint32(1);
    output.writeUint32(dataOffset);
    output.writeBytes(ascii.encode('KEYS'));
    output.writeUint32(0);
    output.writeUint32(0);
    output.writeBytes(ascii.encode('IDSS'));
    output.writeUint32(idSetSize);
    output.writeUint32(1);
    output.writeUint32(1);
    output.writeUint32(ResType.STRING.value);
    output.writeUint32(12 + 12 + name.length);
    output.writeUint32(1);
    output.writeUint32(id);
    output.writeUint32(resourceOffset);
    output.writeUint32(name.length);
    output.writeBytes(name);
    output.writeUint32(id);
    output.writeUint32(20);
    output.writeUint32(1);
    output.writeUint32(0);
    output.writeUint32(dataOffset);
    output.writeUint16(0);
  }
  return output.getBytes();
}
