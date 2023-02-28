import 'dart:convert';

class PlayListSong {
  final String url;
  final String name;

  const PlayListSong({
    required this.url,
    required this.name
  });

  String getId() {
    final params = Uri.parse(url).queryParameters;
    final videoId = params['v'];

    if (videoId == null) return "";

    return videoId;
  }

  Map<String, dynamic> toJSON() => {
    "url" : url,
    "name": name
  };
}