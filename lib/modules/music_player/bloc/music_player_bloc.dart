import 'dart:async';
import 'dart:ui';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:music_station/modules/music_player/utils/music_player_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../entities/music_player.dart';

abstract class MusicPlayerBloc extends BlocModule {
  static String name = "musicPlayerBloc";

  late YoutubePlayerController musicPlayerController;

  MusicPlayer get currentValue;
  Stream<MusicPlayer> get currentMusicPlayerStream;

  Future<void> start();

  Future<void> close();

  void changeState(MusicPlayerState newState);

  void handleButtonTap();

  void back();

  void handleAppLifecyclesChanges(AppLifecycleState newState);

  Future<void> handleEndedSong();
}

