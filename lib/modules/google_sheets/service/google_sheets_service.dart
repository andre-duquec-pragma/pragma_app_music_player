import 'package:googleapis/sheets/v4.dart';
import 'package:package_google_sign_in/package_google_sign_in.dart';
import '../helpers/google_sheet_helpers.dart';


import '../provider/google_sheets_provider.dart';


// GoogleSheetService googleSheetService =
//     GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider());


abstract class IGoogleSheetService {
  /// ## initInstanceOfGoogleSheetProvider
  ///
  ///
  /// ### Descripción
  /// Inicializa una instancia de SheetsApi.
  Future<void> initInstanceOfGoogleSheetProvider();


  /// ## intiSheetConfig
  ///
  ///
  /// ### Descripción
  /// Guarda la configuracion de acceso a la hoja de cálculo
  ///
  /// ### Parámetros
  /// * nameOfSheet
  void intiSheetConfig(String nameOfSheet, List<String> rangeOfSheet);


  /// ## getAllDataOfSheet
  ///
  ///
  /// ### Descripción
  /// Obtiene la data de una hoja de cálculo.
  ///
  /// ### Parámetros
  /// * [fromJson] (__Requerido__): Es un parametro requerido de tipo [Function] que indica el metodo
  ///   fromJson que todos los modelos deben tener.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     static ModelExample fromJson(Map<String, dynamic> json) =>
  ///       ModelExample(
  ///         indexRow: int.parse(json[UserFieldsGoogleSheet.indexRow]),
  ///         id: json[UserFieldsGoogleSheet.id],
  ///         name: json[UserFieldsGoogleSheet.name],
  ///         email: json[UserFieldsGoogleSheet.email],
  ///         comments: json[UserFieldsGoogleSheet.comments]
  ///      );
  ///   ```
  /// * [sheet] (__requerido__): Tipo [String] que indica la hoja sobre la que
  ///   se obtendra la data.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String sheet = 'hoja1'
  ///   ```
  ///
  /// * [range] (__requerido__): Tipo [String] que indica el rango sobre
  ///   el que se debe obtener la data.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String range = 'A:D'
  ///   ```
  Future<List<dynamic>?> getAllDataOfSheet(
      Function fromJson,
      String sheet,
      String range,
      );


  /// ## insertDataInSheet
  ///
  ///
  /// ### Descripción
  /// Agrega data a una hoja de cálculo.
  ///
  /// ### Parámetros
  /// * [data] (__requerido__): Tipo [Map]<[String], [dynamic]> que debe contener
  ///   como mínimo la llave 'values' con la información que se desea agregar.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     Map<String, dynamic> data = {
  ///       'values': [
  ///         ['username example'],
  ///         ['example@mail.com'],
  ///         ['123456'],
  ///       ]
  ///     }
  ///   ```
  ///
  /// * [sheet] (__requerido__): Tipo [String] que indica la hoja sobre la que
  ///   se insertara la data.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String sheet = 'hoja1'
  ///   ```
  ///
  /// * [range] (__opcional__): Tipo [String] que indica el rango sobre
  ///   el que se debe obtener la data.
  ///   (Si no se indica este rango la data enviada sera ubicada inmediatamente después
  ///   de la última fila con información).
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String range = 'A10:D10'
  ///   ```


  Future<bool> insertDataInSheet(
      {required Map<String, dynamic> data,
        required String sheet,
        String? range});


  /// ## updateDataOfRow
  ///
  ///
  /// ### Descripción
  /// Actualiza el contenido de una fila dentro de una hoja.
  ///
  /// ### Parámetros
  /// * [data] (__requerido__): Tipo [Map]<[String], [dynamic]> que debe contener
  ///   como mínimo la llave 'values' con la información que se desea modificar.
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
  /// * [range] (__requerido__: Tipo [String] que indica el rango de la
  ///   hoja específica sobre la que se debe modificar la data.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String range = 'hoja1!A20:D20'


  Future<bool> updateDataOfRow(
      Map<String, dynamic> data,
      String range,
      );


  /// ## deleteDataOfRow
  ///
  ///
  /// ### Descripción
  /// Elimina la información contenida en una fila
  ///
  /// ### Parámetros
  /// * [range] (__Requerido__): Tipo [String] que indica el rango
  ///   en el que se debe eliminar la información
  ///   #### Ejemplo de uso
  ///   ```dart
  ///     String range = 'hoja1!A20:D20'
  ///   ```
  Future<bool> deleteDataOfRow(String range);
}


/// ## GoogleSheetService
///
///
/// ### Descripción
/// Servicio que a través del proveedor de googleSheet permite obtener, modificar,
/// eliminar e insertar  data en una hoja de cálculo
///
/// ### Parámetros
/// * [googleSheetProvider] (__requerido__): Es un parámetro requerido de tipo [IGoogleSheetProvider] que
///   espera una referencia al proveedor de GoogleSheets
///   #### Ejemplo de uso
/// ```dart
///    IGoogleSheetProvider googleSheetProvider = GoogleApiSheetProvider()
/// ```
class GoogleSheetService implements IGoogleSheetService {
  GoogleSheetService({required this.googleSheetProvider});


  final IGoogleSheetProvider googleSheetProvider;
  late String sheetName = '';
  late List<String> sheetRange = [];


  @override
  Future<void> initInstanceOfGoogleSheetProvider() {
    return googleSheetProvider
        .initInstanceOfSheetsApi(GoogleSignInService().getGoogleSignIn);
  }


  @override
  void intiSheetConfig(String nameOfSheet, List<String> rangeOfSheet) {
    sheetName = nameOfSheet;
    sheetRange = rangeOfSheet;
  }


  @override
  Future<List<dynamic>?> getAllDataOfSheet(
      Function function,
      String sheet,
      String? range,
      ) async {
    ValueRange data =
    await googleSheetProvider.getAllDataOfSheet(totalRange(sheet, range));
    List<Map<String, dynamic>>? allData =
    GoogleSheetHelpers.getDataFormated(data);
    if (allData == []) return [];
    final cleanData = allData
        .map((item) => function(item))
        .where((element) => element.indexRow != 0)
        .toList();
    return cleanData;
  }


  @override
  Future<bool> insertDataInSheet(
      {required Map<String, dynamic> data,
        required String sheet,
        String? range}) async {
    ValueRange vr = ValueRange.fromJson(data);


    final bool result = await googleSheetProvider.insertDataInSheet(
      vr,
      totalRange(sheet, range),
    );


    return result;
  }


  @override
  Future<bool> updateDataOfRow(Map<String, dynamic> data, String range) async {
    ValueRange vr = ValueRange.fromJson(data);
    await googleSheetProvider.updateDataOfRow(vr, range);
    return true;
  }


  @override
  Future<bool> deleteDataOfRow(String range) async {
    final bool result = await googleSheetProvider.deleteDataOfRow(range);
    return result;
  }


  /// ## totalRange
  ///
  /// ### Descripción
  /// Une la hoja y el rango de columnas y filas para retornar un rango completo.
  ///
  /// ### Parámetros
  /// * [sheet] (__requerido__): Tipo [String] que indica una hoja especifica dentro
  /// de toda la hoja de cálculo.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///   String sheet = 'Hoja1';
  ///   ```
  /// * [range] (__opcional__): Tipo [String] que indica el rango en filas y columnas dentro de una hoja.
  ///   #### Ejemplo de uso
  ///   ```dart
  ///   String range = 'A15:D15';
  ///   ```
  String totalRange(String sheet, String? range) {
    return '$sheet${range != null ? '!$range' : ''}';
  }
}
