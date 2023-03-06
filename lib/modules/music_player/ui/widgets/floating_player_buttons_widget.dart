import 'package:flutter/cupertino.dart';

import '../../bloc/music_player_bloc.dart';
import '../../entities/music_player.dart';
import '../../utils/music_player_resources.dart';

class FloatingPlayerButtonsWidget extends StatelessWidget {

  final bool _isMusicPlayerReady;
  final MusicPlayerBloc _bloc;
  final MusicPlayer? _data;

  const FloatingPlayerButtonsWidget({super.key, required isMusicPlayerReady, required bloc, data})
      : _isMusicPlayerReady = isMusicPlayerReady, _bloc = bloc, _data = data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        if (_isMusicPlayerReady && _data != null)
          GestureDetector(
              onTap: () { _bloc.handleVideoPlayerVisibilityButtonTapped(); },
              child: Icon(
                  MusicPlayerResources.getVideoVisibilityButtonIconBasedOnState(_data!.videoVisibilityState)
              )
          ),

        const SizedBox(width: 16),

        GestureDetector(
          onTap: () { _bloc.handleNextReproductionStateButtonTapped(); },
          child: Icon(
              MusicPlayerResources.getReproductionButtonIconBasedOnState(_data)
          ),
        )
      ],
    );
  }
}