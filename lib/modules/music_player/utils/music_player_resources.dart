import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/utils/video_player_visibility_state.dart';

import '../models/music_player_model.dart';
import 'music_player_state.dart';

class MusicPlayerResources {

  static IconData getReproductionButtonIconBasedOnState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return Icons.block;

    if(musicPlayer.state == MusicPlayerState.open) return Icons.downloading;

    if (musicPlayer.state == MusicPlayerState.changingSong) return Icons.downloading;

    if (musicPlayer.isPause) return Icons.play_arrow;

    return Icons.pause;
  }

  static IconData getActivationButtonIconBasedOnState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return Icons.download;

    if (musicPlayer.state == MusicPlayerState.open) return Icons.downloading;

    if (musicPlayer.state == MusicPlayerState.songsLoaded) return Icons.play_arrow;

    return musicPlayer.isActive ? Icons.close : Icons.play_arrow;
  }

  static String getFloatingMusicPlayerTextBasedOnState(MusicPlayer? musicPlayer) {
    if(musicPlayer?.state == MusicPlayerState.notSongsAvailable || musicPlayer == null) return "There is not song to play";

    if (musicPlayer.state == MusicPlayerState.open) return "Waiting for Pragma music";

    if (musicPlayer.state == MusicPlayerState.changingSong) return "Changing song";

    if (musicPlayer.isPause) return "Paused";

    return "Playing";
  }

  static IconData getVideoVisibilityButtonIconBasedOnState(VideoPlayerVisibilityState state) {
    return state == VideoPlayerVisibilityState.hidden
        ? Icons.open_in_browser
        : Icons.hide_source;
  }
}