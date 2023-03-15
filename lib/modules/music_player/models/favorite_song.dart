

class RequestList {
  int? indexRow;
  String urlYoutube;
  String songName;
  String idPragmatic;
  String message;

  RequestList({
    this.indexRow,
    required this.urlYoutube,
    required this.songName,
    required this.idPragmatic,
    required this.message,
  });

  Map<String, String?> tojson(List<String> comment) => {
        songName: songName,
        urlYoutube: urlYoutube,
        idPragmatic:idPragmatic,
        message: message,
      };

  static RequestList fromJson(Map<String, dynamic> json, List<String> comment) => RequestList(
      indexRow: int.parse(json['indexRow']),
      urlYoutube: json['urlYoutube'],
      songName: json['songName'],
      idPragmatic: json['idPragmatic'],
      message: json['message'], 
      );

}