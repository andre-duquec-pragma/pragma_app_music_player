import '../../../google_sheets/provider/google_sheets_provider.dart';
import '../../../google_sheets/service/google_sheets_service.dart';

GoogleSheetService googleSheetForFavoriteSong =
GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider());

class ConfigSheetRequestList {
  Future<void> initConfig() async {
    await googleSheetForFavoriteSong.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A','D'];
    googleSheetForFavoriteSong.intiSheetConfig('RequestList', range);
  }
}
