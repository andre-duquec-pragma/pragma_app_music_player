import 'package:flutter/material.dart';

import '../../../blocs/bloc_drawer.dart';
import '../../../blocs/bloc_responsive.dart';
import 'drawer_option_widget.dart';

class MainOptionMenuWidget extends StatelessWidget {
  const MainOptionMenuWidget({
    Key? key,
    required this.responsiveBloc,
    required this.drawerMainMenuBloc,
  }) : super(key: key);
  final ResponsiveBloc responsiveBloc;
  final DrawerMainMenuBloc drawerMainMenuBloc;

  @override
  Widget build(BuildContext context) {
    if (responsiveBloc.isMovil || responsiveBloc.isTablet) {
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }

    final menuBloc = drawerMainMenuBloc;
    final size = Size(
      (responsiveBloc.size.width * 0.15).clamp(150, 200),
      responsiveBloc.size.height,
    );

    return StreamBuilder<List<DrawerOptionWidget>>(
      stream: menuBloc.listDrawerOptionSizeStream,
      builder: (context, snapshot) {
        if (menuBloc.listMenuOptions.isEmpty) {
          return const SizedBox(
            width: 0.0,
            height: 0.0,
          );
        }
        return Container(
          width: size.width,
          height: size.height,
          color: Theme.of(context).splashColor,
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset(drawerMainMenuBloc.mainCover),
                ),
              ),
              ...drawerMainMenuBloc.listMenuOptions.map((e) {
                return DrawerOptionWidget(
                  onPressed: e.onPressed,
                  title: e.title,
                  icondata: e.icondata,
                  getOutOnTap: false,
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
