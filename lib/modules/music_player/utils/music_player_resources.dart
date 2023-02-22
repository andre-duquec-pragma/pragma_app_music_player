import 'package:flutter/material.dart';

import '../entities/music_player.dart';
import 'music_player_state.dart';

class MusicPlayerResources {
  static Icon getIconBasedOnState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return const Icon(Icons.block);

    if (musicPlayer.state == MusicPlayerState.changingSong) return const Icon(Icons.downloading);

    if (musicPlayer.isPause) return const Icon(Icons.play_arrow);

    return const Icon(Icons.pause);
  }

  static String getTextBasedOnState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return "There is not song to play";

    if (musicPlayer.state == MusicPlayerState.changingSong) return "Changing song";

    if (musicPlayer.isPause) return "Play song";

    return "Pause song";
  }
}