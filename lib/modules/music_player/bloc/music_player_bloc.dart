import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:music_station/modules/music_player/entities/play_list_song.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../entities/music_player.dart';

abstract class MusicPlayerBloc extends BlocModule {
  static String name = "musicPlayerBloc";

  late YoutubePlayerController musicPlayerController;

  MusicPlayer get value;
  Stream<MusicPlayer> get stream;

  List<PlayListSong> get playlist;

  Future<void> loadSongs();

  Future<void> start();

  Future<void> close();

  void handleNextReproductionStateButtonTapped();

  void handleVideoPlayerVisibilityButtonTapped();

  void back();

  void handleAppLifecyclesChanges(AppLifecycleState newState);

  Future<void> handleEndedSong();
}

