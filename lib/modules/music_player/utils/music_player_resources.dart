import 'package:flutter/material.dart';

import '../entities/music_player.dart';
import 'music_player_state.dart';

class MusicPlayerResources {

  static IconData getIconBasedOnState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return Icons.block;

    if(musicPlayer.state == MusicPlayerState.open) return Icons.downloading;

    if (musicPlayer.state == MusicPlayerState.changingSong) return Icons.downloading;

    if (musicPlayer.isPause) return Icons.play_arrow;

    return Icons.pause;
  }

  static IconData getIconBasedOnActivationState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return Icons.download;

    if (musicPlayer.state == MusicPlayerState.open) return Icons.downloading;

    return musicPlayer.isActive ? Icons.close : Icons.play_arrow;
  }

  static String getTextBasedOnState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return "There is not song to play";

    if (musicPlayer.state == MusicPlayerState.open) return "Waiting for Pragma music";

    if (musicPlayer.state == MusicPlayerState.changingSong) return "Changing song";

    if (musicPlayer.isPause) return "Paused";

    return "Playing";
  }
}