import 'package:music_station/providers/my_app_navigator_provider.dart';

class ExecuteAttemptsHelper {

  static Future<bool> makeAttempt({
    required Function functionToExecute,
    required bool Function() executionCondition,
    int availableAttempts = 3,
    Duration timeBetweenAttempts = const Duration(milliseconds: 500),
    String functionDescription = "some"
  }) async {
    if (availableAttempts <= 0) return Future.value(false);

    if (executionCondition()) {
      functionToExecute();
      return Future.value(true);
    }

    int newAvailableAttempts = availableAttempts - 1;
    debugPrint("Somethings went wrong with $functionDescription function. Trying to execute again. Attempts available: $newAvailableAttempts");
    await Future.delayed(timeBetweenAttempts);

    return await makeAttempt(
      functionToExecute: functionToExecute,
      executionCondition: executionCondition,
      availableAttempts:  newAvailableAttempts,
      timeBetweenAttempts: timeBetweenAttempts,
      functionDescription: functionDescription
    );
  }
}