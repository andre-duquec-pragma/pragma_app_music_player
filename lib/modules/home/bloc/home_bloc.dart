import 'package:music_station/entities/entity_bloc.dart';

abstract class HomeBloc extends BlocModule {
  static const name = "homeBloc";

  void navigate(String pageName);
}

