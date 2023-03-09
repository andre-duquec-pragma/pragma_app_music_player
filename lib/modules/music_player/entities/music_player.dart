import '../utils/video_player_visibility_state.dart';
import 'play_list_song.dart';
import '../utils/music_player_state.dart';

class MusicPlayer {
  final PlayListSong? currentSong;
  final MusicPlayerState state;
  final VideoPlayerVisibilityState videoVisibilityState;
  final DateTime? lastStateChangeTime;

  const MusicPlayer({this.currentSong, required this.state, required this.videoVisibilityState, this.lastStateChangeTime});

  bool get isActive => ( state != MusicPlayerState.closed && state != MusicPlayerState.songsLoaded && state != MusicPlayerState.notSongsAvailable );
  bool get isPlaying => (state == MusicPlayerState.playing);
  bool get isPause => (state == MusicPlayerState.pause);
  bool get isReady => (isPlaying || isPause);

  MusicPlayer copyWith({
    PlayListSong? currentSong,
    MusicPlayerState? state,
    VideoPlayerVisibilityState? videoVisibilityState,
    DateTime? lastStateChangeTime
  }) {
    return MusicPlayer(
        currentSong: currentSong ?? this.currentSong,
        state: state ?? this.state,
        videoVisibilityState: videoVisibilityState ?? this.videoVisibilityState,
        lastStateChangeTime: lastStateChangeTime ?? this.lastStateChangeTime
    );
  }

  bool isSongStillTheCurrentSong(Duration currentSongDuration) {
    if (lastStateChangeTime == null) return false;

    DateTime currentTime = DateTime.now();
    DateTime songEndTime = lastStateChangeTime!.add(currentSongDuration);

    return songEndTime.isAfter(currentTime);
  }

  @override
  String toString() {
    return "state: $state | song: ${currentSong?.songName}";
  }
}