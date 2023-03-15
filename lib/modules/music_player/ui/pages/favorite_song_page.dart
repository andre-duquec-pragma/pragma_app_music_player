// import 'package:flutter/material.dart';
// import 'package:music_station/modules/music_player/bloc/request_list_bloc.dart';

// import '../../entities/request_list.dart';

// class RequestListPage extends StatelessWidget {
  
//   final RequestListBloc bloc;

//   const RequestListPage({super.key, required this.bloc});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Request List'),
//       ),
//       body: ListView.builder(
//         itemCount: bloc.requestList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Dismissible(
//             key: Key(''),
//             direction: DismissDirection.startToEnd,
//             background: Container(
//               padding: const EdgeInsets.only(left: 8.0),
//               color: Colors.red,
//               child: const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text('Delete Band', style: TextStyle(color: Colors.white),)
//               ),
//             ), 
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               margin: const EdgeInsets.all(15),
//               elevation: 5,
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Text(
//                       bloc.requestList[index].songName,
//                     ),
//                     subtitle: Text(
//                       bloc.requestList[index].message,
//                     ),
//                       trailing: Text(
//                         bloc.requestList[index].idPragmatic, 
//                         style: const TextStyle(fontSize: 15),
//                       ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(onPressed: (){}, child: const Text('Modificar'))
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         elevation: 1,
//         onPressed: (){
//           Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => addNewRequesList(),
//                 )
//                 );
//         },
//       ),
//     );
//   }

//   addNewRequesList(){
//     final textControllerUrl = TextEditingController();
//     final textControllerSongName = TextEditingController();
//     final textControllerMessage = TextEditingController();
//     return AlertDialog(
//       title: const Text('New Request'),
//       content: Column(
//           children: [
//             TextField(
//               controller: textControllerUrl,
//               obscureText: false,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Url Youtube'
//               ),
//             ),
//             TextField(
//               controller: textControllerSongName,
//               obscureText: false,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Song Name'
//               ),
//             ),
//             TextField(
//               controller: textControllerMessage,
//               obscureText: false,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Mensaje'
//               ),
//             )
//           ],
//       ),

//       actions: [
//         MaterialButton(
//           child: Text('Add'),
//           elevation: 5,
//           textColor: Colors.blue,
//           onPressed: () => addRequestToList(textControllerUrl.text, textControllerSongName.text, textControllerMessage.text)
//         )
//       ],
//     );
//   }

//     void addRequestToList(String urlYoutube, String songName, String message){
//       print(message);
//       //Podemos agregar
//       bloc.requestList.add(RequestList( idPragmatic: '5', message: message, songName: songName, urlYoutube: urlYoutube));
//   }
// } 