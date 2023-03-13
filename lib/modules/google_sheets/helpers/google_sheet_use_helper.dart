import 'package:music_station/modules/google_sheets/service/google_sheets_service.dart';

abstract class GoogleSheetSetup {
  GoogleSheetService get service;
  Future<void> initConfig();
}

class GoogleSheetUseHelper<T> {
  Future<List<T>?> getAllData(
    GoogleSheetSetup googleSheetSetup,
    T Function(Map<String, dynamic>) fromJSON
  ) async {
    await googleSheetSetup.initConfig();

    List<dynamic>? list = await googleSheetSetup.service.getAllDataOfSheet(
        fromJSON,
        googleSheetSetup.service.sheetName,
        '${googleSheetSetup.service.sheetRange.first}:${googleSheetSetup.service.sheetRange.last}'
    );

    if (list == null) return null;

    return list.cast<T>();
  }
}