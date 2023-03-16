

class SongRequest {
  final int? indexRow;
  final String urlYoutube;
  final String songName;
  final String idPragmatic;
  final String message;

  SongRequest({
    this.indexRow,
    required this.urlYoutube,
    required this.songName,
    required this.idPragmatic,
    required this.message,
  });

  Map<String, String?> toJson(List<String> comment) => {
        songName: songName,
        urlYoutube: urlYoutube,
        idPragmatic:idPragmatic,
        message: message,
      };

  static SongRequest fromJson(Map<String, dynamic> json, List<String> comment) => SongRequest(
      indexRow: int.parse(json['indexRow']),
      urlYoutube: json['urlYoutube'],
      songName: json['songName'],
      idPragmatic: json['idPragmatic'],
      message: json['message'], 
      );

}