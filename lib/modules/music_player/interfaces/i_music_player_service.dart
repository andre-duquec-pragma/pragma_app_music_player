import '../models/play_list_song_model.dart';

abstract class IMusicPlayerService {
  Future<int?> getCurrentSongId();
  Future<List<PlayListSong>> getPlaylist();
}