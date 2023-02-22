import 'package:music_station/modules/music_player/bloc/brand_music_player_bloc.dart';
import 'package:music_station/modules/music_player/repository/music_player_repository.dart';

import '../bloc/music_player_bloc.dart';

class MusicPlayerBlocFactory {
  static MusicPlayerBloc get() {
    return BrandMusicPlayerBloc(repository: BrandMusicPlayerRepository());
  }
}