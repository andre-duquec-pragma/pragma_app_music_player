import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:music_station/modules/music_player/repository/music_player_repository.dart';
import 'package:music_station/modules/music_player/utils/music_player_state.dart';

import '../../../app_config.dart';
import '../../../blocs/navigator_bloc.dart';
import '../entities/music_player.dart';
import '../models/play_list_song.dart';
import 'music_player_bloc.dart';

class BrandMusicPlayerBloc implements MusicPlayerBloc {
  final Queue<PlayListSong> _songs = Queue();
  final MusicPlayerRepository _repository;

  BrandMusicPlayerBloc({required MusicPlayerRepository repository}) : _repository = repository {
    _listenMusicPlayerChanges();
  }

  final BlocGeneral<MusicPlayer> _musicPlayerBloc = BlocGeneral(
      MusicPlayer(state: MusicPlayerState.closed)
  );

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
    if (_songs.isEmpty) {
      changeState(MusicPlayerState.changingSong);
    }

    List<PlayListSong> songs = await _repository.getSongs();
    _songs.addAll(songs);
  }

  @override
  Future<void> start() async {
    await _getPlaylistSongs();

    if (_songs.isEmpty) {
      changeState(MusicPlayerState.notSongsAvailable);
      return;
    }

    var song = _songs.first;
    _musicPlayerBloc.value = MusicPlayer(currentSong: song, state: MusicPlayerState.playing);

    _songs.remove(song);
  }

  @override
  Future<void> close() async {
    _songs.clear();
    _musicPlayerBloc.value = MusicPlayer(state: MusicPlayerState.closed);
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

    _musicPlayerBloc.value = MusicPlayer(
        currentSong: currentValue.currentSong,
        state: newState
    );
  }

  @override
  void prepareBeforePresent() {
    if (currentValue.isPlaying) {
      changeState(MusicPlayerState.playingInForeground);
      return;
    }

    if (currentValue.isPause) {
      changeState(MusicPlayerState.pauseInForeground);
    }
  }

  @override
  void back() {
    if (currentValue.isActive) {
      MusicPlayerState newState = currentValue.isPlaying
          ? MusicPlayerState.playingInBackground
          : MusicPlayerState.pauseInBackground;

      changeState(newState);
    }

    blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).back();
  }

  @override
  FutureOr<void> dispose() {}
}