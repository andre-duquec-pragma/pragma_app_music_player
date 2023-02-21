import 'package:flutter/material.dart';

import '../../../../blocs/bloc_responsive.dart';

class Basic3x1Widget extends StatelessWidget {
  const Basic3x1Widget(
      {Key? key,
      this.numberOfColumns = 1,
      this.child,
      required this.responsiveBloc})
      : super(key: key);

  final int numberOfColumns;
  final Widget? child;
  final ResponsiveBloc responsiveBloc;

  @override
  Widget build(BuildContext context) {
    final width = responsiveBloc.widthByColumns(numberOfColumns);
    return SizedBox(
      width: width,
      height: width / 3,
      child: child,
    );
  }
}
