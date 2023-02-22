import '../models/play_list_song.dart';
import '../utils/floating_music_player_state.dart';
import '../utils/music_player_state.dart';

class MusicPlayer {
  PlayListSong? currentSong;
  MusicPlayerState state;

  MusicPlayer({this.currentSong, required this.state});

  bool get isActive => (state != MusicPlayerState.closed && state != MusicPlayerState.notSongsAvailable);
  bool get isPlaying => (state == MusicPlayerState.playing || state == MusicPlayerState.playingInBackground || state == MusicPlayerState.playingInForeground);
  bool get isPause => (state == MusicPlayerState.pause || state == MusicPlayerState.pauseInBackground || state == MusicPlayerState.pauseInForeground);

  FloatingMusicPlayerState getStateOfFloatingMusicPlayer() {
    if (state == MusicPlayerState.playingInBackground
        || state == MusicPlayerState.pauseInBackground) {
      return FloatingMusicPlayerState.show;
    }

    if (state == MusicPlayerState.closed
        || state == MusicPlayerState.playingInForeground
        || state == MusicPlayerState.pauseInForeground) {
      return FloatingMusicPlayerState.hide;
    }

    return FloatingMusicPlayerState.unknown;
  }

  @override
  String toString() {
    return "state: $state | song: ${currentSong?.name}";
  }
}