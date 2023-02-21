import 'package:flutter/material.dart';

import '../../../../blocs/bloc_responsive.dart';

class BasicCustomAspectRatioWidget extends StatelessWidget {
  const BasicCustomAspectRatioWidget(
      {Key? key,
      this.numberOfColumns = 1,
      this.aspectRatio = 1.0,
      this.child,
      required this.responsiveBloc})
      : super(key: key);

  final int numberOfColumns;
  final double aspectRatio;
  final Widget? child;
  final ResponsiveBloc responsiveBloc;

  @override
  Widget build(BuildContext context) {
    final width = responsiveBloc.widthByColumns(numberOfColumns);
    return SizedBox(
      width: width,
      height: width * aspectRatio,
      child: child,
    );
  }
}
