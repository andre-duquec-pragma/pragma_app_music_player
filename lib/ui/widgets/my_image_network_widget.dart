// This widget generate the proper representation of user widgets
// author Albert J. Jiménez P.
// author email oficinameltablero@gmail.com
// date release 13/06/2022
import 'package:flutter/material.dart';

class MyImageNetworkWidget extends StatelessWidget {
  const MyImageNetworkWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
        fit: BoxFit.fitWidth,
        placeholder: 'assets/loading_icon.gif',
        image: imageUrl);
  }
}
