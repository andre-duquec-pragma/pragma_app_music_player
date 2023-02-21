import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app_config.dart';
import '../../../blocs/bloc_drawer.dart';
import '../../../blocs/bloc_processing.dart';
import '../../../blocs/bloc_responsive.dart';
import '../../../blocs/bloc_secondary_drawer.dart';
import '../../../blocs/bloc_user_notifications.dart';
import '../../../blocs/navigator_bloc.dart';
import '../../pages/loading_page.dart';
import 'list_tile_drawer_widget.dart';
import 'main_option_menu_widget.dart';
import 'secondary_main_option_menu_widget.dart';

/// Widgets del bloc
class MyAppScaffold extends StatefulWidget {
  const MyAppScaffold({this.child, this.withMargin = true, Key? key, required})
      : super(key: key);

  final Widget? child;
  final bool withMargin;

  @override
  State<MyAppScaffold> createState() => _MyAppScaffoldState();
}

class _MyAppScaffoldState extends State<MyAppScaffold> {
  late StreamSubscription<Size> streamSubscription;
  int errorCount = 0;

  @override
  void initState() {
    super.initState();
    streamSubscription = blocCore
        .getBlocModule<ResponsiveBloc>(ResponsiveBloc.name)
        .appScreenSizeStream
        .listen((event) {
      try {
        setState(() {});
      } catch (e) {
        errorCount++;
        debugPrint('No es posible establecer el estado $errorCount');
      }
    });
    blocCore
        .getBlocModule<DrawerMainMenuBloc>(DrawerMainMenuBloc.name)
        .drawerKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    blocCore.addBlocModule(
        UserNotificationsBloc.name, UserNotificationsBloc(context));
    final responsiveBloc =
        blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name);

    final drawerBloc =
        blocCore.getBlocModule<DrawerMainMenuBloc>(DrawerMainMenuBloc.name);
    bool isMobile = responsiveBloc.getDeviceType == ScreenSizeEnum.movil;
    if (isMobile) {
      responsiveBloc.setSizeFromContext(context);
    }
    Drawer? drawer = _buildDrawer();
    AppBar? appbar = _buildAppBar();
    Widget? floatingActionButtons = _buildFloatingActionMenu();

    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
              key: drawerBloc.drawerKey,
              appBar: appbar,
              drawer: drawer,
              floatingActionButton: floatingActionButtons,
              body: isMobile
                  ? widget.child ?? const SizedBox()
                  : Row(
                      children: [
                        MainOptionMenuWidget(
                          key: UniqueKey(),
                          responsiveBloc: responsiveBloc,
                          drawerMainMenuBloc: drawerBloc,
                        ),
                        // evitar el constructor con constante para forzar la actualizacion dinamica de estos widgets
                        SecondaryMainOptionMenuWidget(
                          key: UniqueKey(),
                          blocResponsive: responsiveBloc,
                          blocSecondaryDrawer:
                              blocCore.getBlocModule<DrawerSecondaryMenuBloc>(
                                  DrawerSecondaryMenuBloc.name),
                        ),
                        // evitar el constructor con constante para forzar la actualizacion dinamica de estos widgets
                        WorkAreaWidget(
                            withMargin: widget.withMargin, child: widget.child)
                      ],
                    )),
        ),
        LoadingPage(
          blocProcessing:
              blocCore.getBlocModule<BlocProcessing>(BlocProcessing.name),
          blocResponsive: responsiveBloc,
        )
      ],
    );
  }

  Widget? _buildFloatingActionMenu() {
    ResponsiveBloc blocResponsive =
        blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name);
    if (blocResponsive.isMovil) {
      final listMenuOptions = blocCore
          .getBlocModule<DrawerSecondaryMenuBloc>(DrawerSecondaryMenuBloc.name)
          .listMenuOptions;

      if (listMenuOptions.isEmpty) {
        return const SizedBox();
      }
      if (listMenuOptions.length == 1) {
        return listMenuOptions.first;
      }
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: listMenuOptions,
        ),
      );
    }

    return null;
  }

  Drawer? _buildDrawer() {
    DrawerMainMenuBloc drawerMainMenuBloc =
        blocCore.getBlocModule<DrawerMainMenuBloc>(DrawerMainMenuBloc.name);
    ResponsiveBloc blocResponsive =
        blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name);

    if (drawerMainMenuBloc.listMenuOptions.isNotEmpty &&
        blocResponsive.isDesktop) {
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset(drawerMainMenuBloc.mainCover),
              ),
            ),
            ...drawerMainMenuBloc.listMenuOptions,
            const ListTileExitDrawerWidget()
          ],
        ),
      );
    }
    return null;
  }

  AppBar? _buildAppBar() {
    final NavigatorBloc navigatorBloc =
        blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name);

    DrawerMainMenuBloc drawerMainMenuBloc =
        blocCore.getBlocModule<DrawerMainMenuBloc>(DrawerMainMenuBloc.name);
    ResponsiveBloc blocResponsive =
        blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name);
    Widget listLeadingButtons = const Text('');
    if (navigatorBloc.historyPageLength > 1) {
      listLeadingButtons = IconButton(
        icon: const Icon(
          Icons.chevron_left,
        ),
        onPressed: () => navigatorBloc.back(),
      );
    }
    final listActions = <Widget>[];
    if (drawerMainMenuBloc.listMenuOptions.isNotEmpty &&
        blocResponsive.isDesktop) {
      listActions.add(IconButton(
        icon: const Icon(
          Icons.menu,
        ),
        onPressed: () {
          drawerMainMenuBloc.openDrawer();
        },
      ));
    }

    String title = navigatorBloc.title;
    if (title.isNotEmpty || drawerMainMenuBloc.listMenuOptions.isNotEmpty) {
      return AppBar(
        title: Text(title),
        leading: listLeadingButtons,
        actions: listActions,
      );
    }
    return null;
  }
}

class WorkAreaWidget extends StatelessWidget {
  const WorkAreaWidget({
    Key? key,
    required this.child,
    required this.withMargin,
  }) : super(key: key);

  final Widget? child;
  final bool withMargin;

  @override
  Widget build(BuildContext context) {
    ResponsiveBloc blocResponsive =
        blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name);
    blocResponsive.setSizeFromContext(context);
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          blocResponsive.workAreaSize =
              Size(constraints.maxWidth, constraints.maxHeight);
          if (withMargin) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: blocResponsive.marginWidth),
                child: child ?? const SizedBox(),
              ),
            );
          }
          return child ?? const SizedBox();
        },
      ),
    );
  }
}
