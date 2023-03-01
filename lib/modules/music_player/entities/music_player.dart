import 'play_list_song.dart';
import '../utils/music_player_state.dart';

class MusicPlayer {
  PlayListSong? currentSong;
  MusicPlayerState state;

  MusicPlayer({this.currentSong, required this.state});

  bool get isActive => (state != MusicPlayerState.closed);
  bool get isPlaying => (state == MusicPlayerState.playing);
  bool get isPause => (state == MusicPlayerState.pause);

  @override
  String toString() {
    return "state: $state | song: ${currentSong?.name}";
  }
}