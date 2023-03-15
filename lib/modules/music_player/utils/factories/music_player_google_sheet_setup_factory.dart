import '../../../google_sheets/provider/google_sheets_provider.dart';
import '../../../google_sheets/service/google_sheets_config.dart';
import '../../../google_sheets/service/google_sheets_service.dart';
import '../../bloc/config/config_google_sheet_current_song_bloc.dart';
import '../../bloc/config/config_google_sheet_playlist_bloc.dart';
import '../enums/music_player_google_sheet_setup_type_enum.dart';

class MusicPlayerGoogleSheetSetupFactory {
  static GoogleSheetConfig get({required MusicPlayerGoogleSheetSetupType type}){
    GoogleSheetService service = GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider());

    switch(type) {
      case MusicPlayerGoogleSheetSetupType.playlist: return ConfigGoogleSheetPlayListBloc(service: service);
      case MusicPlayerGoogleSheetSetupType.currentSong: return ConfigGoogleSheetCurrentSongBloc(service: service);
    }
  }
}