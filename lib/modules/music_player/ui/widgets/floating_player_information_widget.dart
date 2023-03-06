import 'package:flutter/material.dart';

import '../../entities/music_player.dart';
import '../../utils/music_player_resources.dart';

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
              _data?.currentSong?.name ?? "------",
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ],
    );
  }
}
