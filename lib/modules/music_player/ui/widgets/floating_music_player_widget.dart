import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/utils/music_player_resources.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../bloc/music_player_bloc.dart';
import '../../entities/music_player.dart';

class FloatingMusicPlayer extends StatelessWidget {
  final MusicPlayerBloc bloc;

  const FloatingMusicPlayer({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Positioned(
        bottom: 40,
        left: width * 0.1,
        width: width * 0.8,
        child: Column(
          children: [

            SizedBox(
              width: 0,
              height: 0,
              child: YoutubePlayer(
                controller: bloc.controller,
              ),
            ),
            // YoutubePlayerControllerProvider(controller: bloc.controller, child: const SizedBox()),

            StreamBuilder<MusicPlayer>(
                stream: bloc.currentMusicPlayerStream,
                builder: (context, snapshot) {
                  return ElevatedButton.icon(
                      onPressed: () { bloc.handleButtonTap(); },
                      icon: MusicPlayerResources.getIconBasedOnState(snapshot.data),
                      label: Text(MusicPlayerResources.getTextBasedOnState(snapshot.data))
                  );
                }
            )
          ],
        )
    );
  }


}