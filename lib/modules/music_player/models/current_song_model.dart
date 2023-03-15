class CurrentSong {
  final int? indexRow;
  final int? idPlayList;

  const CurrentSong({required this.indexRow, required this.idPlayList});

  static CurrentSong fromJSON(Map<String, dynamic> json) => CurrentSong(
    indexRow: int.parse(json["indexRow"]),
    idPlayList: int.parse(json["idPlayList"])
  );
}