import 'dart:async';

import 'package:flutter/material.dart';

import '../entities/entity_bloc.dart';

class ResponsiveBloc extends BlocModule {
  static String name = 'responsiveBloc';
  final _blocSizeGeneral = BlocGeneral<Size>(const Size(1, 1));
  Stream<Size> get appScreenSizeStream => _blocSizeGeneral.stream;

  ResponsiveBloc() {
    _workAreaSize = const Size(0, 0);
  }

  Size get value => _blocSizeGeneral.value;

  void setSizeFromContext(BuildContext context) {
    final sizeTmp = MediaQuery.of(context).size;
    if (sizeTmp.width != value.width || sizeTmp.height != value.height) {
      _blocSizeGeneral.value = sizeTmp;
    }
  }

  Size get size => value;
  late Size _workAreaSize;

  set workAreaSize(Size sizeOfWorkArea) {
    if (sizeOfWorkArea.width != _workAreaSize.width &&
        sizeOfWorkArea.height > 0.0 &&
        sizeOfWorkArea.width > 0.0) {
      _workAreaSize = sizeOfWorkArea;
    }
  }

  Size get workAreaSize => isMovil ? size : _workAreaSize;

  int get columnsNumber {
    int tmp = 4;
    if (isTablet) tmp = 8;
    if (isDesktop) tmp = 12;
    if (isTv) tmp = 12;
    return tmp;
  }

  double get marginWidth {
    double tmp = 16.0;
    if (isTablet) tmp = 32;
    if (isDesktop) tmp = 64;
    if (isTv) tmp = 128;
    return tmp;
  }

  double get gutterWidth {
    double tmp = marginWidth * 2;
    tmp = tmp / columnsNumber;
    return tmp.floorToDouble();
  }

  int numberOfGutters(int numberOfColumns) {
    if (numberOfColumns < 1) return 0;
    return numberOfColumns - 1;
  }

  double get columnWidth {
    double tmp = workAreaSize.width;
    tmp = tmp - (marginWidth * 2);
    tmp = tmp - (numberOfGutters(columnsNumber) * gutterWidth);
    tmp = tmp / columnsNumber;
    return tmp;
  }

  ScreenSizeEnum get getDeviceType {
    if (size.width >= 1200) {
      return ScreenSizeEnum.desktop;
    } else if (size.width < 1200 && size.width > 520) {
      return ScreenSizeEnum.tablet;
    }
    return ScreenSizeEnum.movil;
  }

  bool get isMovil => getDeviceType == ScreenSizeEnum.movil;

  bool get isTablet => getDeviceType == ScreenSizeEnum.tablet;

  bool get isDesktop => getDeviceType == ScreenSizeEnum.desktop;

  bool get isTv => getDeviceType == ScreenSizeEnum.tv;

  double widthByColumns(int numberOfColumns) {
    numberOfColumns = numberOfColumns.abs();
    double tmp = columnWidth * numberOfColumns;
    if (numberOfColumns > 1) {
      tmp = tmp + (gutterWidth * (numberOfColumns - 1));
    }

    return tmp;
  }

  @override
  FutureOr<void> dispose() {
    _blocSizeGeneral.dispose();
  }
}

enum ScreenSizeEnum { movil, tablet, desktop, tv }
