import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/bloc/favorites_songs_bloc.dart';

import '../../../../app_config.dart';
import '../../../../blocs/navigator_bloc.dart';

class CreateFavoriteSongPage extends StatelessWidget {

  static String name = "createFavoriteSongPage";

  final FavoritesSongsBloc bloc;

  const CreateFavoriteSongPage({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name).back();
          },
        ),
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            TextField(
              controller: bloc.urlYoutubeController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Url Youtube'
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: bloc.songNameController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Song Name'
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: bloc.messageController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mensaje'
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: (){
                bloc.createFavoriteSong();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: const Center(child: Text('Save')),
              ),
            ),
          ],
        )
      ),
    );
  }
}

