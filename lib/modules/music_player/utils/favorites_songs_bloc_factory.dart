import 'package:music_station/modules/music_player/bloc/favorites_songs_bloc.dart';
import 'package:music_station/modules/music_player/interfaces/i_favorite_song_bloc.dart';


class FavoritesSongsBlocFactory {
  static IFavoritesSongsBloc get() {
    return FavoritesSongBloc();
  }
}