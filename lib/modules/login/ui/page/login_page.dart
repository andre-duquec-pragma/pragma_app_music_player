import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/ui/pages/music_player_page.dart';

import '../../../../app_config.dart';
import '../../../../blocs/navigator_bloc.dart';
import '../../blocs/login_bloc.dart';

class LoginPage extends StatefulWidget {
  static String name = "loginPage";
  const LoginPage({super.key, required this.bloc});

  final GoogleSignInBloc bloc;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.listenChangeInfoUser();
    widget.bloc.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc.streamStateUser,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print(widget.bloc.user);
        if (widget.bloc.user != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text('Signed in successfully.'),
              ElevatedButton(
                  onPressed: () {
                    blocCore
                        .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
                        .pushNamed(MusicPlayerPage.name);
                  },
                  child: const Text("Home"))
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text('You are not currently signed in.'),
              ElevatedButton(
                onPressed: widget.bloc.handleSignIn,
                child: const Text('SIGN IN'),
              ),
            ],
          );
        }
      },
    );
  }
}
