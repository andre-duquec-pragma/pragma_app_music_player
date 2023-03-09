import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:music_station/modules/music_player/utils/execute_attempts_helper.dart';
import 'package:music_station/modules/music_player/utils/video_player_visibility_state.dart';
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
  final List<PlayListSong> _songs = [];
  final MusicPlayerRepository _playListRepository;
  final CurrentSongRepository _currentSongRepository;
  final MusicPlayerMethodChannel _channel;

  BrandMusicPlayerBloc({
    required MusicPlayerRepository playListRepository,
    required CurrentSongRepository currentSongRepository,
    required MusicPlayerMethodChannel channel
  })
      : _playListRepository = playListRepository,
        _currentSongRepository = currentSongRepository,
        _channel = channel {
    _listenMusicPlayerChanges();

    musicPlayerController = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        mute: false,
        hideControls: true,
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        enableCaption: false
      ),
    );
  }

  final BlocGeneral<MusicPlayer> _musicPlayerBloc =
    BlocGeneral(
      const MusicPlayer(
        state: MusicPlayerState.closed,
        videoVisibilityState: VideoPlayerVisibilityState.hidden
      )
    );

  @override
  late YoutubePlayerController musicPlayerController;

  @override
  MusicPlayer get value => _musicPlayerBloc.value;

  @override
  Stream<MusicPlayer> get stream => _musicPlayerBloc.stream;

  @override
  List<PlayListSong> get playlist => _songs;

  void _listenMusicPlayerChanges() {
    stream.listen((event) {
      debugPrint("Music player update -> $event");
    });
  }

  Future<void> _getPlaylistSongs() async {
    List<PlayListSong> songs = await _playListRepository.getSongs();
    int? currentSongId = await _currentSongRepository.getCurrentSongId();

    int currentSongIndex = currentSongId != null
        ? songs.indexWhere((element) => element.indexRow == currentSongId)
        : 0;

    if (songs.isNotEmpty) {
      songs[currentSongIndex] = songs[currentSongIndex].copyWith(isPlaying: true);
    }

    _songs.addAll(songs);
  }

  @override
  Future<void> start() async {
    if(value.state != MusicPlayerState.closed) return;

    await Future.delayed(const Duration(seconds: 1));

    _updateMusicPlayer(
      value.copyWith(state: MusicPlayerState.open)
    );

    await _loadSongs(onSongsLoaded: () => {_reproduceNextSong()});
  }

  Future<void> _loadSongs({required VoidCallback onSongsLoaded}) async {
    await _getPlaylistSongs();

    if (_songs.isEmpty) {
      _updateMusicPlayer(
          value.copyWith(state: MusicPlayerState.notSongsAvailable)
      );
      return;
    }

    onSongsLoaded();
  }

  Future<void> _reproduceNextSong() async {
    PlayListSong song = _songs.firstWhere((element) => element.isPlaying);
    String? songId = song.getId();

    if (songId == null) {
      _updateMusicPlayer(
        value.copyWith(state: MusicPlayerState.notSongsAvailable)
      );
      return;
    }

    bool musicPlayerIsStarted = await _tryStartMusicPlayer(songId);

    if (!musicPlayerIsStarted) {
      _handleMusicPlayerNotStarted();
      return;
    }

    _updateMusicPlayer(
      value.copyWith(currentSong: song, state: MusicPlayerState.playing)
    );
  }

  void _handleMusicPlayerNotStarted() {
    _updateMusicPlayer(
      value.copyWith(state: MusicPlayerState.notSongsAvailable)
    );
    musicPlayerController.reset();
  }

  bool _isMusicPlayerReadyToPlay() => (musicPlayerController.value.isReady ||
      musicPlayerController.value.isPlaying);

  Future<bool> _tryStartMusicPlayer(String songId) async {
    return await ExecuteAttemptsHelper.makeAttempt(
        functionToExecute: () => {musicPlayerController.load(songId)},
        executionCondition: _isMusicPlayerReadyToPlay,
        timeBetweenAttempts: const Duration(seconds: 1),
        functionDescription: "Start music player");
  }

  Future<void> _tryReproduceNextSong() async {
    if (_songs.isNotEmpty) {
      _reproduceNextSong();
      return;
    }

    await _loadSongs(onSongsLoaded: () => {_reproduceNextSong()});
  }

  @override
  Future<void> close() async {
    musicPlayerController.reset();
    _updateMusicPlayer(
      value.copyWith(state: MusicPlayerState.closed)
    );
  }

  void _updateMusicPlayer(MusicPlayer musicPlayer) {
    _musicPlayerBloc.value = musicPlayer.copyWith(
        lastStateChangeTime: DateTime.now()
    );
  }

  @override
  void handleVideoPlayerVisibilityButtonTapped() {
    VideoPlayerVisibilityState newState = value.videoVisibilityState == VideoPlayerVisibilityState.hidden
        ? VideoPlayerVisibilityState.visible
        : VideoPlayerVisibilityState.hidden;

    _updateMusicPlayer(
      value.copyWith(
          videoVisibilityState: newState
      )
    );
  }

  @override
  void handleNextReproductionStateButtonTapped() {
    if (value.state == MusicPlayerState.notSongsAvailable) return;

    value.isPlaying
        ? _pause()
        : _play();
  }

  void _pause() {
    _updateMusicPlayer(
      value.copyWith(state: MusicPlayerState.pause)
    );
    musicPlayerController.pause();
  }

  void _play() {

    Duration currentSongDuration = musicPlayerController.metadata.duration;

    if(!value.isSongStillTheCurrentSong(currentSongDuration)) {
      _songs.clear();
      _tryReproduceNextSong();
      return;
    }

    _updateMusicPlayer(
      value.copyWith(state: MusicPlayerState.playing)
    );

    musicPlayerController.play();
  }

  @override
  void back() {
    blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).back();
  }

  @override
  void handleAppLifecyclesChanges(AppLifecycleState newState) {
    if(newState == AppLifecycleState.inactive && value.isPlaying) {
      _handleAppInBackground();
      return;
    }

    if(newState == AppLifecycleState.resumed && value.isPlaying) {
      _handleAppInForeground();
    }
  }

  void _defaultFunction(MethodCall call) {
    switch (call.method) {
      case 'pause':
        debugPrint("Control pause clicked");
        _pause();
        break;
      case 'play':
        debugPrint("Control play clicked");
        _play();
        break;
      default:
        debugPrint("Invalid choice");
        break;
    }
  }

  Future<void> _handleAppInBackground() async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      _play();
      _channel.prepareToReproduceInBackground(value.currentSong);
      _channel.onListenerPlayer(_defaultFunction);
    });
  }

  Future<void> _handleAppInForeground() async {
    _play();
    _channel.prepareToReproduceInForeground();
  }

  @override
  Future<void> handleEndedSong() async {
    _updateMusicPlayer(
      value.copyWith(state: MusicPlayerState.changingSong)
    );

    int songIndex = _songs.indexWhere((element) => element.indexRow == value.currentSong?.indexRow);
    _songs[songIndex] = _songs[songIndex].copyWith(isPlaying: false);

    int newIndex = songIndex + 1;
    if(newIndex >= _songs.length) {
      _songs.clear();
    } else {
      _songs[newIndex] = _songs[newIndex].copyWith(isPlaying: true);
    }

    await _tryReproduceNextSong();
  }

  @override
  FutureOr<void> dispose() {
    _musicPlayerBloc.dispose();
  }
}
