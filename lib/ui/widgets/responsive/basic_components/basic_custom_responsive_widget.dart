import 'package:flutter/material.dart';

class BasicCustomWidget extends StatelessWidget {
  const BasicCustomWidget(
      {Key? key,
      this.width = 10.0,
      this.aspectRatio = 1.0,
      required this.child})
      : super(key: key);

  final double aspectRatio, width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * aspectRatio,
      child: child,
    );
  }
}
