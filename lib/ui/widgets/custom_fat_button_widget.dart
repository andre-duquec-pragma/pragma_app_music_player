import 'package:flutter/material.dart';

class CustomFatButtonWidget extends StatelessWidget {
  const CustomFatButtonWidget(
      {Key? key, this.label = 'Push me', this.function, this.iconData})
      : super(key: key);

  final String label;
  final void Function()? function;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Theme.of(context).splashColor,
        disabledColor: Theme.of(context).splashColor.withOpacity(0.1),
        onPressed: function,
        child: Row(
          children: [Icon(iconData ?? Icons.adb), Text(label)],
        ));
  }
}
