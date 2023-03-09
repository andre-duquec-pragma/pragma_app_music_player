import 'dart:async';


import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_station/entities/entity_bloc.dart';
import 'package:package_google_sign_in/package_google_sign_in.dart';

class GoogleSignInBloc extends BlocModule {
  static String name = "GoogleSignInBloc";
  final GoogleSignInService googleSignInService;
  GoogleSignInBloc({required this.googleSignInService});
  GoogleSignInAccount? user;


  final _controllerStateUser = StreamController<GoogleSignInAccount?>();
  Stream<GoogleSignInAccount?> get streamStateUser =>
      _controllerStateUser.stream;


  void listenChangeInfoUser() {
    googleSignInService.getGoogleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      user = account;
      _controllerStateUser.add(account);
    });
  }


  Future<void> handleSignIn() async {
    await googleSignInService.handleSignIn();
  }


  void handleSignOut() {
    googleSignInService.handleSignOut();
  }


  Future<void> signInSilently() async {
    await googleSignInService.signInSilently();
  }

  void closeStream() {
    _controllerStateUser.close();
  }

  @override
  FutureOr<void> dispose() {
    closeStream();
  }
}



