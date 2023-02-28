import 'package:flutter/cupertino.dart';

enum MusicPlayerMethodChannelMethods {
  prepareForReproduceInBackground("prepareForReproduceInBackground"),
  prepareForReproduceInForeground("prepareForReproduceInForeground");

  const MusicPlayerMethodChannelMethods(this.value);
  final String value;
}