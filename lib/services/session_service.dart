abstract class SessionService {
  Future<bool> get isActive;
  Future<String> get currentUser;
}

class TestSessionService implements SessionService {
  @override
  Future<String> get currentUser => Future.value("Test User");

  @override
  Future<bool> get isActive => Future.value(false);
}