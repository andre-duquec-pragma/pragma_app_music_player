import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:music_station/modules/music_player/utils/execute_attempts_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../app_config.dart';
import '../../../blocs/navigator_bloc.dart';
import '../../../entities/entity_bloc.dart';
import '../channel/music_player_method_channel.dart';
import '../entities/music_player.dart';
import '../entities/play_list_song.dart';
import '../repository/music_player_repository.dart';
import '../utils/music_player_state.dart';
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

    musicPlayerController = YoutubePlayerController(
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
  late YoutubePlayerController musicPlayerController;

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

    await _loadSongs(
      onSongsLoaded: () => {
        _reproduceNextSong()
      }
    );
  }

  Future<void> _loadSongs({required VoidCallback onSongsLoaded}) async {
    await _getPlaylistSongs();

    if (_songs.isEmpty) {
      changeState(MusicPlayerState.notSongsAvailable);
      return;
    }

    onSongsLoaded();
  }

  Future<void> _reproduceNextSong() async {
    PlayListSong song = _songs.first;
    String? songId = song.getId();

    if (songId == null) {
      changeState(MusicPlayerState.notSongsAvailable);
      return;
    }

    bool musicPlayerIsStarted = await _tryStartMusicPlayer(songId);

    if (!musicPlayerIsStarted) {
      _handleMusicPlayerNotStarted();
      return;
    }

    _musicPlayerBloc.value =
        MusicPlayer(currentSong: song, state: MusicPlayerState.playing);

    _songs.remove(song);
  }

  void _handleMusicPlayerNotStarted() {
    changeState(MusicPlayerState.notSongsAvailable);
    musicPlayerController.reset();
  }

  bool _isMusicPlayerReadyToPlay() => (musicPlayerController.value.isReady || musicPlayerController.value.isPlaying);

  Future<bool> _tryStartMusicPlayer(String songId) async {
    return await ExecuteAttemptsHelper.makeAttempt(
        functionToExecute: () => {
          musicPlayerController.load(songId)
        },
        executionCondition: _isMusicPlayerReadyToPlay,
        timeBetweenAttempts: const Duration(seconds: 1),
        functionDescription: "Start music player"
    );
  }

  Future<void> _tryReproduceNextSong() async {
    if (_songs.isNotEmpty) {
      _reproduceNextSong();
      return;
    }

    await _loadSongs(
      onSongsLoaded: () => {
        _reproduceNextSong()
      }
    );
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
    if (currentValue.state == MusicPlayerState.notSongsAvailable) return;

    currentValue.isPlaying
        ? _pause()
        : _play();
  }

  void _pause() {
    changeState(MusicPlayerState.pause);
    musicPlayerController.pause();
  }

  void _play() {
    changeState(MusicPlayerState.playing);
    musicPlayerController.play();
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
      _play();
      _channel.prepareToReproduceInBackground(currentValue.currentSong);
    });
  }

  Future<void> _handleAppInForeground() async {
    _play();
    _channel.prepareToReproduceInForeground();
  }

  @override
  Future<void> handleEndedSong() async {
    _musicPlayerBloc.value = MusicPlayer(state: MusicPlayerState.changingSong);
    await _tryReproduceNextSong();
  }

  @override
  FutureOr<void> dispose() {
    _musicPlayerBloc.dispose();
  }
}
