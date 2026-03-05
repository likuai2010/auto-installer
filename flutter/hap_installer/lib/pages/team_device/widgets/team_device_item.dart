import 'package:flutter/foundation.dart';
import 'package:hap_installer/models/EcoResult.dart';

/// 团队设备列表项类型
enum TeamDeviceItemType {
  /// 团队项
  team,

  /// 设备项
  device,

  /// 历史连接项
  history,
}

/// 团队设备列表项数据模型
///
/// 用于展示团队、设备、历史连接信息的封装类
class TeamDeviceItem {
  /// 唯一标识
  final String id;

  /// 显示名称
  final String name;

  /// 项类型
  final TeamDeviceItemType itemType;

  /// 是否选中
  final bool isSelected;

  /// 图标名称（SVG 资源路径，可选）
  final String? icon;

  /// 副标题（可选）
  final String? subtitle;

  /// 点击回调
  final VoidCallback? onTap;

  /// 删除回调（仅历史连接使用）
  final VoidCallback? onDelete;

  const TeamDeviceItem({
    required this.id,
    required this.name,
    required this.itemType,
    this.isSelected = false,
    this.icon,
    this.subtitle,
    this.onTap,
    this.onDelete,
  });

  /// 从 TeamInfo 创建 TeamDeviceItem
  ///
  /// [info] 团队信息
  /// [isSelected] 是否为当前选中的团队
  /// [onTap] 点击回调
  factory TeamDeviceItem.fromTeamInfo(
    TeamInfo info, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return TeamDeviceItem(
      id: info.id,
      name: info.name,
      itemType: TeamDeviceItemType.team,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  /// 从设备 ID 创建 TeamDeviceItem
  ///
  /// [deviceId] 设备 ID
  /// [isSelected] 是否为当前选中的设备
  /// [onTap] 点击回调
  factory TeamDeviceItem.fromDevice(
    String deviceId, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return TeamDeviceItem(
      id: deviceId,
      name: deviceId,
      itemType: TeamDeviceItemType.device,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  /// 从历史连接地址创建 TeamDeviceItem
  ///
  /// [address] 连接地址
  /// [onTap] 点击回调
  /// [onDelete] 删除回调
  factory TeamDeviceItem.fromHistory(
    String address, {
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return TeamDeviceItem(
      id: address,
      name: address,
      itemType: TeamDeviceItemType.history,
      isSelected: false,
      onTap: onTap,
      onDelete: onDelete,
    );
  }

  /// 复制并修改部分属性
  TeamDeviceItem copyWith({
    String? id,
    String? name,
    TeamDeviceItemType? itemType,
    bool? isSelected,
    String? icon,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return TeamDeviceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      itemType: itemType ?? this.itemType,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
      subtitle: subtitle ?? this.subtitle,
      onTap: onTap ?? this.onTap,
      onDelete: onDelete ?? this.onDelete,
    );
  }

  @override
  String toString() {
    return 'TeamDeviceItem(id: $id, name: $name, type: $itemType, isSelected: $isSelected)';
  }
}
