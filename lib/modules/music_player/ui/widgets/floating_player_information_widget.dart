import 'package:flutter/material.dart';

import '../../models/music_player_model.dart';
import '../../utils/resources/music_player_resources.dart';

class FloatingPlayerInformationWidget extends StatelessWidget {
  const FloatingPlayerInformationWidget({
    super.key,
    required MusicPlayer? data
  }): _data = data;

  final MusicPlayer? _data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.music_note),

        const SizedBox(width: 10),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MusicPlayerResources.getFloatingMusicPlayerTextBasedOnState(_data),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              _data?.currentSong?.songName ?? "------",
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ],
    );
  }
}
