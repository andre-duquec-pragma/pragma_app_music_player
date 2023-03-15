
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_station/modules/music_player/bloc/music_player_bloc.dart';
import 'package:music_station/modules/music_player/interfaces/i_music_player_method_channel.dart';
import 'package:music_station/modules/music_player/interfaces/i_music_player_service.dart';
import 'package:music_station/modules/music_player/models/play_list_song_model.dart';
import 'package:music_station/modules/music_player/utils/enums/music_player_state_enum.dart';

class MockMusicPlayerService extends Mock implements IMusicPlayerService {}
class MockMusicPlayerMethodChannelService extends Mock implements IMusicPlayerMethodChannel {}

void main() {
  
  late MusicPlayerBloc sut;
  late IMusicPlayerService service;
  late IMusicPlayerMethodChannel channel;
  
  setUp(() {
    service = MockMusicPlayerService();
    channel = MockMusicPlayerMethodChannelService();
    sut = MusicPlayerBloc(service: service, channel: channel);
  });
  
  group("Testing 'start' function", () {

    test("Without playlist results", () async {
      when(service.getPlaylist).thenAnswer((invocation) =>  Future.value([]));

      await sut.start();

      expect(sut.value.state, MusicPlayerState.notSongsAvailable);
    });

    test("With results but null songs id", () async {
      when(service.getPlaylist).thenAnswer((_) =>  Future.value([
        const PlayListSong(urlYoutube: "", songName: "songName1", idPragmatic: 0, indexRow: 1),
        const PlayListSong(urlYoutube: "", songName: "songName2", idPragmatic: 1, indexRow: 2)
      ]));

      when(service.getCurrentSongId).thenAnswer((_) => Future.value(1));

      await sut.start();

      expect(sut.value.state, MusicPlayerState.notSongsAvailable);
    });
  });
}