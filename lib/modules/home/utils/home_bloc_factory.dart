import 'package:music_station/modules/home/bloc/home_bloc.dart';

import '../bloc/brand_home_bloc.dart';

class HomeBlocFactory {
  static HomeBloc get() {
    return BrandHomeBloc();
  }
}