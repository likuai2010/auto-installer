
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:hap_installer/hdc/CmdService.dart';
import 'package:hap_installer/models/HapInfo.dart';
import 'package:hap_installer/models/ModuleInfo.dart';

enum ResType {
  ELEMENT(0),
  RAW(6),
  INTEGER(8),
  STRING(9),
  STRARRAY(10),
  INTARRAY(11),
  BOOLEAN(12),
  COLOR(14),
  ID(15),
  THEME(16),
  PLURAL(17),
  FLOAT(18),
  MEDIA(19),
  PROF(20),
  PATTERN(22),
  SYMBOL(23),
  RES(24),
  INVALID_RES_TYPE(-1);

  final int value;
  const ResType(this.value);
}

const Map<int, String> gResTypStringMap = {
  0: "element",
  6: "raw",
  8: "integer",
  9: "string",
  10: "strarray",
  11: "intarray",
  12: "boolean",
  14: "color",
  15: "id",
  16: "theme",
  17: "plural",
  18: "float",
  19: "media",
  20: "prof",
  22: "pattern",
  23: "symbol",
  24: "res",
  -1: "invalid_res_type",
};
const Map<int, ResType> gResTypeMap = {
  0: ResType.ELEMENT,
  6: ResType.RAW,
  8: ResType.INTEGER,
  9: ResType.STRING,
  10: ResType.STRARRAY,
  11: ResType.INTARRAY,
  12: ResType.BOOLEAN,
  14: ResType.COLOR,
  15: ResType.ID,
  16: ResType.THEME,
  17: ResType.PLURAL,
  18: ResType.FLOAT,
  19: ResType.MEDIA,
  20: ResType.PROF,
  22: ResType.PATTERN,
  23: ResType.SYMBOL,
  24: ResType.RES,
  -1: ResType.INVALID_RES_TYPE,
};


enum KeyType {
  LANGUAGE(0),
  REGION(1),
  RESOLUTION(2),
  ORIENTATION(3),
  DEVICETYPE(4),
  SCRIPT(5),
  NIGHTMODE(6),
  MCC(7),
  MNC(8),
  // RESERVER 9 在 C++ 中可能被跳过，但 Dart 中需要明确处理
  INPUTDEVICE(10),
  KEY_TYPE_MAX(11),  // 基于前面的值 +1
  OTHER(12);         // 可以自定义一个值

  final int value;
  const KeyType(this.value);
  
  // 获取所有值（排除 KEY_TYPE_MAX 如果需要）
  static List<KeyType> get validValues => 
      values.where((type) => type != KeyType.KEY_TYPE_MAX).toList();
  
  // 根据整数值获取枚举
  static KeyType fromValue(int value) {
    try {
      return values.firstWhere((type) => type.value == value);
    } catch (e) {
      return KeyType.OTHER;
    }
  }
}


enum DeviceType {
  PHONE(0),
  TABLET(1),
  CAR(2),
  // RESERVER 3 被跳过
  TV(4),
  WEARABLE(6),
  TWOINONE(7);

  final int value;
  const DeviceType(this.value);
  
  // 根据整数值获取枚举
  static DeviceType? fromValue(int value) {
    try {
      return values.firstWhere((type) => type.value == value);
    } catch (e) {
      return null;
    }
  }
  
  // 获取所有有效值的列表（按原始顺序）
  static List<DeviceType> get validValues => values;
  
  // 检查值是否有效
  static bool isValidValue(int value) {
    return values.any((type) => type.value == value);
  }
}


class LimitKeyConfig {
    static const int KEY_CONFIG_HEADER_LEN =  12;
    static const int KEY_TAG_LEN = 4;
    String keyTag = "keys";
    int offset = 0;
    int keyCount = 0;
    static LimitKeyConfig formInputStream(InputStream input){
      final header = LimitKeyConfig();
      header.keyTag = input.readString(size: KEY_TAG_LEN);
      if (header.keyTag != "KEYS") {
        throw Exception("invalid key tag = " + header.keyTag);
      }
      header.offset = input.readUint32();
      header.keyCount = input.readUint32();
      return header;
    }
}
class KeyParam {
    static const int KEY_PARAM_LEN = 8;
    late KeyType keyType;
    late int value;
    static KeyParam formInputStream(InputStream input){
      final header = KeyParam();
      header.keyType = KeyType.fromValue(input.readUint32());
      header.value = input.readUint32();
      return header;
    }
}
class IndexHeader {
    static const int VERSION_MAX_LEN = 128; // 假设版本号最大长度
    static const int STRUCT_SIZE = VERSION_MAX_LEN + 4 + 4; 
    late String version;  // 版本号字节数组
    late int fileSize;        // 文件大小 (uint32_t)
    late int limitKeyConfigSize; // 限制键配置大小 (uint32_t)

    static IndexHeader formInputStream(InputStream input){
      final header = IndexHeader();
      header.version = input.readString(size: IndexHeader.VERSION_MAX_LEN);
      header.fileSize = input.readUint32();
      header.limitKeyConfigSize = input.readUint32();
      return header;
    }
}
class RecordItem {
  late int size;
  late int resType;
  late int id;
  static RecordItem formInputStream(InputStream input){
    final header = RecordItem();
    header.size = input.readUint32();
    header.resType = input.readUint32();
    header.id = input.readUint32();
    return header;
  }
}

class IdSet {
  String idTag = 'IDSS';
  int idCount = 0;
  late Map<int, int> data; // pair id and offset
  static IdSet formInputStream(InputStream input){
    final header = IdSet();
    header.idTag = input.readString(size: 4);
    if (header.idTag != "IDSS") {
      throw Exception("invalid id tag =" + header.idTag);
    }
    header.idCount = input.readUint32();
    return header;
  }
}



class IndexHeaderV2 {
  static const int VERSION_MAX_LEN = 128; // 假设版本号最大长度
  static const int INDEX_HEADER_LEN = VERSION_MAX_LEN + 12;
  late String version;  // 版本号字节数组
  int length = 0;
  int keyCount = 0;
  int dataBlockOffset = 0;
  Map<String, KeyConfig> keyConfigs = {}; // <resConfig, KeyConfig>
  Map<int, KeyConfig> idKeyConfigs = {}; // <configId, KeyConfig>
  static IndexHeaderV2 formInputStream(InputStream input){
    var header = IndexHeaderV2();
    header.version = input.readString(size: IndexHeaderV2.VERSION_MAX_LEN);
    header.length = input.readUint32();
    header.keyCount = input.readUint32();
    header.dataBlockOffset = input.readUint32();  
    return header;
  }
}

class IdSetHeader{
  static const int ID_SET_HEADER_LEN = 16;
  String idTag = 'IDSS';
  int length = 0;
  int typeCount = 0;
  int idCount = 0;
  Map<ResType, ResTypeHeader> resTypes = {};
  static IdSetHeader formInputStream(InputStream input){
    var header = IdSetHeader();
    header.idTag = input.readString(size: 4);
    if (header.idTag != "IDSS") {
      throw Exception("invalid id tag =" + header.idTag);
    }
    header.length = input.readUint32();
    header.typeCount = input.readUint32();
    header.idCount = input.readUint32();
    return header;
  }
}

class KeyConfig {
    static const int KEY_CONFIG_HEADER_LEN = 12;
    String keyTag = "KEYS";
    int configId = 0;
    int keyCount = 0;
    List<KeyParam> configs = [];
}

class ResIndex {
    static const int RES_INDEX_LEN = 12;
    int resId = 0;
    int offset = 0;
    int length = 0;
    String name = '';
}
class ResInfo{
    static const int RES_INFO_LEN = 12;
    static const int DATA_OFFSET_LEN = 8;
    int resId = 0;
    int length = 0;
    int valueCount = 0;
    Map<int, int> dataOffset = {}; // <resConfigId, offset>
}
class ResTypeHeader {
    static const int RES_TYPE_HEADER_LEN = 12;
    late ResType resType;
    int length = 0;
    int count = 0;
    Map<int, ResIndex> resIndexs = {}; // <resId, resIndex>
}





class ResourceTable{

  static IndexHeaderV2 ReadNewFileHeader(InputStream input, int pos, int length){
      pos += IndexHeader.STRUCT_SIZE;
      if (pos > length) {
        throw Exception("header length error");
      }
      var indexHeader = IndexHeaderV2.formInputStream(input);
    for (var key = 0; key < indexHeader.keyCount; key++) {
          pos += KeyConfig.KEY_CONFIG_HEADER_LEN;
          if (pos > length) {
              throw Exception("KeyConfig header length error");
          }
          var keyConfig  = KeyConfig();
          keyConfig.keyTag = input.readString(size: 4);
          keyConfig.configId = input.readUint32();
          keyConfig.keyCount = input.readUint32();  

          for (var keyType = 0; keyType < keyConfig.keyCount; keyType++) {
              pos += KeyParam.KEY_PARAM_LEN;
              if (pos > length) {
                 throw Exception("KeyParam length error");
              }
              var keyParam = KeyParam();
              keyParam.keyType = KeyType.fromValue(input.readUint32());
              keyParam.value = input.readUint32();
              keyConfig.configs.add(keyParam);
          }
          indexHeader.idKeyConfigs[keyConfig.configId] = keyConfig;
      }
      return indexHeader;
  }
  static IdSetHeader ReadIdSetHeader(InputStream input, int pos, int length){
      pos += IdSetHeader.ID_SET_HEADER_LEN;
      if (pos > length) {
        throw Exception("header length error");
      }
      var idSetHeader = IdSetHeader.formInputStream(input);
      for (var resType = 0; resType < idSetHeader.typeCount; resType++) {
         pos += ResTypeHeader.RES_TYPE_HEADER_LEN;
        if (pos > length) {
            throw Exception("ResType header length error");
        }
        var resTypeHeader =  ResTypeHeader();
        resTypeHeader.resType = gResTypeMap[input.readUint32()] ?? ResType.INVALID_RES_TYPE;
        resTypeHeader.length = input.readUint32();
        resTypeHeader.count = input.readUint32();
        for (var resId = 0; resId < resTypeHeader.count; resId++) {
            pos += ResIndex.RES_INDEX_LEN;
            if (pos > length) {
               throw  Exception("ResIndex length error");
            }
            var resIndex = ResIndex();
            resIndex.resId = input.readUint32();
            resIndex.offset = input.readUint32();
            resIndex.length = input.readUint32();
            pos += resIndex.length;
            if (pos > length) {
                throw Exception("resource name length error");
            }
            resIndex.name = input.readString(size: resIndex.length);
            resTypeHeader.resIndexs[resIndex.resId] = resIndex;
        }
        idSetHeader.resTypes[resTypeHeader.resType] = resTypeHeader;
      }
      return idSetHeader;
  }

  static IndexHeader ReadFileHeader(InputStream input, int pos, int length){
      pos += IndexHeader.STRUCT_SIZE;
      if (pos > length) {
        throw Exception("header length error");
      }
      return IndexHeader.formInputStream(input);
  }
  static bool IsNewModule(IndexHeader indexHeader)
  {
      final version = indexHeader.version;
      if (version.substring(0, version.indexOf(" ")) == "Restool") {
          return false;
      }
      return true;
  }
  static Map<int, List<ResourceItem>> LoadNewResTable(InputStream input){
    var pos = 0;
    input.position = pos;
    final length = input.length;
    final header = ReadNewFileHeader(input, pos, length);
    final idSetHeader = ReadIdSetHeader(input, pos, length);
    var resInfos = Map<int, List<ResourceItem>>();
    for (var resType in idSetHeader.resTypes.entries){
      for (var resIndex in resType.value.resIndexs.entries) {
       ReadResources(input, resIndex.value, resType.value, header, length, resInfos);
      }
    }
    return resInfos;
  }
  static ReadResources(
    InputStream input, 
    ResIndex resIndex,
    ResTypeHeader resTypeHeader, 
    IndexHeaderV2 indexHeader,
    int length,
    Map<int, List<ResourceItem>> resInfos)
  {
    var resInfo = ReadResInfo(input, resIndex.offset, length);
    var pos = resIndex.offset + ResInfo.RES_INFO_LEN;
    for (var resConfig = 0; resConfig < resInfo.valueCount; resConfig++) {
      var (resConfigId, dataOffset) = ReadResConfig(input, pos, length);
      var resouceItem = ResourceItem();
      resouceItem.name = resIndex.name;
      resouceItem.keyparams = indexHeader.idKeyConfigs[resConfigId]?.configs ?? [];
      resouceItem.type = resTypeHeader.resType;
      resouceItem.SetLimitKey(ResourceUtil.PaserKeyParam(indexHeader.idKeyConfigs[resConfigId]?.configs ?? []));
      ReadResourceItem(input,resouceItem, dataOffset,pos, length);
      if(resInfos[resIndex.resId] == null) {
          resInfos[resIndex.resId] = [];
      }
       resInfos[resIndex.resId]?.add(resouceItem);
    }
  }
  static ResInfo ReadResInfo(InputStream input, int offset, int length){
    input.position = offset;
    if (offset + ResInfo.RES_INFO_LEN  > length) {
      throw Exception("resInfo offset error");
    }
    var resInfo = ResInfo();
    resInfo.resId = input.readUint32();
    resInfo.length = input.readUint32();   
    resInfo.valueCount = input.readUint32();   
    return resInfo;
  }
  static (int, int) ReadResConfig(InputStream input, int pos, int length){
    input.position  = pos;
    pos += 8 ;
    if (pos > length) {
      throw Exception("Config id length error");
    }
    var resConfigId = input.readUint32();
    var dataOffset = input.readUint32();
    return (resConfigId, dataOffset);

  }
  static ReadResourceItem(InputStream input, ResourceItem resourceItem,  int dataOffset, int offset, int length){
    if (dataOffset + 2 > length) {
        throw Exception("resource length error");
    }
    input.position = dataOffset;
    int dataLen = input.readUint16();
    if (dataOffset + 2+ dataLen > length) {
        throw Exception("resource length error");
    }
    resourceItem.SetData(input.readString(size: dataLen));
    resourceItem.MarkCoverable();
  }


  static  Map<int, List<ResourceItem>> LoadResTable(InputStream? input){
    if(input == null)
      return {};
    var pos = 0;
    final length = input.length;
    var header = ReadFileHeader(input, pos, length);
    if (IsNewModule(header)) {
        return LoadNewResTable(input);
    }
    final limitKeys = ReadLimitKeys(input, header.limitKeyConfigSize, pos, length);
    final datas  = ReadIdTables(input, header.limitKeyConfigSize, pos, length);
    var dict = Map<int, List<ResourceItem>>();
    while (input.position < length) {
        var record = ReadDataRecordPrepare(input, pos, length);
        var item = ReadDataRecordStart(input, record, limitKeys, datas);
        if(dict[record.id] == null){
          dict[record.id] = [];
        }
        dict[record.id]?.add(item);
    }
    return dict;
  }
  static Map<int, List<KeyParam>> ReadLimitKeys(InputStream input, int count, int pos, int length){
    var limitKeyDict = Map<int, List<KeyParam>>();
    for (var i = 0; i< count; i++) {
        if (pos > length) {
          throw Exception("KEYS length error");
        }
        pos += LimitKeyConfig.KEY_CONFIG_HEADER_LEN;
        final limitKey = LimitKeyConfig.formInputStream(input);
        var list = List<KeyParam>.empty(growable: true);
        for (var j = 0; j < limitKey.keyCount; j++) {
            pos = pos + 8;
            if (pos > length) {
               throw Exception("keyParams length error");
            }
            final keyParm = KeyParam.formInputStream(input);
            list.add(keyParm);
        }
        limitKeyDict[limitKey.offset] = list;
    }
    return limitKeyDict;
  
  }
  static Map<int,(int, int)> ReadIdTables(InputStream input, int count, int pos, int length){
      var tables = Map<int,(int, int)>();
      for (var i = 0; i< count; i++) {
        pos = pos + 4 + 4;
        if (pos > length) {
            throw Exception("IDSS length error");
        }
        var offset = input.position;
        final idss = IdSet.formInputStream(input);
        for (var j = 0; j < idss.idCount; j++) {
          pos = pos + 8;
          if (pos > length) {
            throw Exception("id data length error");
          }
          final id = input.readUint32();
          final dataOffset = input.readUint32();
          tables[dataOffset] = (id, offset);
        }
      }
      return tables;
  }
  static RecordItem ReadDataRecordPrepare(InputStream input, int pos, int length){
    pos = pos + 4;
    if (pos > length) {
        throw Exception("data record length error");
    }
    var record = RecordItem.formInputStream(input);
    pos = pos + record.size;
    if (pos > length) {
      throw Exception("record.size length error");
    }
    return record;
  }
  static ReadDataRecordStart(InputStream input, RecordItem record, Map<int, List<KeyParam>> limitKeys, Map<int,(int, int)> datas){
    int offset = input.position;
    offset = offset - 4 - 4 - 4;
    int value_size = input.readUint16();
    if (value_size + 2 > record.size) {
      throw Exception("value size error");
    }
    final values = input.readString(size: value_size);
    int name_size = input.readUint16();
    if (value_size + 2 + name_size + 2 > record.size) {
      throw Exception("name size error");
    }
    final name = input.readString(size: name_size);
    final idTableOffset = datas[offset];
    if(idTableOffset == null){
        throw Exception("name size error");
    }
    if (idTableOffset.$1 != record.id) {
        throw Exception("invalid id");
    }
    if (limitKeys[idTableOffset.$2] == null) {
      throw Exception("invalid limit key offset");
    }
    final second = datas[offset]?.$2;
    final keyParams = limitKeys[second] ?? [];
    final resItem = ResourceItem();
    resItem.name = name;
    resItem.keyparams = keyParams;
    resItem.type = gResTypeMap[record.resType] ?? ResType.INVALID_RES_TYPE;
    resItem.SetLimitKey(ResourceUtil.PaserKeyParam(keyParams ?? []));
    resItem.SetData(values);
    resItem.MarkCoverable();
    return resItem;
  }

}

class ResourceUtil{

  static PaserKeyParam(List<KeyParam> keyParams)
  {
      if (keyParams.length == 0) {
          return "base";
      }
      var result = "";
      for (var keyparam in keyParams) {
          var limitKey = GetKeyParamValue(keyparam);
          if (limitKey.isEmpty) {
              continue;
          }
          if (keyparam.keyType == KeyType.MCC) {
              limitKey = "mcc" + limitKey;
          }
          if (keyparam.keyType == KeyType.MNC) {
              limitKey = "mnc" + limitKey;
          }
          if (keyparam.keyType == KeyType.REGION || keyparam.keyType == KeyType.MNC) {
              result = result + "_" + limitKey;
          } else {
              result = result + "-" + limitKey;
          }
      }
      if (!result.isEmpty) {
          result = result.substring(1);
      }
      return result;
  }

  static String GetKeyParamValue(KeyParam KeyParam)
  {
      var val;
      switch (KeyParam.keyType) {
          case KeyType.ORIENTATION:
              val = KeyParam.value == 0 ? "vertical" : "horizontal";
              break;
          case KeyType.NIGHTMODE:
              val = KeyParam.value == 0 ? "dark" : "light";
              break;
          case KeyType.DEVICETYPE:
              val = GetDeviceTypeLimitkey(KeyParam);
              break;
          case KeyType.RESOLUTION:
              val = GetResolutionLimitkey(KeyParam);
              break;
          case KeyType.LANGUAGE:
          case KeyType.SCRIPT:
          case KeyType.REGION:
              val = GetLocaleLimitkey(KeyParam);
              break;
          case KeyType.INPUTDEVICE:
              val = KeyParam.value == -1 ?
              "not set" : "pointDevice";
              break;
          default:
              val = KeyParam.value.toString();
              break;
      }
      return val;
  }
  static GetDeviceTypeLimitkey(KeyParam KeyParam)
  {
      return "";
  }
  static GetResolutionLimitkey(KeyParam KeyParam){
      return "";
  }
  static GetLocaleLimitkey(KeyParam KeyParam)
  {
    return "";
  }
}

class ResourceItem{
    late String name;
    late List<KeyParam> keyparams;
    late ResType type;
    late String data;
    late String limitKey_;
    SetLimitKey(String limitKey){
      limitKey_ = limitKey;
    }
    SetData(String data,){
      this.data = data;
    }
    MarkCoverable(){

    }
}

class ResourceInfo {
    late String id;
    late String typeName;
    late String name;
    late String type;
    late List<Map<String, String>> values;
}

class Restool {
  dump(String filePath){
    final inputStream = InputFileStream(filePath);
    final archive = ZipDecoder().decodeStream(inputStream);
    final resFile = archive.findFile("resources.index");
    return ResourceTable.LoadResTable(resFile?.getContent());
  }
  List<ResourceInfo> dumpRes(String filePath){
    final dict =  ResourceTable.LoadResTable(InputFileStream(filePath));
    return dict.entries.map((entry) {
      final resId = entry.key;
      final items = entry.value;
      return ResourceInfo()
        ..id = resId.toString()
        ..typeName = items.isNotEmpty ? "\$${gResTypStringMap[items[0].type.value]}:${items[0].name}" : "unknown"
        ..name = items.isNotEmpty ? items[0].name : "unknown"
        ..type =  gResTypStringMap[items[0].type.value] ?? ""
        ..values = items.map((item) => {item.limitKey_: item.name, "value": item.data}).toList();
    }).toList();
  }

}

var resTool = Restool();