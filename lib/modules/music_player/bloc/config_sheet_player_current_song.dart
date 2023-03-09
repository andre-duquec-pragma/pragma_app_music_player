import '../../google_sheets/provider/google_sheets_provider.dart';
import '../../google_sheets/service/google_sheets_service.dart';

GoogleSheetService googleSheetForCurrentSong =
GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider());

class ConfigGoogleSheetCurrentSongBloc {
  Future<void> initConfig() async {
    await googleSheetForCurrentSong.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A','A'];
    googleSheetForCurrentSong.intiSheetConfig('MusicPlayer', range);
  }
}
