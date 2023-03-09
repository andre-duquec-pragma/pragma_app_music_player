import 'package:music_station/modules/google_sheets/service/google_sheets_service.dart';
import 'package:music_station/modules/music_player/bloc/config_sheet_player_current_song.dart';
import 'package:music_station/modules/music_player/entities/current_song.dart';
import 'package:music_station/modules/music_player/entities/play_list_song.dart';

import '../bloc/config_sheet_player_playlist.dart';


abstract class MusicPlayerRepository {
  Future<List<PlayListSong>> getSongs();
}

abstract class CurrentSongRepository {
  Future<int?> getCurrentSongId();
}

class BrandMusicPlayerRepository implements MusicPlayerRepository {

  final GoogleSheetService service;

  const BrandMusicPlayerRepository({required this.service});

  @override
  Future<List<PlayListSong>> getSongs() async {

    await ConfigGoogleSheetPlayListBloc().initConfig();

    List<dynamic>? list = await service.getAllDataOfSheet(
        PlayListSong.fromJSON,
        service.sheetName,
        '${service.sheetRange.first}:${service.sheetRange.last}'
    );

    if (list == null) return [];

    return list.cast<PlayListSong>();
  }
}

class BrandCurrentSongRepository implements CurrentSongRepository {
  final GoogleSheetService service;

  const BrandCurrentSongRepository({required this.service});

  @override
  Future<int?> getCurrentSongId() async {
    await ConfigGoogleSheetCurrentSongBloc().initConfig();

    List<dynamic>? id = await service.getAllDataOfSheet(
        CurrentSong.fromJSON,
        service.sheetName,
        '${service.sheetRange.first}:${service.sheetRange.last}'
    );

    if (id == null) return null;

    return id.cast<CurrentSong>().first.idPlayList;
  }
}