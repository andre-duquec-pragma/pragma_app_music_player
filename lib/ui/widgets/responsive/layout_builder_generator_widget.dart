// This widget must be a blueprint for generate respnsive code for modules widgets

import 'package:flutter/material.dart';

class LayoutBuilderGeneratorWidget extends StatelessWidget {
  const LayoutBuilderGeneratorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (constraints.maxWidth == constraints.maxHeight) {
          return _Widget1x1(size: size);
        }
        if (constraints.maxWidth == constraints.maxHeight * 2) {
          return _Widget2x1(
            size: size,
          );
        }
        if (constraints.maxWidth == constraints.maxHeight * 3) {
          return _Widget3x1(
            size: size,
          );
        }
        if (constraints.maxWidth > constraints.maxHeight) {
          return _WidgetHorizontal(size: size);
        }
        return _WidgetVertical(size: size);
      },
    );
  }
}

class _Widget1x1 extends StatelessWidget {
  const _Widget1x1({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Text(size.toString()),
    );
  }
}

class _Widget2x1 extends StatelessWidget {
  const _Widget2x1({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Text(size.toString()),
    );
  }
}

class _Widget3x1 extends StatelessWidget {
  const _Widget3x1({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Text(size.toString()),
    );
  }
}

class _WidgetHorizontal extends StatelessWidget {
  const _WidgetHorizontal({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Text(size.toString()),
    );
  }
}

class _WidgetVertical extends StatelessWidget {
  const _WidgetVertical({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Text(size.toString()),
    );
  }
}
