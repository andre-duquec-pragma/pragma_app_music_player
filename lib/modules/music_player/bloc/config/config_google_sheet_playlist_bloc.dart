import '../../../google_sheets/service/google_sheets_config.dart';
import '../../../google_sheets/service/google_sheets_service.dart';

class ConfigGoogleSheetPlayListBloc implements GoogleSheetConfig {

  final GoogleSheetService _service;

  ConfigGoogleSheetPlayListBloc({required GoogleSheetService service}): _service = service;

  @override
  Future<void> initConfig() async {
    await _service.initInstanceOfGoogleSheetProvider();
    const List<String> range = ['A','D'];
    _service.intiSheetConfig('PlayList', range);
  }

  @override
  GoogleSheetService get service => _service;
}