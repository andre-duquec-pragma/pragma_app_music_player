import 'dart:async';

import '../../../entities/entity_bloc.dart';

class CounterBloc extends BlocModule {
  static const name = 'counterBloc';

  final BlocGeneral<int> _counterBloc = BlocGeneral<int>(0);

  int get counterValue => _counterBloc.value;
  Stream<int> get counterValueStream => _counterBloc.stream;

  @override
  FutureOr<void> dispose() {}
}
