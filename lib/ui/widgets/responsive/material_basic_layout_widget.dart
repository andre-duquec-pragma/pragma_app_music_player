import 'package:flutter/material.dart';

import '../../../blocs/bloc_responsive.dart';
import 'basic_components/bacis_2_x_1_widget.dart';
import 'basic_components/basic_1_x_1_widget.dart';
import 'basic_components/basic_3_x_1_widget.dart';
import 'basic_components/basic_custom_aspect_ratio_widget.dart';

class MaterialBasicLayoutWidget extends StatelessWidget {
  const MaterialBasicLayoutWidget({
    Key? key,
    this.child,
    required this.responsiveBloc,
  }) : super(key: key);

  final Widget? child;
  final ResponsiveBloc responsiveBloc;

  @override
  Widget build(BuildContext context) {
    final blocResponsive = responsiveBloc;
    final height = blocResponsive.workAreaSize.height;
    if (blocResponsive.workAreaSize.width <= 0 || height <= 0) {
      return const Center(
        child: Text('No es posible dibujar la plantilla'),
      );
    }

    final content = <Widget>[];
    content.add(Container(
      height: height,
      width: blocResponsive.marginWidth,
      color: Colors.lightGreenAccent,
    ));
    for (int i = 0; i < blocResponsive.columnsNumber; i++) {
      content.add(Container(
        height: height,
        width: blocResponsive.columnWidth,
        color: Colors.lightBlue,
      ));
      if (i < blocResponsive.columnsNumber - 1) {
        content.add(Container(
          height: height,
          width: blocResponsive.gutterWidth,
          color: Colors.grey,
        ));
      }
    }

    content.add(Container(
      height: height,
      width: blocResponsive.marginWidth,
      color: Colors.lightGreenAccent,
    ));

    return Stack(
      children: [
        GridPaper(
          color: Theme.of(context).focusColor,
          subdivisions: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: height,
            width: blocResponsive.workAreaSize.width,
            child: Row(
              children: content,
            ),
          ),
        ),
        Positioned(
            top: blocResponsive.marginWidth,
            left: blocResponsive.marginWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: blocResponsive.workAreaSize.width,
                  ),
                  Text('Column width: ${blocResponsive.columnWidth}'),
                  Text('Margin width: ${blocResponsive.marginWidth}'),
                  Text('Gutter width: ${blocResponsive.gutterWidth}'),
                  SizedBox(
                    height: blocResponsive.gutterWidth,
                  ),
                  Basic1x1Widget(
                    numberOfColumns: 1,
                    responsiveBloc: responsiveBloc,
                    child: const _TmpLabelWidget(
                      label: '1x1',
                    ),
                  ),
                  SizedBox(
                    height: blocResponsive.gutterWidth,
                  ),
                  Basic2x1Widget(
                    numberOfColumns: 2,
                    responsiveBloc: responsiveBloc,
                    child: const _TmpLabelWidget(
                      label: '1x2',
                    ),
                  ),
                  SizedBox(
                    height: blocResponsive.gutterWidth,
                  ),
                  Basic3x1Widget(
                    numberOfColumns: 3,
                    responsiveBloc: responsiveBloc,
                    child: const _TmpLabelWidget(
                      label: '1x3',
                    ),
                  ),
                  SizedBox(
                    height: blocResponsive.gutterWidth,
                  ),
                  BasicCustomAspectRatioWidget(
                    numberOfColumns: 4,
                    aspectRatio: 0.5625,
                    responsiveBloc: responsiveBloc,
                    child: const _TmpLabelWidget(
                      label: 'Horizontal',
                    ),
                  ),
                  SizedBox(
                    height: blocResponsive.gutterWidth,
                  ),
                  BasicCustomAspectRatioWidget(
                    numberOfColumns: 2,
                    aspectRatio: 1.777,
                    responsiveBloc: responsiveBloc,
                    child: const _TmpLabelWidget(
                      label: 'Vertical',
                    ),
                  ),
                ],
              ),
            )),
        child ?? const SizedBox()
      ],
    );
  }
}

class _TmpLabelWidget extends StatelessWidget {
  const _TmpLabelWidget({
    Key? key,
    this.label = '',
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color1 = theme.colorScheme.background;
    final color2 = theme.primaryColor;
    return Container(
      color: color1,
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(color: color2),
      ),
    );
  }
}
