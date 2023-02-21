import 'package:flutter/material.dart';

import '../../../blocs/bloc_responsive.dart';
import '../../../blocs/bloc_secondary_drawer.dart';
import 'secondary_drawer_option_widget.dart';

class SecondaryMainOptionMenuWidget extends StatelessWidget {
  const SecondaryMainOptionMenuWidget({
    Key? key,
    required this.blocResponsive,
    required this.blocSecondaryDrawer,
  }) : super(key: key);

  final ResponsiveBloc blocResponsive;
  final DrawerSecondaryMenuBloc blocSecondaryDrawer;

  @override
  Widget build(BuildContext context) {
    if (blocResponsive.isMovil) {
      return const SizedBox(width: 1.0);
    }
    final menuBloc = blocSecondaryDrawer;
    final size = Size(
      (blocResponsive.size.width * 0.15).clamp(150, 300),
      blocResponsive.size.height,
    );

    return StreamBuilder<List<SecondarydrawerOptionWidget>>(
      stream: blocSecondaryDrawer.listDrawerOptionSizeStream,
      builder: (context, snapshot) {
        if (menuBloc.listMenuOptions.isEmpty) {
          return const SizedBox(
            width: 0.0,
          );
        }
        return Container(
          width: size.width,
          height: size.height,
          color: Theme.of(context).colorScheme.tertiary,
          child: ListView(
            children: blocSecondaryDrawer.listMenuOptions,
          ),
        );
      },
    );
  }
}
