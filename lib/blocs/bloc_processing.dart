import '../entities/entity_bloc.dart';

class BlocProcessing extends BlocModule {
  static const name = 'procesingName';
  final _blocProcessing = BlocGeneral<String>('');

  String get procesingMsg => _blocProcessing.value;

  Stream<String> get procesingStream => _blocProcessing.stream;

  set procesingMsg(String msg) {
    _blocProcessing.value = msg;
  }

  void loadingWithDelay(String msg, int milliseconds) {
    procesingMsg = msg;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      procesingMsg = '';
    });
  }

  void loadingWithFutureFunction(String msg, Future<String?> function) async {
    procesingMsg = msg;
    await function;
    procesingMsg = '';
  }

  @override
  dispose() {
    _blocProcessing.dispose();
  }
}
