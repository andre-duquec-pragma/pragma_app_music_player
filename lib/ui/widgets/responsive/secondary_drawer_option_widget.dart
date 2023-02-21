import 'package:flutter/material.dart';

import '../../../blocs/bloc_responsive.dart';

class SecondarydrawerOptionWidget extends StatelessWidget {
  const SecondarydrawerOptionWidget({
    Key? key,
    required this.onPressed,
    required this.icondata,
    this.toolTip = '',
    required this.blocResponsive,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icondata;
  final String toolTip;
  final ResponsiveBloc blocResponsive;

  @override
  Widget build(BuildContext context) {
    if (blocResponsive.isMovil) {
      return Container(
        margin: EdgeInsets.only(
            bottom: (blocResponsive.size.height * .025).clamp(2.5, 20)),
        child: FloatingActionButton(
          onPressed: onPressed,
          tooltip: toolTip,
          heroTag: UniqueKey(),
          child: Icon(icondata),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.background, width: 1.0)),
      child: ListTile(
        style: ListTileStyle.drawer,
        leading: Icon(icondata),
        title: Text(toolTip),
        onTap: onPressed,
      ),
    );
  }
}
