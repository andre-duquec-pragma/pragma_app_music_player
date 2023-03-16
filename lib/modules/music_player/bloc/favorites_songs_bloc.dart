import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:music_station/modules/music_player/bloc/config/config_sheet_favorite_song.dart';

import '../interfaces/i_favorite_song_bloc.dart';
import '../models/favorite_song_model.dart';



class FavoritesSongBloc implements IFavoritesSongsBloc{

  FavoritesSongBloc()
  :
  urlYoutubeController = TextEditingController(), 
  messageController = TextEditingController(), 
  songNameController = TextEditingController()
  ;

  @override
  Future <void> createFavoriteSong() async{
    FavoriteSong requestList = FavoriteSong(
      songName: songNameController.value.text.trimLeft(), 
      urlYoutube: urlYoutubeController.value.text.trimLeft(), 
      idPragmatic: '4', 
      message: messageController.value.text.trimLeft(),
    );

     Map<String, dynamic> data = {
    'values': [
      [requestList.urlYoutube,
      requestList.songName,
      requestList.idPragmatic,
      requestList.message]],
    };

    googleSheetForFavoriteSong.insertDataInSheet(
      data: data, 
      sheet: googleSheetForFavoriteSong.sheetName,
      range: '${googleSheetForFavoriteSong.sheetRange.first}:${googleSheetForFavoriteSong.sheetRange.last}'
    );
    
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