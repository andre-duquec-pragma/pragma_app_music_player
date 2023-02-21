import 'package:flutter/material.dart';

import '../responsive/my_app_scaffold_widget.dart';

class BackgroudFormBuilderWidget extends StatelessWidget {
  const BackgroudFormBuilderWidget({Key? key, required this.children})
      : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // hide keyboard with no use
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MyAppScaffold(
          child: ListView.builder(
              itemCount: children.length,
              itemBuilder: (BuildContext context, int index) {
                return children[index];
              })),
    );
  }
}
