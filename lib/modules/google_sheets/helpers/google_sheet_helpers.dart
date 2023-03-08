import 'dart:math';


import 'package:googleapis/sheets/v4.dart';


class GoogleSheetHelpers {
  static Map<String, String> wrap(List<String> keys, List<String> values) {
    return mapKeysToValues(keys, values, (_, val) => val ?? '');
  }


  static Map<String, V> mapKeysToValues<V>(
      List<String> keys,
      List<String> values,
      V Function(int index, dynamic value) wrap,
      ) {
    final map = <String, V>{};
    var index = 0;
    var length = values.length;
    for (final key in keys) {
      map[key] =
      index < length ? wrap(index, values[index]) : wrap(index, null);
      index++;
    }
    return map;
  }


  static T? get<T>(List<T> list, {int at = 0, T? or}) =>
      list.length > at ? list[at] : or;


  static List<Map<String, String>> getDataFormated(
      ValueRange getData, {
        int fromRow = 1,
        int fromColumn = 1,
        int length = -1,
        int count = -1,
        int mapTo = 1,
      }) {
    Map<String, dynamic> mapData = getData.toJson();
    final maps = <Map<String, String>>[];
    if (mapData["values"] == null) return maps;
    List<List<String>> rows = [];
    int indexFinal = 0;
    String index = ((mapData["range"].split("!"))[1].split(":"))[0];
    for (var i = 0; i < index.length; i++) {
      if (int.tryParse(index[i]) != null) {
        indexFinal = indexFinal * 10;
        indexFinal += int.parse(index[i]);
      }
    }


    for (var element in mapData["values"]) {
      final ele = List<String>.from(element);
      ele.insert(0, isRowEmpty(ele) ? '0' : indexFinal.toString());
      rows.add(ele);
      indexFinal++;
    }


    final keys = rows.first;
    keys.replaceRange(0, 1, ['indexRow']);
    final start = min(fromRow - 1, rows.length);
    final end = count < 1 ? rows.length : min(start + count, rows.length);
    for (var i = start; i < end; i++) {
      if (i != mapTo - 1) {
        maps.add(GoogleSheetHelpers.wrap(keys, rows[i]));
      }
    }
    return maps;
  }


  static bool isRowEmpty(List data) {
    int itemEmpty = 0;
    for (var element in data) {
      if (element == '') itemEmpty++;
    }
    return itemEmpty == data.length;
  }
}



