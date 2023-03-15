import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/utils/enums/video_player_visibility_state_enum.dart';

import '../../interfaces/i_music_player_bloc.dart';
import '../../models/music_player_model.dart';
import 'external_video_player_widget.dart';
import 'floating_player_buttons_widget.dart';
import 'floating_player_information_widget.dart';

class FloatingMusicPlayer extends StatefulWidget {
  final IMusicPlayerBloc bloc;

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
                    color: Colors.white.withAlpha(240),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(80),
                          blurRadius: 10,
                          spreadRadius: 2,
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
                              ExternalVideoPlayer(
                                  controller: widget.bloc.musicPlayerController,
                                  isVisible: isVideoPlayerVisible,
                                  maxWidth: width,
                                  onEnded: (data) => { widget.bloc.handleEndedSong() },
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    FloatingPlayerInformationWidget(
                                        data: snapshot.data
                                    ),

                                    FloatingPlayerButtonsWidget(
                                        isMusicPlayerReady: isMusicPlayerReady,
                                        bloc: widget.bloc,
                                        data: snapshot.data
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




