import '../../google_sheets/provider/google_sheets_provider.dart';
import '../../google_sheets/service/google_sheets_service.dart';

GoogleSheetService googleSheetForPlayList =
GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider());

class ConfigSheetPlayListBloc {
  Future<void> initConfig() async {
    await googleSheetForPlayList.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A','D'];
    googleSheetForPlayList.intiSheetConfig('PlayList', range);
  }
}



