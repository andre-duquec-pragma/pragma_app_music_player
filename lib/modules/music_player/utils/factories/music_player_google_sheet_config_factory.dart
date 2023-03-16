import 'package:music_station/modules/music_player/bloc/config/config_google_sheet_songs_request.dart';

import '../../../google_sheets/provider/google_sheets_provider.dart';
import '../../../google_sheets/service/google_sheets_config.dart';
import '../../../google_sheets/service/google_sheets_service.dart';
import '../../bloc/config/config_google_sheet_current_song_bloc.dart';
import '../../bloc/config/config_google_sheet_playlist_bloc.dart';
import '../enums/music_player_google_sheet_config_type_enum.dart';

class MusicPlayerGoogleSheetSetupFactory {
  static GoogleSheetConfig get(
      {required MusicPlayerGoogleSheetConfigType type}) {
    GoogleSheetService service =
        GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider());

    switch (type) {
      case MusicPlayerGoogleSheetConfigType.playlist:
        return ConfigGoogleSheetPlayListBloc(service: service);
      case MusicPlayerGoogleSheetConfigType.currentSong:
        return ConfigGoogleSheetCurrentSongBloc(service: service);
      case MusicPlayerGoogleSheetConfigType.songRequest:
        return ConfigGoogleSheetSongRequestBloc(service: service);
    }
  }
}
