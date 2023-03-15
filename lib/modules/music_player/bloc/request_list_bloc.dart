import 'dart:async';
import 'package:music_station/entities/entity_bloc.dart';

import '../models/favorite_song.dart';


abstract class RequestListBloc extends BlocModule {
  static String name = "requestListBloc";

    Stream<RequestList> get stream;

    List<RequestList> get playlist;


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
  List<RequestList> get playlist => throw UnimplementedError();
  
  @override
  // TODO: implement stream
  Stream<RequestList> get stream => throw UnimplementedError();
  
}

