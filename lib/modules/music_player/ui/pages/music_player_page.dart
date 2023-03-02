import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/bloc/music_player_bloc.dart';
import 'package:music_station/modules/music_player/entities/music_player.dart';
import 'package:music_station/modules/music_player/utils/music_player_resources.dart';
import 'package:music_station/modules/music_player/utils/music_player_state.dart';

import '../widgets/floating_music_player_widget.dart';

class MusicPlayerPage extends StatelessWidget {
  static String name = "musicPlayerPage";

  static OverlayEntry? floatingMusicPlayer;

  final MusicPlayerBloc bloc;

  const MusicPlayerPage({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    bloc.loadSongs();
    debugPrint("Building view again");
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800,
            Colors.deepPurple.shade200
          ],
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Music player'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => { bloc.back() }),
        ),
        body:  StreamBuilder(
          stream: bloc.stream,
          builder: (context, AsyncSnapshot<MusicPlayer> snapshot) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _handleFloatingMusicPlayerState(context));
            return _buildInitialState(context, snapshot.data);
          },
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context, MusicPlayer? musicPlayer) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Image.asset("assets/music-illustration.png"),

        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Text(
                  "Playlist",
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.clip,
                )
                ),

                SizedBox(width: MediaQuery.of(context).size.width * 0.1),

                ElevatedButton(
                  onPressed: () {
                    (musicPlayer?.isActive ?? false) ? bloc.close() : bloc.start();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                  ),
                  child: Icon(
                      MusicPlayerResources.getActivationButtonIconBasedOnState(musicPlayer)
                  ),
                )

              ],
            ),
        ),
      ],
    );
  }

  void _handleFloatingMusicPlayerState(BuildContext context) {
    if (bloc.value.state == MusicPlayerState.open) {
      _showFloatingMusicPlayer(context);
      return;
    }

    if (bloc.value.state == MusicPlayerState.closed) {
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