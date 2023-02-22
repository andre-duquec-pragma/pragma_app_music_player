import 'package:flutter/material.dart';
import 'package:music_station/app_config.dart';
import 'package:music_station/blocs/navigator_bloc.dart';

class ClassroomPage extends StatelessWidget {
  static String name = "classroomPage";

  const ClassroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Classroom"),
        leading: IconButton(
            onPressed: () => {
              blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).back()
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: const Center(
        child: Text("User's class spaces"),
      ),
    );
  }

}