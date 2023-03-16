import 'package:music_station/modules/google_sheets/service/google_sheets_config.dart';

import '../../../google_sheets/service/google_sheets_service.dart';

class ConfigGoogleSheetSongRequestBloc implements GoogleSheetConfig {
  final GoogleSheetService _service;

  ConfigGoogleSheetSongRequestBloc({required GoogleSheetService service})
      : _service = service;

  @override
  Future<void> initConfig() async {
    await _service.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A', 'D'];
    _service.intiSheetConfig('RequestList', range);
  }

  @override
  GoogleSheetService get service => _service;
}
