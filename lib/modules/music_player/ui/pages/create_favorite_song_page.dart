import 'package:flutter/material.dart';
import 'package:music_station/modules/music_player/interfaces/i_favorite_song_bloc.dart';
import 'package:music_station/modules/music_player/ui/widgets/text_field_custom_widget.dart';

import '../../../../app_config.dart';
import '../../../../blocs/navigator_bloc.dart';

class CreateFavoriteSongPage extends StatelessWidget {

  static String name = "createFavoriteSongPage";

  final IFavoritesSongsBloc bloc;

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
            TextFieldCustom(
              controller: bloc.urlYoutubeController, 
              hintText: 'Url', 
              validator: (value){
                if(value!.isEmpty){
                  return 'Requiere el campo name';
                }if(value.trim().isEmpty){
                  return 'No se acepta solo espacios';
                }
                return null;
              }
            ),
            TextFieldCustom(
              controller: bloc.songNameController, 
              hintText: 'Song Name', 
              validator: (value){
                if(value!.isEmpty){
                  return 'Requiere el campo name';
                }if(value.trim().isEmpty){
                  return 'No se acepta solo espacios';
                }
                return null;
              }
            ),
            TextFieldCustom(
              controller: bloc.messageController, 
              hintText: 'Message', 
              validator: (value){
                if(value!.isEmpty){
                  return 'Requiere el campo name';
                }if(value.trim().isEmpty){
                  return 'No se acepta solo espacios';
                }
                return null;
              }
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

