import 'package:music_station/modules/music_player/entities/play_list_song.dart';

abstract class MusicPlayerRepository {
  Future<List<PlayListSong>> getSongs();
}

class BrandMusicPlayerRepository implements MusicPlayerRepository {
  @override
  Future<List<PlayListSong>> getSongs() async {
    //await Future.delayed(const Duration(seconds: 0, milliseconds: 100));
    return Future.value([
      const PlayListSong(url: "https://www.youtube.com/watch?v=qNHcVevz7wo", name: "WonderWall"),
      const PlayListSong(url: "https://www.youtube.com/watch?v=4zdoXgGnKdc", name: "Like a stone"),
      const PlayListSong(url: "https://www.youtube.com/watch?v=birrtUbd-CY", name: "Iris"),
      const PlayListSong(url: "https://www.youtube.com/watch?v=UlCmtFA9iOo", name: "Drive"),
    ]);
  }
}