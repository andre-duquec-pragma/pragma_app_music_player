import 'package:flutter/services.dart';
import 'package:music_station/modules/music_player/utils/enums/music_player_method_channel_methods_enum.dart';

import '../../models/play_list_song_model.dart';
import '../../interfaces/i_music_player_method_channel.dart';

class MusicPlayerMethodChannelService implements IMusicPlayerMethodChannel {
  final channel = const MethodChannel("pragma_app/music_player_channel");

  @override
    Future<void> prepareToReproduceInBackground(PlayListSong? currentSong) async {
      if (currentSong == null) return;

      await channel.invokeMethod(
          MusicPlayerMethodChannelMethods.prepareForReproduceInBackground.value,
          currentSong.toJSON()
      );
    }

    @override
    Future<void> prepareToReproduceInForeground() async {
      await channel.invokeMethod(
          MusicPlayerMethodChannelMethods.prepareForReproduceInForeground.value
      );
    }


  @override
  Future<void> onListenerPlayer(Function(MethodCall call) functionCallback) async {
    channel.setMethodCallHandler((call) async{
      functionCallback(call);
    });
  }

}