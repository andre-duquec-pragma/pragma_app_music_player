import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:music_station/modules/music_player/repository/music_player_repository.dart';
import 'package:music_station/modules/music_player/utils/music_player_state.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../app_config.dart';
import '../../../blocs/navigator_bloc.dart';
import '../entities/music_player.dart';
import '../entities/play_list_song.dart';
import 'music_player_bloc.dart';

class BrandMusicPlayerBloc implements MusicPlayerBloc {
  final Queue<PlayListSong> _songs = Queue();
  final MusicPlayerRepository _repository;

  BrandMusicPlayerBloc({required MusicPlayerRepository repository}) : _repository = repository {
    _listenMusicPlayerChanges();
    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: false,
      ),
    );
  }

  final BlocGeneral<MusicPlayer> _musicPlayerBloc = BlocGeneral(
      MusicPlayer(state: MusicPlayerState.closed)
  );

  @override
  late YoutubePlayerController controller;

  @override
  MusicPlayer get currentValue => _musicPlayerBloc.value;

  @override
  Stream<MusicPlayer> get currentMusicPlayerStream => _musicPlayerBloc.stream;

  void _listenMusicPlayerChanges() {
    currentMusicPlayerStream.listen((event) {
      if (kDebugMode) { print("Music player update -> $event"); }
    });
  }

  Future<void> _getPlaylistSongs() async {
    List<PlayListSong> songs = await _repository.getSongs();
    _songs.addAll(songs);
  }

  @override
  Future<void> start() async {
    changeState(MusicPlayerState.open);

    await _getPlaylistSongs();

    if (_songs.isEmpty) {
      changeState(MusicPlayerState.notSongsAvailable);
      return;
    }

    var song = _songs.first;
    _musicPlayerBloc.value = MusicPlayer(currentSong: song, state: MusicPlayerState.playing);

    _startYoutubePlayer();
  }

  void _startYoutubePlayer() {
    List<String> songsId = List.of(
        _songs
            .map((e) => e.getId())
            .where((element) => element.isNotEmpty)
    );

    controller.loadPlaylist(
      list: songsId,
      listType: ListType.playlist,
    );
  }

  @override
  Future<void> close() async {
    _songs.clear();
    controller.close();
    changeState(MusicPlayerState.closed);
  }

  @override
  void changeState(MusicPlayerState newState) {
    _musicPlayerBloc.value = MusicPlayer(
        currentSong: currentValue.currentSong,
        state: newState
    );
  }

  @override
  void handleButtonTap() {
    MusicPlayerState newState = currentValue.isPlaying
        ? MusicPlayerState.pause
        : MusicPlayerState.playing;

    VoidCallback action = newState == MusicPlayerState.pause
        ? controller.pauseVideo
        : controller.playVideo;

    _musicPlayerBloc.value = MusicPlayer(
        currentSong: currentValue.currentSong,
        state: newState
    );

    action();
  }

  @override
  void back() {
    blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).back();
  }

  @override
  void handleAppLifecyclesChanges(AppLifecycleState newState) {
    if(newState == AppLifecycleState.inactive && currentValue.isPlaying) {
      handleAppInBackground();
      return;
    }

    if(newState == AppLifecycleState.resumed && currentValue.isPlaying) {
      controller.playVideo();
    }
  }

  Future<void> handleAppInBackground() async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      controller.playVideo();
    });
  }

  @override
  FutureOr<void> dispose() {
    _musicPlayerBloc.dispose();
  }
}