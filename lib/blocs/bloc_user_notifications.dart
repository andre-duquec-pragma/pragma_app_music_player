import 'dart:async';

import 'package:flutter/material.dart';

import '../entities/entity_bloc.dart';

class UserNotificationsBloc extends BlocModule {
  static const name = 'userNotificationsBloc';
  final BlocGeneral _userNotificationsBloc = BlocGeneral<String>('');
  UserNotificationsBloc(BuildContext context) {
    _context = context;
  }

  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  void showGeneralAlert(String msg) {
    try {
      showAlert(_context, Text(msg));
    } catch (e) {
      debugPrint('Imposible Ejecutar el alerta del usuario');
    }
  }

  void showGeneralSsnackBar(
    String msg,
  ) {
    try {
      final snackBar = SnackBar(
        content: Text(msg),
      );
      showSnackBar(_context, snackBar);
    } catch (e) {
      debugPrint('Imposible presentar el Snack Bar');
    }
  }

  void showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showAlert(BuildContext context, Widget widget) {
    showDialog(
        context: _context,
        builder: (context) => AlertDialog(
              content: widget,
            ));
  }

  @override
  FutureOr<void> dispose() {
    _userNotificationsBloc.dispose();
  }
}
