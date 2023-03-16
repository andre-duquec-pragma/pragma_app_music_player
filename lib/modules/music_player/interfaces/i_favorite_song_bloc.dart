import 'package:flutter/material.dart';
import '../../../entities/entity_bloc.dart';

abstract class IFavoritesSongsBloc extends BlocModule {
  static String name = "favoritesSongdBloc";

  Future <void> createFavoriteSong();

  late TextEditingController urlYoutubeController ;
  late TextEditingController songNameController ;
  late TextEditingController messageController ;
}