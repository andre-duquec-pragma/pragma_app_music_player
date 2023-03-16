import 'package:flutter/material.dart';
import '../../../entities/entity_bloc.dart';

abstract class ISongsRequestBloc extends BlocModule {
  static String name = "favoritesSongdBloc";

  Future <void> createSongRequest();

  late TextEditingController urlYoutubeController ;
  late TextEditingController songNameController ;
  late TextEditingController messageController ;
}