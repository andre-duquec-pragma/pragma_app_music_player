import 'package:flutter/material.dart';
import 'package:music_station/modules/home/bloc/home_bloc.dart';

import '../../classroom/ui/classroom_page.dart';
import '../../music_player/ui/pages/music_player_page.dart';

class HomePage extends StatelessWidget {
  static String name = "homePage";

  final String user;
  final HomeBloc bloc;

  const HomePage({super.key, required this.user, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome $user"),

            const SizedBox(height: 20),

            ElevatedButton.icon(
                icon: const Icon(Icons.music_note),
                label: const Text("Music player"),
                onPressed: () => {
                  bloc.navigate(MusicPlayerPage.name)
                }
            ),

            ElevatedButton.icon(
                icon: const Icon(Icons.task),
                label: const Text("Classroom"),
                onPressed: () => {
                  bloc.navigate(ClassroomPage.name)
                }
            )
          ],
        ),
      ),
    );
  }
}