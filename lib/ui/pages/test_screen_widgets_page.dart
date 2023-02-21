import 'package:flutter/material.dart';

import '../../blocs/bloc_responsive.dart';
import '../../blocs/bloc_secondary_drawer.dart';
import '../../services/theme_service.dart';
import '../widgets/responsive/my_app_scaffold_widget.dart';

class TestScreenWidgetsPage extends StatefulWidget {
  const TestScreenWidgetsPage({
    Key? key,
    this.child,
    required this.blocResponsive,
    required this.drawerSecondaryMenuBloc,
  }) : super(key: key);
  final Widget? child;

  final ResponsiveBloc blocResponsive;
  final DrawerSecondaryMenuBloc drawerSecondaryMenuBloc;
  @override
  State<TestScreenWidgetsPage> createState() => _TestScreenWidgetsPageState();
}

class _TestScreenWidgetsPageState extends State<TestScreenWidgetsPage> {
  late Size size;
  final listOfSizes = <Size>[];
  int index = 0;

  void changeSize() {
    index++;
    if (index >= listOfSizes.length) {
      index = 0;
    }
    size = listOfSizes[index];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    size = widget.blocResponsive.size;
    widget.drawerSecondaryMenuBloc.addSecondaryDrawerOptionMenu(
        onPressed: () {
          changeSize();
        },
        title: 'Change',
        icondata: Icons.shuffle);
    //  La inyeccion de dependencias se favorece en la linea 52 para favorecer los estandares.
    // final width = blocCore
    //    .getBlocModule<ResponsiveBloc>(ResponsiveBloc.name)
    //    .widthByColumns(2);
    final width = widget.blocResponsive.widthByColumns(2);
    listOfSizes.add(Size(width, width));
    listOfSizes.add(Size(
      width,
      width * 0.5,
    ));
    listOfSizes.add(Size(width, width * 1 / 3));
    listOfSizes.add(Size(1.8 * width, width));
    listOfSizes.add(Size(0.55 * width, width));
  }

  @override
  void dispose() {
    widget.drawerSecondaryMenuBloc.clearSecondaryMainDrawer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyAppScaffold(
      child: Center(
        child: AnimatedContainer(
          width: size.width,
          height: size.height,
          color: ThemeHelpers.colorRandom(),
          duration: const Duration(milliseconds: 400),
          child: widget.child,
        ),
      ),
    );
  }
}
