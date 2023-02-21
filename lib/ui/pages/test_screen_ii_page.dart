import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_config.dart';
import '../../blocs/bloc_responsive.dart';
import '../widgets/responsive/material_basic_layout_widget.dart';
import '../widgets/responsive/my_app_scaffold_widget.dart';

class TestScreenIIPage extends StatefulWidget {
  const TestScreenIIPage({
    Key? key,
    this.widget,
    required this.blocResponsive,
  }) : super(key: key);
  final Widget? widget;
  final ResponsiveBloc blocResponsive;

  @override
  State<TestScreenIIPage> createState() => _TestScreenIIPageState();
}

class _TestScreenIIPageState extends State<TestScreenIIPage> {
  final List<Size> _sizeMap = [];
  int index = 0;
  final icondataList = <IconData>[
    Icons.add,
    Icons.tab,
    Icons.stream,
    Icons.update,
    Icons.height,
    Icons.description
  ];

  @override
  void dispose() {
    _sizeMap.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sizeMap.isEmpty) {
      final size = widget.blocResponsive.size;
      final maxUnit = max(size.width, size.height) / 2;

      _sizeMap.add(Size(maxUnit, maxUnit * .25));
      _sizeMap.add(Size(maxUnit, maxUnit / 3));
      _sizeMap.add(Size(maxUnit, maxUnit / 2));
      _sizeMap.add(Size(maxUnit, maxUnit * 2));
    }
    return MyAppScaffold(
        withMargin: false,
        child: MaterialBasicLayoutWidget(
          responsiveBloc:
              blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name),
        ));
  }
}
