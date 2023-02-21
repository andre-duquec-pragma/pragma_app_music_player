import 'dart:async';

import 'package:flutter/material.dart';

import '../entities/entity_bloc.dart';
import '../ui/widgets/responsive/drawer_option_widget.dart';

class DrawerMainMenuBloc extends BlocModule {
  static const name = 'drawerMainMenuBloc';
  final _drawerMainMenu =
      BlocGeneral<List<DrawerOptionWidget>>(<DrawerOptionWidget>[]);

  DrawerMainMenuBloc();

  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  Stream<List<DrawerOptionWidget>> get listDrawerOptionSizeStream =>
      _drawerMainMenu.stream;

  List<DrawerOptionWidget> get listMenuOptions => _drawerMainMenu.value;

  void clearMainDrawer() {
    _drawerMainMenu.value = <DrawerOptionWidget>[];
  }

  String mainCover = 'assets/icon.png';

  void addDrawerOptionMenu({
    required onPressed,
    required title,
    description = '',
    required icondata,
  }) {
    final tmpList = <DrawerOptionWidget>[];
    final optionWidget = DrawerOptionWidget(
      onPressed: onPressed,
      title: title,
      icondata: icondata,
      description: description,
    );
    for (final option in _drawerMainMenu.value) {
      if (option.title != title) {
        tmpList.add(option);
      }
    }
    tmpList.add(optionWidget);
    _drawerMainMenu.value = tmpList;
  }

  void removeDrawerOptionMenu(String title) {
    final tmpList = <DrawerOptionWidget>[];
    for (final option in _drawerMainMenu.value) {
      if (option.title.toLowerCase() != title.toLowerCase()) {
        tmpList.add(option);
      }
    }
    _drawerMainMenu.value = tmpList;
  }

  void openDrawer() {
    drawerKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    drawerKey.currentState?.openEndDrawer();
  }

  @override
  FutureOr<void> dispose() {
    _drawerMainMenu.dispose();
  }
}
