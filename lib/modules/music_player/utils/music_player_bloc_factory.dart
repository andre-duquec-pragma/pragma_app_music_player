import 'package:music_station/modules/music_player/bloc/brand_music_player_bloc.dart';
import 'package:music_station/modules/music_player/channel/brand_music_player_method_channel.dart';
import 'package:music_station/modules/music_player/repository/music_player_repository.dart';

import '../bloc/config_sheet_player.dart';
import '../bloc/music_player_bloc.dart';

class MusicPlayerBlocFactory {
  static Future<MusicPlayerBloc> get() async {
    return BrandMusicPlayerBloc(
        repository: BrandMusicPlayerRepository(
            service: googleSheetForPlayList
        ),
        channel: BrandMusicPlayerMethodChannel()
    );
  }
}