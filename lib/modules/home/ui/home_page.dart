import 'package:flutter/material.dart';
import 'package:music_station/modules/home/bloc/home_bloc.dart';

import '../../classroom/ui/classroom_page.dart';
import '../../music_player/bloc/music_player_bloc.dart';
import '../../music_player/ui/pages/music_player_page.dart';
import '../../music_player/ui/widgets/floating_music_player_widget.dart';
import '../../music_player/utils/floating_music_player_state.dart';
import '../../music_player/utils/music_player_state.dart';

class HomePage extends StatefulWidget {
  final String user;
  final HomeBloc bloc;
  final MusicPlayerBloc musicPlayerBloc;

  const HomePage({super.key, required this.user, required this.bloc, required this.musicPlayerBloc});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  OverlayEntry? floatingMusicPlayer;
  OverlayState? overlay;

  @override
  void initState() {
    _listenMusicPlayerChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildFloatingMusicPlayer(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome ${widget.user}"),

            const SizedBox(height: 20),

            ElevatedButton.icon(
                icon: const Icon(Icons.music_note),
                label: const Text("Music player"),
                onPressed: () => {
                  widget.musicPlayerBloc.prepareBeforePresent(),
                  widget.bloc.navigate(MusicPlayerPage.name)
                }
            ),

            ElevatedButton.icon(
                icon: const Icon(Icons.task),
                label: const Text("Classroom"),
                onPressed: () => { widget.bloc.navigate(ClassroomPage.name) }
            )
          ],
        ),
      ),
    );
  }

  void _listenMusicPlayerChanges() {
    widget.musicPlayerBloc.currentMusicPlayerStream.listen((musicPlayer) {
      final state = musicPlayer.getStateOfFloatingMusicPlayer();

      if (state == FloatingMusicPlayerState.show) {
        _showFloatingMusicPlayer();
      } else if (state == FloatingMusicPlayerState.hide) {
        _hideFloatingMusicPlayer();
      }
    });
  }

  void _buildFloatingMusicPlayer(BuildContext context) {
    if (widget.musicPlayerBloc.currentValue.state != MusicPlayerState.playingInBackground) return;

    floatingMusicPlayer = OverlayEntry(
        builder: (context) => FloatingMusicPlayer(bloc: widget.musicPlayerBloc)
    );

    overlay = Overlay.of(context);
  }

  void _showFloatingMusicPlayer() {
    if (floatingMusicPlayer == null || overlay == null) return;

    try {
      overlay!.insert(floatingMusicPlayer!);
    } catch(_) {}
  }

  void _hideFloatingMusicPlayer() {
    if (floatingMusicPlayer == null) return;

    try {
      floatingMusicPlayer!.remove();
    } catch(_) {}
  }
}