import 'package:music_station/modules/music_player/bloc/brand_music_player_bloc.dart';
import 'package:music_station/modules/music_player/bloc/config_sheet_player_current_song.dart';
import 'package:music_station/modules/music_player/channel/brand_music_player_method_channel.dart';
import 'package:music_station/modules/music_player/repository/music_player_repository.dart';

import '../bloc/config_sheet_player_playlist.dart';
import '../bloc/music_player_bloc.dart';

class MusicPlayerBlocFactory {
  static Future<MusicPlayerBloc> get() async {
    return BrandMusicPlayerBloc(
        playListRepository: BrandMusicPlayerRepository(
            service: googleSheetForPlayList
        ),
        currentSongRepository: BrandCurrentSongRepository(
          service: googleSheetForCurrentSong
        ),
        channel: BrandMusicPlayerMethodChannel()
    );
  }
}