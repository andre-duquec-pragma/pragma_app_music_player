import 'package:music_station/modules/music_player/entities/play_list_song.dart';

abstract class MusicPlayerMethodChannel {
  Future<void> prepareToReproduceInBackground(PlayListSong? currentSong);

  Future<void> prepareToReproduceInForeground();
}