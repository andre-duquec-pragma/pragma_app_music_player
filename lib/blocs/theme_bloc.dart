import 'dart:async';

import 'package:flutter/material.dart';

import '../entities/entity_bloc.dart';
import '../services/theme_service.dart';

class ThemeBloc extends BlocModule {
  static String name = 'themeBloc';
  ThemeBloc(ThemeService themeService) {
    _themeService = themeService;
    _themeController = BlocGeneral<ThemeData>(themeService.theme);
  }

  late BlocGeneral<ThemeData> _themeController;
  late ThemeService _themeService;

  ThemeData get theme => _themeService.theme;

  set theme(ThemeData themeData) {
    _themeController.value = themeData;
  }

  Stream<ThemeData> get themeDataStream => _themeController.stream;

  void switchThemeBetweenLigthAndDark() {
    _themeService.switchLightAndDarkTheme();
    theme = _themeService.theme;
  }

  @override
  void dispose() {
    _themeController.close();
  }
}
