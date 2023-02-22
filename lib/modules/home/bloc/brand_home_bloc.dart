import 'dart:async';

import '../../../app_config.dart';
import '../../../blocs/navigator_bloc.dart';
import 'home_bloc.dart';

class BrandHomeBloc implements HomeBloc {
  @override
  void navigate(String pageName) {
    blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).pushNamed(pageName);
  }

  @override
  FutureOr<void> dispose() {}
}