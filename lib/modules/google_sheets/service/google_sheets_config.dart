import 'google_sheets_service.dart';

abstract class GoogleSheetConfig {
  GoogleSheetService get service;
  Future<void> initConfig();
}
