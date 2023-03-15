import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:music_station/modules/music_player/utils/enums/music_player_method_channel_methods_enum.dart';
import 'package:music_station/modules/music_player/interfaces/i_music_player_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../app_config.dart';
import '../../../blocs/navigator_bloc.dart';
import '../../../entities/entity_bloc.dart';
import '../../../providers/my_app_navigator_provider.dart';
import '../interfaces/i_music_player_method_channel.dart';

import '../models/music_player_model.dart';
import '../models/play_list_song_model.dart';
import '../utils/helpers/execute_attempts_helper.dart';
import '../utils/enums/music_player_state_enum.dart';
import '../utils/enums/video_player_visibility_state_enum.dart';
import '../interfaces/i_music_player_bloc.dart';

class MusicPlayerBloc implements IMusicPlayerBloc {
  //region Class properties
  final List<PlayListSong> _songs = [];
  final IMusicPlayerService _service;
  final IMusicPlayerMethodChannel _channel;
  //endregion

  //region Class life cycle
  MusicPlayerBloc({
    required IMusicPlayerService service,
    required IMusicPlayerMethodChannel channel
  })
      : _service = service,
        _channel = channel
  {
    stream.listen((event) {
      debugPrint("Music player update -> $event");
    });

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

  @override
  FutureOr<void> dispose() {
    _musicPlayerBloc.dispose();
  }
  //endregion

  //region Bloc general
  final BlocGeneral<MusicPlayer> _musicPlayerBloc =
    BlocGeneral(
      const MusicPlayer(
        state: MusicPlayerState.closed,
        videoVisibilityState: VideoPlayerVisibilityState.hidden
      )
    );
  //endregion

  //region Override properties
  @override
  late YoutubePlayerController musicPlayerController;

  @override
  MusicPlayer get value => _musicPlayerBloc.value;

  @override
  Stream<MusicPlayer> get stream => _musicPlayerBloc.stream;

  @override
  List<PlayListSong> get playlist => _songs;
  //endregion

  //region Playlist controls
  Future<void> _tryLoadPlaylistSongs({required VoidCallback onSongsLoaded}) async {
    await _loadPlaylistSongs();

    if (_songs.isEmpty) {
      _updateMusicPlayer(value.copyWith(state: MusicPlayerState.notSongsAvailable));
      return;
    }

    onSongsLoaded();
  }

  Future<void> _loadPlaylistSongs() async {
    List<PlayListSong> songs = await _service.getPlaylist();

    if (songs.isEmpty) return;

    _songs.addAll(songs);

    int? currentSongId = await _service.getCurrentSongId();

    int currentSongIndex = currentSongId != null
        ? songs.indexWhere((element) => element.indexRow == currentSongId)
        : 0;

    _updateCurrentPlayingSongState(currentSongIndex, true);
  }

  int _findAndUpdateCurrentPlayingSongState(int? id, bool newState) {
    int songIndex = _songs.indexWhere((element) => element.indexRow == id);
    _updateCurrentPlayingSongState(songIndex, newState);
    return songIndex;
  }

  void _updateCurrentPlayingSongState(int index, bool newState) {
    _songs[index] = _songs[index].copyWith(isPlaying: newState);
  }
  //endregion

  //region Music player life cycle
  @override
  Future<void> start() async {
    if(value.state != MusicPlayerState.closed) return;

    await Future.delayed(const Duration(seconds: 1));

    _updateMusicPlayer(value.copyWith(state: MusicPlayerState.open));

    await _tryLoadPlaylistSongs(
        onSongsLoaded: () => { _reproduceNextSong() }
    );
  }

  @override
  Future<void> handleEndedSong() async {
    _updateMusicPlayer(value.copyWith(state: MusicPlayerState.changingSong));

    int songIndex = _findAndUpdateCurrentPlayingSongState(value.currentSong?.indexRow, false);

    int newIndex = songIndex + 1;
    newIndex >= _songs.length
        ? _songs.clear()
        : _updateCurrentPlayingSongState(newIndex, true);

    await _tryReproduceNextSong();
  }

  @override
  Future<void> close() async {
    musicPlayerController.reset();
    _updateMusicPlayer(value.copyWith(state: MusicPlayerState.closed));
  }
  //endregion

  //region Music player controls
  bool _isMusicPlayerReadyToPlay() => (musicPlayerController.value.isReady ||
      musicPlayerController.value.isPlaying);

  Future<bool> _tryStartMusicPlayer(String songId) async {
    return await ExecuteAttemptsHelper.makeAttempt(
        functionToExecute: () => {musicPlayerController.load(songId)},
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

    await _tryLoadPlaylistSongs(
        onSongsLoaded: () => { _reproduceNextSong() }
    );
  }

  Future<void> _reproduceNextSong() async {
    PlayListSong song = _songs.firstWhere((element) => element.isPlaying);
    String? songId = song.getId();

    if (songId == null) {
      _updateMusicPlayer(value.copyWith(state: MusicPlayerState.notSongsAvailable));
      return;
    }

    bool isMusicPlayerStarted = await _tryStartMusicPlayer(songId);

    if (!isMusicPlayerStarted) {
      _handleMusicPlayerNotStarted();
      return;
    }

    _updateMusicPlayer(value.copyWith(currentSong: song, state: MusicPlayerState.playing));
  }

  void _handleMusicPlayerNotStarted() {
    _updateMusicPlayer(value.copyWith(state: MusicPlayerState.notSongsAvailable));
    musicPlayerController.reset();
  }

  void _updateMusicPlayer(MusicPlayer musicPlayer) {
    _musicPlayerBloc.value = musicPlayer.copyWith(lastStateChangeTime: DateTime.now());
  }

  void _pause() {
    _updateMusicPlayer(value.copyWith(state: MusicPlayerState.pause));
    musicPlayerController.pause();
  }

  void _play() {
    Duration currentSongDuration = musicPlayerController.metadata.duration;

    if(!value.isSongStillTheCurrentSong(currentSongDuration)) {
      _songs.clear();
      _tryReproduceNextSong();
      return;
    }

    _updateMusicPlayer(value.copyWith(state: MusicPlayerState.playing));
    musicPlayerController.play();
  }
  //endregion

  //region UI interactions handlers
  @override
  void handleVideoPlayerVisibilityButtonTapped() {
    VideoPlayerVisibilityState newState = value.videoVisibilityState == VideoPlayerVisibilityState.hidden
        ? VideoPlayerVisibilityState.visible
        : VideoPlayerVisibilityState.hidden;

    _updateMusicPlayer(value.copyWith(videoVisibilityState: newState));
  }

  @override
  void handleNextReproductionStateButtonTapped() {
    if (value.state == MusicPlayerState.notSongsAvailable) return;

    value.isPlaying
        ? _pause()
        : _play();
  }

  @override
  void goBackInNavigation() {
    blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).back();
  }
  //endregion

  //region App life cycle control
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

  Future<void> _handleAppInBackground() async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      _play();
      _channel.prepareToReproduceInBackground(value.currentSong);
      _channel.onListenerPlayer(_listenNativeOSMethodCalls);
    });
  }

  Future<void> _handleAppInForeground() async {
    _play();
    _channel.prepareToReproduceInForeground();
  }

  void _listenNativeOSMethodCalls(MethodCall call) {
    String method = call.method;
    debugPrint("::: Native call received: $method :::");

    if (method == MusicPlayerMethodChannelMethods.pause.value) {
      _pause();
    } else if (method == MusicPlayerMethodChannelMethods.play.value) {
      _play();
    }
  }
  //endregion
}
