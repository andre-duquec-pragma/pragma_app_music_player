import '../../google_sheets/helpers/google_sheet_use_helper.dart';
import '../../google_sheets/provider/google_sheets_provider.dart';
import '../../google_sheets/service/google_sheets_service.dart';

GoogleSheetService googleSheetForPlayList =  GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider());

class GoogleSheetPlayListBlocSetup extends GoogleSheetSetup {
  final GoogleSheetService _service;

  GoogleSheetPlayListBlocSetup({required GoogleSheetService service}) : _service = service;

  @override
  GoogleSheetService get service => _service;

  @override
  Future<void> initConfig() async {
    await service.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A','D'];
    service.intiSheetConfig('PlayList', range);
  }
}