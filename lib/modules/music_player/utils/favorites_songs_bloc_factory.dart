import 'package:music_station/modules/music_player/bloc/favorites_songs_bloc.dart';


class FavoritesSongsBlocFactory {
  static FavoritesSongsBloc get() {
    return BrandFavoritesSongBloc();
  }
}