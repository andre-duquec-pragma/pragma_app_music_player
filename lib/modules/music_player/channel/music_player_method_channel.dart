import 'package:flutter/services.dart';
import '../models/play_list_song_model.dart';

abstract class MusicPlayerMethodChannel {
  Future<void> prepareToReproduceInBackground(PlayListSong? currentSong);

  Future<void> prepareToReproduceInForeground();

  Future<void> onListenerPlayer(Function(MethodCall call) functionCallback);
}