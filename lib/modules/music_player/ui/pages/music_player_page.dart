import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/bloc/music_player_bloc.dart';
import 'package:music_station/modules/music_player/entities/music_player.dart';
import 'package:music_station/modules/music_player/utils/music_player_state.dart';

import '../widgets/floating_music_player_widget.dart';

class MusicPlayerPage extends StatelessWidget {
  static String name = "musicPlayerPage";

  static OverlayEntry? floatingMusicPlayer;

  final MusicPlayerBloc bloc;

  const MusicPlayerPage({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music player'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => { bloc.back() }),
      ),
      body: Center(
        child: StreamBuilder(
          stream: bloc.currentMusicPlayerStream,
          builder: (context, AsyncSnapshot<MusicPlayer> snapshot) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _handleFloatingMusicPlayerState(context));

            if (snapshot.data == null) return _buildInitialState();

            if (snapshot.data!.isPlaying || snapshot.data!.isPause) {
              return _buildPlayingState(snapshot.data);
            } else if(snapshot.data?.state == MusicPlayerState.changingSong
                || snapshot.data?.state == MusicPlayerState.open) {
              return _buildLoadingState();
            }

            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Text("Loading...");
  }

  Widget _buildPlayingState(MusicPlayer? musicPlayer) {
    if(musicPlayer == null) return _buildInitialState();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Current song"),
        Text(musicPlayer.currentSong?.name ?? ""),

        const SizedBox(height: 20),

        IconButton(
          onPressed: () => { bloc.close() },
          icon: const Icon(Icons.close)
        )
      ],
    );
  }

  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Welcome to Pragma Music Player"),

        const SizedBox(height: 20),

        ElevatedButton.icon(
            icon: const Icon(Icons.queue_music_sharp),
            label: const Text("Play some music"),
            onPressed: () => {
              bloc.start()
            }
        )
      ],
    );
  }

  void _handleFloatingMusicPlayerState(BuildContext context) {
    if (bloc.currentValue.state == MusicPlayerState.open) {
      _showFloatingMusicPlayer(context);
      return;
    }

    if (bloc.currentValue.state == MusicPlayerState.closed) {
      _hideFloatingMusicPlayer(context);
    }
  }

  void _showFloatingMusicPlayer(BuildContext context) {
    floatingMusicPlayer = OverlayEntry(
        builder: (context) => FloatingMusicPlayer(bloc: bloc)
    );

    OverlayState overlay = Overlay.of(context);
    overlay.insert(floatingMusicPlayer!);
  }

  void _hideFloatingMusicPlayer(BuildContext context) {
    if (floatingMusicPlayer == null) return;

    floatingMusicPlayer!.remove();
    floatingMusicPlayer!.dispose();
    floatingMusicPlayer = null;
  }
}