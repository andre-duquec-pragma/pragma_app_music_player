import 'package:music_station/services/session_service.dart';

class SessionServiceFactory {
  static SessionService get() {
    return TestSessionService();
  }
}
