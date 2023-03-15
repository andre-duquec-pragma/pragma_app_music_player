import '../../../google_sheets/service/google_sheets_config.dart';
import '../../../google_sheets/service/google_sheets_service.dart';

class ConfigGoogleSheetCurrentSongBloc implements GoogleSheetConfig {

  final GoogleSheetService _service;

  ConfigGoogleSheetCurrentSongBloc({required GoogleSheetService service}): _service = service;

  @override
  Future<void> initConfig() async {
    await _service.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A','A'];
    _service.intiSheetConfig('MusicPlayer', range);
  }

  @override
  GoogleSheetService get service => _service;
}