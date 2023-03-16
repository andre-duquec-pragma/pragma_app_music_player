import 'dart:async';
import 'package:music_station/entities/entity_bloc.dart';

import '../models/favorite_song_model.dart';


abstract class RequestListBloc extends BlocModule {
  static String name = "requestListBloc";

    Stream<FavoriteSong> get stream;

    List<FavoriteSong> get playlist;


}

class BrandRequestListBloc implements RequestListBloc {

    final BlocGeneral<BrandRequestListBloc> _requestListBloc =
    BlocGeneral(
      BrandRequestListBloc()
    );

  @override
  FutureOr<void> dispose() {
    _requestListBloc.dispose();
  }
  
  @override
  // TODO: implement playlist
  List<FavoriteSong> get playlist => throw UnimplementedError();
  
  @override
  // TODO: implement stream
  Stream<FavoriteSong> get stream => throw UnimplementedError();
  
}

