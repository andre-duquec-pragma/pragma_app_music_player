import 'package:google_sign_in/google_sign_in.dart';


import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';


abstract class IGoogleSheetProvider {
  /// ## initInstanceOfSheetsApi
  ///
  ///
  /// ### Descripción
  /// Inicializa una instancia de SheetsApi.
  ///
  /// ### Parámetros
  /// * [googleSignIn] (__requerido__): Recibe una instancia  de GoogleSignIn.
  ///
  Future initInstanceOfSheetsApi(GoogleSignIn googleSignIn);


  /// ## getAllDataOfSheet
  ///
  ///
  /// ### Descripción
  /// Obtiene la data de una hoja de cálculo.
  ///
  /// ### Parámetros
  /// * [range] (__requerido__): Tipo [String] que indica el rango de la hoja específica
  ///   sobre la que se debe obtener la data.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///   String range = 'hoja1!A:D'
  ///   ```
  Future<ValueRange> getAllDataOfSheet(String range);


  /// ## getLastId
  ///
  ///
  /// ### Descripción
  /// Obtiene el valor de la celda ubicada en la última fila y primera columna de la
  /// data que contiene una hoja específica de la hoja de cálculo.
  ///
  /// (_Es ideal hacer uso de esta función cuando esa primera columna haga referencia a un
  /// identificador numérico_).
  ///
  /// ### Parámetros
  /// * [range] (__requerido__) : Tipo [String] que indica el rango de la hoja
  ///   específica sobre la que se debe obtener el valor de la celda.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///   String range = 'hoja1!A:D'
  ///   ```
  ///
  Future<int> getLastId(String range);


  /// ## insertDataInSheet
  ///
  ///
  /// ### Descripción
  /// Agrega data a una hoja de cálculo.
  ///
  /// ### Parámetros
  /// * [data] (__requerido__): Tipo [ValueRange] que debe contener
  ///   como mínimo la llave 'values' con la información que se desea agregar.
  ///    #### Ejemplo de uso
  ///   ```dart
  ///   ValueRange data = {
  ///     'values': [
  ///       ['username example'],
  ///       ['example@mail.com'],
  ///       ['123456'],
  ///      ]
  ///   }
  ///   ```
  /// * [range] (__requerido__): Tipo [String] que indica el rango de la
  ///   hoja específica sobre la que se debe insertar la data.
  ///
  ///   Puede enviarse solo la hoja y este ubicará la data inmediatamente después de
  ///   la última fila con información.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///   String range = 'hoja1'
  ///   ```
  ///   O puede enviarse el rango completo, si en este rango ya existe información,
  ///   la data enviada la ubicará inmediatamente después de la última fila con información.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///   String range = 'hoja1!A20:D20'
  ///   ```
  Future<bool> insertDataInSheet(ValueRange data, String range);


  /// ## updateDataOfRow
  ///
  ///
  /// ### Descripción
  /// Actualiza el contenido de una fila dentro de una hoja.
  ///
  /// ### Parámetros
  /// * [data] (__requerido__): Tipo [ValueRange] que debe contener como mínimo la llave
  ///   'values' con la información que se desea modificar.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     ValueRange data = {
  ///       'values': [
  ///         ['username example'],
  ///         ['example@mail.com'],
  ///         ['123456'],
  ///       ]
  ///     }
  ///   ```
  ///
  /// * [range] (__requerido__): Tipo [String] que indica el rango de la hoja específica sobre la que se debe modificar la data.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String range = 'hoja1!A20:D20'
  ///   ```
  Future<bool> updateDataOfRow(ValueRange data, String range);


  /// ## deleteDataOfRow
  ///
  ///
  /// ### Descripción
  /// Elimina la información contenida en una fila.
  ///
  /// ### Parámetros
  /// * [range] (__Requerido__): Tipo [String] que indica el rango en el que se debe
  ///   eliminar la información.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String range = 'hoja1!A20:D20'
  ///   ```
  Future<bool> deleteDataOfRow(String range);
}


class GoogleApiSheetProvider implements IGoogleSheetProvider {
  SheetsApi? sheetApi;
  String spreadsheetId = ('1Sn1XOAiDYm3XDgq07OiutoT7O2QQfXC8M6XiqKf3zmw');


  static final GoogleApiSheetProvider _instance =
  GoogleApiSheetProvider._internal();


  GoogleApiSheetProvider._internal();
  /// ## GoogleApiSheetProvider
  ///
  ///
  /// ### Descripción
  /// Realiza una conexión con el API de googleSheet, adicionalmente permite obtener,
  /// modificar, eliminar e insertar la data en una hoja de cálculo.
  ///
  /// ### Parámetros
  /// * [sheetApi] (__opcional__): Tipo [SheetsApi] que espera una instancia de SheetsApi.
  ///   #### Ejemplo de uso
  /// ```dart
  ///    sheetApi = SheetsApi(client);
  /// ```
  /// * [spreadsheetId] (__requerido__): Tipo [String], este será el identificador de la
  ///   hoja de cálculo al que se quiere acceder.
  ///   #### Ejemplo de uso
  /// ```dart
  ///    spreadsheetId = ('1F8dwblmCqxaHpg0MKFaL30qQo2t7t8cenQvbuo2gjnY');
  /// ```
  factory GoogleApiSheetProvider() {
    return _instance;
  }


  @override
  Future initInstanceOfSheetsApi(GoogleSignIn googleSignIn) async {
    try {
      final auth.AuthClient? client = await googleSignIn.authenticatedClient();
      assert(client != null, 'Authenticated client missing!');
      sheetApi = SheetsApi(client!);
    } catch (e) {
      throw "Error: $e";
    }
  }


  @override
  Future<ValueRange> getAllDataOfSheet(String range) async {
    if (sheetApi == null) return ValueRange();
    final data = await sheetApi!.spreadsheets.values.get(spreadsheetId, range);
    return data;
  }


  @override
  Future<int> getLastId(String range) async {
    final data = await sheetApi!.spreadsheets.values.get(spreadsheetId, range);
    return int.parse(data.values!.last[0] as String);
  }


  @override
  Future<bool> insertDataInSheet(ValueRange rowList, String range) async {
    if (sheetApi == null) return false;
    try {
      sheetApi?.spreadsheets.values.append(rowList, spreadsheetId, range,
          valueInputOption: 'USER_ENTERED');
      return true;
    } catch (e) {
      return false;
    }
  }


  @override
  Future<bool> updateDataOfRow(ValueRange vr, String range) async {
    if (sheetApi == null) return false;
    try {
      sheetApi!.spreadsheets.values
          .update(vr, spreadsheetId, range, valueInputOption: 'USER_ENTERED');
      return true;
    } catch (e) {
      return false;
    }
  }


  @override
  Future<bool> deleteDataOfRow(String range) async {
    if (sheetApi == null) return false;
    try {
      await sheetApi?.spreadsheets.values
          .clear(ClearValuesRequest(), spreadsheetId, range);
      return true;
    } catch (e) {
      return false;
    }
  }
}






