import 'dart:async';
import 'dart:ui';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/music_player_model.dart';
import '../models/play_list_song_model.dart';

abstract class MusicPlayerBloc extends BlocModule {
  static String name = "musicPlayerBloc";

  late YoutubePlayerController musicPlayerController;

  MusicPlayer get value;
  Stream<MusicPlayer> get stream;

  List<PlayListSong> get playlist;

  Future<void> start();

  Future<void> handleEndedSong();

  Future<void> close();

  void handleNextReproductionStateButtonTapped();

  void handleVideoPlayerVisibilityButtonTapped();

  void goBackInNavigation();

  void handleAppLifecyclesChanges(AppLifecycleState newState);
}

