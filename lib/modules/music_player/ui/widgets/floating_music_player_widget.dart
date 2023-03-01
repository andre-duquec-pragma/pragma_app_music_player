import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/utils/music_player_resources.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../bloc/music_player_bloc.dart';
import '../../entities/music_player.dart';

class FloatingMusicPlayer extends StatefulWidget {
  final MusicPlayerBloc bloc;

  const FloatingMusicPlayer({super.key, required this.bloc});

  @override
  State<StatefulWidget> createState() => _FloatingMusicPlayer();
}

class _FloatingMusicPlayer extends State<FloatingMusicPlayer> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    widget.bloc.handleAppLifecyclesChanges(state);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Positioned(
        bottom: 0,
        left: width * 0.05,
        width: width * 0.9,
        child: Column(
          children: [

            SizedBox(
              width: 0,
              height: 0,
              child: YoutubePlayer(
                controller: widget.bloc.musicPlayerController,
                onEnded: (data) => {
                  widget.bloc.handleEndedSong()
                },
              ),
            ),


            StreamBuilder<MusicPlayer>(
                stream: widget.bloc.currentMusicPlayerStream,
                builder: (context, snapshot) {
                  return SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all( Radius.circular(16) ),
                          color: Colors.white.withAlpha(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(4,4)
                            ),
                          ]
                        ),
                        child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Row(
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
                                      MusicPlayerResources.getTextBasedOnState(snapshot.data),
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    Text(
                                      snapshot.data?.currentSong?.name ?? "------",
                                      style: Theme.of(context).textTheme.titleMedium,
                                    )
                                  ],
                                ),
                              ],
                            ),



                            GestureDetector(
                              onTap: () { widget.bloc.handleButtonTap(); },
                              child: Icon(
                                  MusicPlayerResources.getIconBasedOnState(snapshot.data)
                              ),
                            )

                          ],
                        ),
                      )
                      )
                  );
                }
            )
          ],
        )
    );
  }


}