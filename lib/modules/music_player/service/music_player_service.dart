import 'package:music_station/modules/music_player/models/play_list_song_model.dart';
import 'package:music_station/modules/music_player/interfaces/i_music_player_service.dart';

import '../../google_sheets/service/google_sheets_config.dart';
import '../models/current_song_model.dart';

class MusicPlayerService implements IMusicPlayerService {

  final GoogleSheetConfig _playlistGoogleSheetConfig;
  final GoogleSheetConfig _currentSongGoogleSheetConfig;

  MusicPlayerService({
    required GoogleSheetConfig playlistGoogleSheetSetup,
    required GoogleSheetConfig currentSongGoogleSheetSetup,
  })
      : _playlistGoogleSheetConfig = playlistGoogleSheetSetup,
        _currentSongGoogleSheetConfig = currentSongGoogleSheetSetup;


  @override
  Future<int?> getCurrentSongId() async {
    await _currentSongGoogleSheetConfig.initConfig();

    List<dynamic>? list = await _currentSongGoogleSheetConfig.service.getAllDataOfSheet(
        CurrentSong.fromJSON,
        _currentSongGoogleSheetConfig.service.sheetName,
        '${_currentSongGoogleSheetConfig.service.sheetRange.first}:${_currentSongGoogleSheetConfig.service.sheetRange.last}'
    );

    if (list == null) return null;

    return list.cast<CurrentSong>().first.idPlayList;
  }

  @override
  Future<List<PlayListSong>> getPlaylist() async {
    await _playlistGoogleSheetConfig.initConfig();

    List<dynamic>? list = await _playlistGoogleSheetConfig.service.getAllDataOfSheet(
        PlayListSong.fromJSON,
        _playlistGoogleSheetConfig.service.sheetName,
        '${_playlistGoogleSheetConfig.service.sheetRange.first}:${_playlistGoogleSheetConfig.service.sheetRange.last}'
    );

    if (list == null) return [];

    return list.cast<PlayListSong>();
  }

}