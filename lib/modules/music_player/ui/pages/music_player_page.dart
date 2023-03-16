import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/ui/widgets/music_reproduction_animation_widget.dart';

import '../../../../app_config.dart';
import '../../../../blocs/navigator_bloc.dart';
import '../../interfaces/i_music_player_bloc.dart';
import '../../models/music_player_model.dart';
import '../../utils/enums/music_player_state_enum.dart';
import '../../utils/resources/music_player_resources.dart';
import '../widgets/floating_music_player_widget.dart';
import 'create_song_request_page.dart';


class MusicPlayerPage extends StatelessWidget {
  static String name = "musicPlayerPage";

  static OverlayEntry? floatingMusicPlayer;

  final IMusicPlayerBloc bloc;

  const MusicPlayerPage({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    bloc.start();
    return _buildPage(
      context: context,
      body: StreamBuilder(
        stream: bloc.stream,
        builder: (context, AsyncSnapshot<MusicPlayer> snapshot) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => _handleFloatingMusicPlayerState(context));
          return _buildPageBody(context, snapshot.data);
        },
      ),
    );
  }

  Widget _buildPage({required BuildContext context, required Widget body}) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade800],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Music player'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {bloc.goBackInNavigation()}),
          actions: [
            ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('Request List'),
                onPressed: () {
                  blocCore
                      .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
                      .pushNamed(CreateSongRequestPage.name);
                })
          ],
        ),
        body: body,
      ),
    );
  }

  Widget _buildPageBody(BuildContext context, MusicPlayer? musicPlayer) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/music-illustration.png",
            height: MediaQuery.of(context).size.height * 0.4),
        _buildPlaylistPresentation(context, musicPlayer),
        const SizedBox(height: 12),
        _buildPlayList(),
      ],
    );
  }

  Widget _buildPlaylistPresentation(
      BuildContext context, MusicPlayer? musicPlayer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Welcome to Pragma Music Player",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall?.fontSize ??
                              12,
                      color: Colors.white),
                  overflow: TextOverflow.clip,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ElevatedButton(
                onPressed: () {
                  (musicPlayer?.isActive ?? false)
                      ? bloc.close()
                      : bloc.start();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                ),
                child: Icon(
                    MusicPlayerResources.getActivationButtonIconBasedOnState(
                        musicPlayer)),
              )
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "Playlist",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayList() {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: bloc.playlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset("assets/cd.png"),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bloc.playlist[index].songName,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.fontSize ??
                                12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Artist",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.fontSize ??
                                12,
                            color: Colors.white60),
                      )
                    ],
                  ),
                  trailing: _buildReproductionAnimation(
                      isSongActive: bloc.playlist[index].isPlaying &&
                          bloc.value.state == MusicPlayerState.playing),
                ),
              );
            }));
  }

  Widget _buildReproductionAnimation({required bool isSongActive}) {
    if (!isSongActive) {
      return const SizedBox(width: 0);
    }

    return const SizedBox(
      width: 60,
      height: 15,
      child: MusicReproductionAnimation(),
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
    floatingMusicPlayer =
        OverlayEntry(builder: (context) => FloatingMusicPlayer(bloc: bloc));

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
