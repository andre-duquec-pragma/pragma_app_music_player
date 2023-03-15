import 'package:music_station/modules/music_player/models/play_list_song_model.dart';
import 'package:music_station/modules/music_player/interfaces/i_music_player_service.dart';

import '../../google_sheets/service/google_sheets_config.dart';
import '../models/current_song_model.dart';

class MusicPlayerService implements IMusicPlayerService {

  final GoogleSheetConfig _playlistGoogleSheetSetup;
  final GoogleSheetConfig _currentSongGoogleSheetSetup;

  MusicPlayerService({
    required GoogleSheetConfig playlistGoogleSheetSetup,
    required GoogleSheetConfig currentSongGoogleSheetSetup,
  })
      : _playlistGoogleSheetSetup = playlistGoogleSheetSetup,
        _currentSongGoogleSheetSetup = currentSongGoogleSheetSetup;


  @override
  Future<int?> getCurrentSongId() async {
    await _currentSongGoogleSheetSetup.initConfig();

    List<dynamic>? list = await _currentSongGoogleSheetSetup.service.getAllDataOfSheet(
        CurrentSong.fromJSON,
        _currentSongGoogleSheetSetup.service.sheetName,
        '${_currentSongGoogleSheetSetup.service.sheetRange.first}:${_currentSongGoogleSheetSetup.service.sheetRange.last}'
    );

    if (list == null) return null;

    return list.cast<CurrentSong>().first.idPlayList;
  }

  @override
  Future<List<PlayListSong>> getPlaylist() async {
    await _playlistGoogleSheetSetup.initConfig();

    List<dynamic>? list = await _playlistGoogleSheetSetup.service.getAllDataOfSheet(
        PlayListSong.fromJSON,
        _playlistGoogleSheetSetup.service.sheetName,
        '${_playlistGoogleSheetSetup.service.sheetRange.first}:${_playlistGoogleSheetSetup.service.sheetRange.last}'
    );

    if (list == null) return [];

    return list.cast<PlayListSong>();
  }

}