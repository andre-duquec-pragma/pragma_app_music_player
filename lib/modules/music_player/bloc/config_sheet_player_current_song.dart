import 'package:music_station/modules/google_sheets/helpers/google_sheet_use_helper.dart';

import '../../google_sheets/service/google_sheets_service.dart';

class GoogleSheetCurrentSongBlocSetup extends GoogleSheetSetup {
  final GoogleSheetService _service;

  GoogleSheetCurrentSongBlocSetup({required GoogleSheetService service}) : _service = service;

  @override
  GoogleSheetService get service => _service;

  @override
  Future<void> initConfig() async {
    await service.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A','A'];
    service.intiSheetConfig('MusicPlayer', range);
  }
}
