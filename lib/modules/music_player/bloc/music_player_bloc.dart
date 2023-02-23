import 'dart:async';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:music_station/modules/music_player/utils/music_player_state.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../entities/music_player.dart';

abstract class MusicPlayerBloc extends BlocModule {
  static String name = "musicPlayerBloc";

  late YoutubePlayerController controller;

  MusicPlayer get currentValue;
  Stream<MusicPlayer> get currentMusicPlayerStream;

  Future<void> start();

  Future<void> close();

  void changeState(MusicPlayerState newState);

  void handleButtonTap();

  void back();
}

