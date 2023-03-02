import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/utils/music_player_resources.dart';
import 'package:music_station/modules/music_player/utils/responsive_utils.dart';
import 'package:music_station/modules/music_player/utils/video_player_visibility_state.dart';
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
        child: SafeArea(
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
                child: Column(
                  children: [

                    StreamBuilder<MusicPlayer>(
                        stream: widget.bloc.stream,
                        builder: (context, snapshot) {

                          bool isMusicPlayerReady = snapshot.data?.isReady ?? false;
                          VideoPlayerVisibilityState videoPlayerVisibilityState = (snapshot.data?.videoVisibilityState ?? VideoPlayerVisibilityState.hidden);
                          bool isVideoPlayerVisible = videoPlayerVisibilityState == VideoPlayerVisibilityState.visible;
                          double width = MediaQuery.of(context).size.width;

                          return Column(
                            children: [

                              SizedBox(
                                width: isVideoPlayerVisible ?  width: 0,
                                height: isVideoPlayerVisible ? ResponsiveUtils.calculateHeightAspectRatioBasedOn(width: width) : 0,
                                child: YoutubePlayer(
                                  controller: widget.bloc.musicPlayerController,
                                  onEnded: (data) => {
                                    widget.bloc.handleEndedSong()
                                  },
                                ),
                              ),

                              Padding(
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
                                              MusicPlayerResources.getFloatingMusicPlayerTextBasedOnState(snapshot.data),
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

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        if (isMusicPlayerReady && snapshot.data != null)
                                          GestureDetector(
                                              onTap: () { widget.bloc.handleVideoPlayerVisibilityButtonTapped(); },
                                              child: Icon(
                                                  MusicPlayerResources.getVideoVisibilityButtonIconBasedOnState(snapshot.data!.videoVisibilityState)
                                              )
                                          ),

                                        const SizedBox(width: 16),

                                        GestureDetector(
                                          onTap: () { widget.bloc.handleNextReproductionStateButtonTapped(); },
                                          child: Icon(
                                              MusicPlayerResources.getReproductionButtonIconBasedOnState(snapshot.data)
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                    ),
                  ],
                )
            )
        )
    );
  }


}