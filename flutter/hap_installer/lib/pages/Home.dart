import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/pages/cert_page.dart';
import 'package:hap_installer/pages/history_page.dart';
import 'package:hap_installer/pages/index_page.dart';
import 'package:hap_installer/pages/more_page.dart';
import 'package:hap_installer/pages/sign_config_page.dart';
import 'package:hap_installer/pages/team_device_page.dart';
import 'package:hap_installer/widget/navigation_transition.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:hap_installer/widget/constants.dart';

const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController controller;
  bool controllerInitialized = false;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;
  int screenIndex = PageSelected.home.value;

  @override
  initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      value: 0,
      vsync: this,
    );
    viewmodel.loadUserInfo(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;
    if (width > mediumWidthBreakpoint) {
      if (width > largeWidthBreakpoint) {
        showMediumSizeLayout = false;
        showLargeSizeLayout = true;
      } else {
        showMediumSizeLayout = true;
        showLargeSizeLayout = false;
      }
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        controller.forward();
      }
    } else {
      showMediumSizeLayout = false;
      showLargeSizeLayout = false;
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > mediumWidthBreakpoint ? 1 : 0;
    }
  }

  PreferredSizeWidget _createAppBar(
    BuildContext context,
    PageSelected pageSelected,
  ) {
    List<Widget> actions = [Container()];
    if (pageSelected == PageSelected.cert) {
      actions.add(
        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
          icon: Icon(Icons.settings),
        ),
      );
    }
    if (pageSelected == PageSelected.home) {
      actions.add(
        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
            viewmodel.checkDevices();
          },
          icon: Icon(Icons.mode_edit),
        ),
      );
    }
    return AppBar(
      title: Text(appBarTitleFor(pageSelected)),
      centerTitle: false,
      actions: actions,
    );
  }

  String appBarTitleFor(PageSelected pageSelected) {
    switch (pageSelected) {
      case PageSelected.home:
        return "主页";
      case PageSelected.cert:
        return "AppGallery 证书";
      case PageSelected.history:
        return "调试历史";
      case PageSelected.more:
        return "更多";
    }
  }

  Widget createScreenFor(PageSelected pageSelected) {
    switch (pageSelected) {
      case PageSelected.home:
        return IndexPage();
      case PageSelected.cert:
        return CertPage();
      case PageSelected.history:
        return HistoryPage();
      case PageSelected.more:
        return MorePage();
    }
  }

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  Widget? buildDrawer(PageSelected pageSelected) {
    if (pageSelected == PageSelected.home) {
      return Drawer(child: TeamDevicePage());
    }
    if (pageSelected == PageSelected.cert) {
      return Drawer(child: SignConfigPage());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey,
          animationController: controller,
          appBar: _createAppBar(context, PageSelected.values[screenIndex]),
          body: createScreenFor(PageSelected.values[screenIndex]),
          navigationRail: NavigationRail(
            extended: showLargeSizeLayout,
            destinations: _navRailDestinations,
            selectedIndex: screenIndex,
            onDestinationSelected: (index) {
              handleScreenChanged(index);
            },
          ),
          navigationBar: NavigationBars(
            onSelectItem: (index) {
              handleScreenChanged(index);
            },
            selectedIndex: screenIndex,
          ),
          drawer: buildDrawer(PageSelected.values[screenIndex]),
        );
      },
    );
  }
}

final List<NavigationRailDestination> _navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(message: destination.label, child: destination.icon),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      ),
    )
    .toList(growable: false);

class NavigationBars extends StatefulWidget {
  const NavigationBars({
    super.key,
    this.onSelectItem,
    required this.selectedIndex,
  });

  final void Function(int)? onSelectItem;
  final int selectedIndex;

  @override
  State<NavigationBars> createState() => _NavigationBarsState();
}

class _NavigationBarsState extends State<NavigationBars> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant NavigationBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget navigationBar = Focus(
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          widget.onSelectItem!(index);
        },
        destinations: appBarDestinations,
      ),
    );
    return navigationBar;
  }
}

Future<bool> hasJavaBySys() async {
  // 禁用系统java
  return false;
  try {
    var result = await Process.run('java', ['-version']);
    // 检查命令的退出状态
    if (result.exitCode == 0) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
