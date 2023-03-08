import 'package:music_station/modules/google_sheets/service/google_sheets_service.dart';
import 'package:music_station/modules/music_player/entities/play_list_song.dart';

import '../bloc/config_sheet_player.dart';


abstract class MusicPlayerRepository {
  Future<List<PlayListSong>> getSongs();
}

class BrandMusicPlayerRepository implements MusicPlayerRepository {

  final IGoogleSheetService service;

  const BrandMusicPlayerRepository({required this.service});

  @override
  Future<List<PlayListSong>> getSongs() async {

    await ConfigSheetPlayListBloc().initConfig();

    var list = await service.getAllDataOfSheet(
        PlayListSong.fromJSON,
        GoogleSheetService.sheetName,
        '${GoogleSheetService.sheetRange.first}:${GoogleSheetService.sheetRange.last}'
    );

    if (list == null) return [];

    return list.cast<PlayListSong>();
  }
}