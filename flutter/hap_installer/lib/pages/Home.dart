import 'package:flutter/material.dart';
import 'package:hap_installer/pages/cert_page.dart';
import 'package:hap_installer/pages/history_page.dart';
import 'package:hap_installer/pages/index_page.dart';
import 'package:hap_installer/pages/more_page.dart';
import 'package:hap_installer/widget/navigation_transition.dart';
import 'package:hap_installer/widget/common.dart';
import 'package:hap_installer/widget/constants.dart';

const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

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

  PreferredSizeWidget _createAppBar(PageSelected pageSelected) {
    return AppBar(
      title: Text(appBarTitleFor(pageSelected)),
      centerTitle: false,
      actions: [Container()],
    );
  }
 String appBarTitleFor(PageSelected pageSelected) => switch (pageSelected) {
    PageSelected.home => "主页",
    PageSelected.cert => "AppGallery 证书",
    PageSelected.history => "调试历史",
    PageSelected.more => "更多",
  };
  Widget createScreenFor(PageSelected pageSelected) => switch (pageSelected) {
    PageSelected.home => IndexPage(),
    PageSelected.cert => CertPage(),
    PageSelected.history => HistoryPage(),
    PageSelected.more => MorePage(),
  };
  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey,
          animationController: controller,
          appBar: _createAppBar(PageSelected.values[screenIndex]),
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
