import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/utils/music_player_resources.dart';

import '../../bloc/music_player_bloc.dart';
import '../../entities/music_player.dart';

class FloatingMusicPlayer extends StatelessWidget {
  final MusicPlayerBloc bloc;

  const FloatingMusicPlayer({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.currentMusicPlayerStream,
        builder: (context, AsyncSnapshot<MusicPlayer> snapshot) {
          double width = MediaQuery
              .of(context)
              .size
              .width;

          return Positioned(
              bottom: 40,
              left: width * 0.1,
              width: width * 0.8,
              child: ElevatedButton.icon(
                  onPressed: () { bloc.handleButtonTap(); },
                  icon: MusicPlayerResources.getIconBasedOnState(snapshot.data),
                  label: Text(MusicPlayerResources.getTextBasedOnState(snapshot.data))
              )
          );
        }
    );
  }


}