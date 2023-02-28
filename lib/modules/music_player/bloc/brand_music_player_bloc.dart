import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:music_station/modules/music_player/repository/music_player_repository.dart';
import 'package:music_station/modules/music_player/utils/music_player_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../app_config.dart';
import '../../../blocs/navigator_bloc.dart';
import '../channel/music_player_method_channel.dart';
import '../entities/music_player.dart';
import '../entities/play_list_song.dart';
import 'music_player_bloc.dart';

class BrandMusicPlayerBloc implements MusicPlayerBloc {
  final Queue<PlayListSong> _songs = Queue();
  final MusicPlayerRepository _repository;
  final MusicPlayerMethodChannel _channel;

  BrandMusicPlayerBloc({
    required MusicPlayerRepository repository,
    required MusicPlayerMethodChannel channel
  }) : _repository = repository, _channel = channel {
    _listenMusicPlayerChanges();
    controller = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        mute: false,
        hideControls: false,
        hideThumbnail: true,
        showLiveFullscreenButton: false,
      ),
    );
  }

  final BlocGeneral<MusicPlayer> _musicPlayerBloc =
      BlocGeneral(MusicPlayer(state: MusicPlayerState.closed));

  @override
  late YoutubePlayerController controller;

  @override
  MusicPlayer get currentValue => _musicPlayerBloc.value;

  @override
  Stream<MusicPlayer> get currentMusicPlayerStream => _musicPlayerBloc.stream;

  void _listenMusicPlayerChanges() {
    currentMusicPlayerStream.listen((event) {
      debugPrint("Music player update -> $event");
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
    _musicPlayerBloc.value =
        MusicPlayer(currentSong: song, state: MusicPlayerState.playing);

    _startYoutubePlayer();
  }

  void _startYoutubePlayer() {
    List<String> songsId = List.of(
        _songs
        .map((e) => e.getId())
        .where((element) => element.isNotEmpty)
    );
    controller.load(songsId.first);
  }

  @override
  Future<void> close() async {
    _songs.clear();
    changeState(MusicPlayerState.closed);
  }

  @override
  void changeState(MusicPlayerState newState) {
    _musicPlayerBloc.value =
        MusicPlayer(currentSong: currentValue.currentSong, state: newState);
  }

  @override
  void handleButtonTap() {
    MusicPlayerState newState = currentValue.isPlaying
        ? MusicPlayerState.pause
        : MusicPlayerState.playing;

    _musicPlayerBloc.value =
        MusicPlayer(currentSong: currentValue.currentSong, state: newState);
    newState == MusicPlayerState.pause
        ? controller.pause()
        : controller.play();
  }

  @override
  void back() {
    blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).back();
  }

  @override
  void handleAppLifecyclesChanges(AppLifecycleState newState) {
    if(newState == AppLifecycleState.inactive && currentValue.isPlaying) {
      _handleAppInBackground();
      return;
    }

    if(newState == AppLifecycleState.resumed && currentValue.isPlaying) {
      _handleAppInForeground();
    }
  }

  Future<void> _handleAppInBackground() async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      controller.play();
      _channel.prepareToReproduceInBackground(currentValue.currentSong);
    });
  }

  Future<void> _handleAppInForeground() async {
    controller.play();
    _channel.prepareToReproduceInForeground();
  }

  @override
  FutureOr<void> dispose() {
    _musicPlayerBloc.dispose();
  }
}
