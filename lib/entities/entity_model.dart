import 'dart:convert';

import 'package:flutter/foundation.dart';

abstract class Model {
  /// TODO: complete the model abstract class according to firestore documentation
  Map<String, dynamic> toJson() {
    return {};
  }

  Model fromJson(Map<String, dynamic> source);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> fromString(String source) {
    var tmp = {} as Map<String, dynamic>;
    try {
      tmp = jsonDecode(source);
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return tmp;
  }
}
