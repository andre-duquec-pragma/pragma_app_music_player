import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/utils/enums/video_player_visibility_state_enum.dart';

import '../../models/music_player_model.dart';
import '../enums/music_player_state_enum.dart';

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