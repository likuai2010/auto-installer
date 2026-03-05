import 'package:flutter/foundation.dart';
import 'package:hap_installer/models/EcoResult.dart';
import 'package:intl/intl.dart';

/// 证书列表项数据模型
///
/// 用于展示证书信息的封装类，包含状态判断和回调函数
class CertItem {
  /// 证书ID
  final String id;

  /// 证书名称
  final String certName;

  /// 证书类型 (1=调试, 2=发布)
  final int certType;

  /// 过期时间戳（毫秒）
  final int expireTime;

  /// 是否为当前使用的证书
  final bool isCurrent;

  /// 是否已过期
  final bool isExpired;

  /// 使用按钮点击回调
  final VoidCallback? onUse;

  /// 删除按钮点击回调
  final VoidCallback? onDelete;

  /// 长按回调
  final VoidCallback? onLongPress;

  const CertItem({
    required this.id,
    required this.certName,
    required this.certType,
    required this.expireTime,
    required this.isCurrent,
    required this.isExpired,
    this.onUse,
    this.onDelete,
    this.onLongPress,
  });

  /// 从 CertInfo 创建 CertItem
  ///
  /// [info] 原始证书信息
  /// [currentId] 当前使用的证书ID
  /// [onUse] 使用证书回调
  /// [onDelete] 删除证书回调
  /// [onLongPress] 长按回调
  factory CertItem.fromCertInfo(
    CertInfo info,
    String? currentId, {
    VoidCallback? onUse,
    VoidCallback? onDelete,
    VoidCallback? onLongPress,
  }) {
    return CertItem(
      id: info.id,
      certName: info.certName,
      certType: info.certType,
      expireTime: info.expireTime,
      isCurrent: currentId == info.id,
      isExpired: _isExpired(info.expireTime),
      onUse: onUse,
      onDelete: onDelete,
      onLongPress: onLongPress,
    );
  }

  /// 格式化的过期时间字符串
  String get formattedExpireTime {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(expireTime);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// 证书类型标签
  String get certTypeLabel => certType == 2 ? '发布' : '调试';

  /// 判断证书是否已过期
  static bool _isExpired(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().isAfter(dateTime);
  }

  /// 复制并修改部分属性
  CertItem copyWith({
    String? id,
    String? certName,
    int? certType,
    int? expireTime,
    bool? isCurrent,
    bool? isExpired,
    VoidCallback? onUse,
    VoidCallback? onDelete,
    VoidCallback? onLongPress,
  }) {
    return CertItem(
      id: id ?? this.id,
      certName: certName ?? this.certName,
      certType: certType ?? this.certType,
      expireTime: expireTime ?? this.expireTime,
      isCurrent: isCurrent ?? this.isCurrent,
      isExpired: isExpired ?? this.isExpired,
      onUse: onUse ?? this.onUse,
      onDelete: onDelete ?? this.onDelete,
      onLongPress: onLongPress ?? this.onLongPress,
    );
  }
}
