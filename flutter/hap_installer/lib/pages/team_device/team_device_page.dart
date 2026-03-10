import 'package:flutter/material.dart';
import 'package:hap_installer/core/constants/app_colors.dart';
import 'package:hap_installer/viewmodels/EcoViewModel.dart';
import 'package:provider/provider.dart';

import 'widgets/team_device_card.dart';
import 'widgets/team_device_item.dart';

/// 团队设备页面
///
/// 侧边栏抽屉组件，显示团队、设备、历史连接列表
/// 使用卡片化设计风格，与 cert、home 模块保持一致
class TeamDevicePage extends StatelessWidget {
  const TeamDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(
      builder: (context, model, child) {
        return Container(
          color: AppColors.backgroundSecondaryDynamic(context),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // 团队列表卡片
              _buildTeamCard(model),
              // 设备列表卡片
              _buildDeviceCard(context, model),
              // 历史连接列表卡片
              _buildHistoryCard(context, model),
            ],
          ),
        );
      },
    );
  }

  /// 构建团队列表卡片
  Widget _buildTeamCard(EcoViewModel model) {
    final items = _getTeamItems(model);
    return TeamDeviceCard(
      title: '团队',
      items: items,
      emptyText: model.isLogin ? '暂无团队' : '请先登录',
    );
  }

  /// 获取团队列表项
  List<TeamDeviceItem> _getTeamItems(EcoViewModel model) {
    if (!model.isLogin || model.teamList.isEmpty) {
      return [];
    }

    return model.teamList.map((team) {
      return TeamDeviceItem.fromTeamInfo(
        team,
        isSelected: model.userInfo?.teamId == team.id,
        onTap: () => model.changeTeam(team),
      );
    }).toList();
  }

  /// 构建设备列表卡片
  Widget _buildDeviceCard(BuildContext context, EcoViewModel model) {
    final items = _getDeviceItems(model);
    return TeamDeviceCard(
      title: '可用设备',
      items: items,
      emptyText: '暂无设备',
    );
  }

  /// 获取设备列表项
  List<TeamDeviceItem> _getDeviceItems(EcoViewModel model) {
    if (model.deviceList.isEmpty) {
      return [];
    }

    return model.deviceList.map((deviceId) {
      return TeamDeviceItem.fromDevice(
        deviceId,
        isSelected: model.currentDevice == deviceId,
        onTap: () => model.changeDevice(deviceId),
      );
    }).toList();
  }

  /// 构建历史连接列表卡片
  Widget _buildHistoryCard(BuildContext context, EcoViewModel model) {
    final items = _getHistoryItems(context, model);
    return TeamDeviceCard(
      title: '历史连接',
      items: items,
      actionText: '清除',
      onAction: items.isNotEmpty ? () => model.resetHistory() : null,
      emptyText: '暂无历史连接',
    );
  }

  /// 获取历史连接列表项
  List<TeamDeviceItem> _getHistoryItems(
    BuildContext context,
    EcoViewModel model,
  ) {
    if (model.historyList.isEmpty) {
      return [];
    }

    return model.historyList.map((address) {
      return TeamDeviceItem.fromHistory(
        address,
        onTap: () => model.tryConnectToDevice(context, address),
      );
    }).toList();
  }
}
