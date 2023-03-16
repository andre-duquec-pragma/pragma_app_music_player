import 'package:music_station/modules/google_sheets/service/google_sheets_config.dart';
import 'package:music_station/modules/music_player/interfaces/i_songs_request_service.dart';

class SongsRequestService implements ISongsRequestService {
  final GoogleSheetConfig _songRequestGoogleSheetConfig;

  SongsRequestService({
    required GoogleSheetConfig songRequestGoogleSheetConfig,
  }) : _songRequestGoogleSheetConfig = songRequestGoogleSheetConfig;

  @override
  Future<void> createSongRequest(Map<String, dynamic> data) async {
    await _songRequestGoogleSheetConfig.initConfig();
    _songRequestGoogleSheetConfig.service.insertDataInSheet(
        data: data,
        sheet: _songRequestGoogleSheetConfig.service.sheetName,
        range:
            '${_songRequestGoogleSheetConfig.service.sheetRange.first}:${_songRequestGoogleSheetConfig.service.sheetRange.last}');
  }
}
