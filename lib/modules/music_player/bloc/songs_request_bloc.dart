import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/interfaces/i_songs_request_bloc.dart';
import 'package:music_station/modules/music_player/interfaces/i_songs_request_service.dart';

import '../models/song_request_model.dart';


class SongsRequestBloc implements ISongsRequestBloc {
  final ISongsRequestService _songsRequestService;

  SongsRequestBloc(this._songsRequestService)
      : urlYoutubeController = TextEditingController(),
        messageController = TextEditingController(),
        songNameController = TextEditingController();

  @override
  Future<void> createSongRequest() async {
    SongRequest songRequest = SongRequest(
      songName: songNameController.value.text.trimLeft(),
      urlYoutube: urlYoutubeController.value.text.trimLeft(),
      idPragmatic: '4',
      message: messageController.value.text.trimLeft(),
    );

    Map<String, dynamic> data = {
      'values': [
        [
          songRequest.urlYoutube,
          songRequest.songName,
          songRequest.idPragmatic,
          songRequest.message
        ]
      ],
    };

    await _songsRequestService.createSongRequest(data);
  }

  @override
  FutureOr<void> dispose() {
    songNameController.clear();
    urlYoutubeController.clear();
    messageController.clear();
  }

  @override
  TextEditingController messageController;

  @override
  TextEditingController songNameController;

  @override
  TextEditingController urlYoutubeController;
}
