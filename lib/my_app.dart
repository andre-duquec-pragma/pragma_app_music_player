import 'package:flutter/material.dart';

import 'app_config.dart';
import 'blocs/theme_bloc.dart';
import 'providers/my_app_navigator_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MyAppRouterDelegate routerDelegate = MyAppRouterDelegate();
    MyAppRouteInformationParser routeInformationParser =
        MyAppRouteInformationParser();

    return StreamBuilder<ThemeData>(
        stream:
            blocCore.getBlocModule<ThemeBloc>(ThemeBloc.name).themeDataStream,
        builder: (context, snapshot) {
          return MaterialApp.router(
            title: 'Emisora Pragma',
            theme: snapshot.data,
            routerDelegate: routerDelegate,
            routeInformationParser: routeInformationParser,
          );
        });
  }
}
