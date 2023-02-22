import 'package:music_station/modules/music_player/models/play_list_song.dart';

abstract class MusicPlayerRepository {
  Future<List<PlayListSong>> getSongs();
}

class BrandMusicPlayerRepository implements MusicPlayerRepository {
  @override
  Future<List<PlayListSong>> getSongs() async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    return Future.value([
      const PlayListSong(url: "https://www.youtube.com/watch?v=4zdoXgGnKdc", name: "Like a stone"),
      const PlayListSong(url: "https://www.youtube.com/watch?v=birrtUbd-CY", name: "Iris"),
      const PlayListSong(url: "youtube.com/watch?v=1efHXY2szuA", name: "Afuera"),
      const PlayListSong(url: "https://www.youtube.com/watch?v=98Akpf1ph2o", name: "Eres")
    ]);
  }
}