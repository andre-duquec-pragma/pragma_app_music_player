import 'dart:async';

import 'blocs/bloc_drawer.dart';
import 'blocs/bloc_processing.dart';
import 'blocs/bloc_responsive.dart';
import 'blocs/bloc_secondary_drawer.dart';
import 'blocs/navigator_bloc.dart';
import 'blocs/onboarding_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'entities/entity_bloc.dart';
import 'modules/counter/blocs/counter_bloc.dart';
import 'modules/counter/ui/page/counter_home_page.dart';
import 'providers/my_app_navigator_provider.dart';
import 'services/theme_config.dart';
import 'services/theme_service.dart';
import 'ui/pages/my_onboarding_page.dart';

/// Zona de configuración inicial
final BlocCore blocCore = BlocCore();
bool _init = false;
FutureOr<void> testMe() async {
  await Future.delayed(
    const Duration(seconds: 2),
  );
}

void onboarding([
  Duration initialDelay = const Duration(seconds: 2),
]) async {
  /// Register modules to use
  /// Inicializamos el responsive y la ux del usuario
  if (!_init) {
    blocCore.addBlocModule<ResponsiveBloc>(
      ResponsiveBloc.name,
      ResponsiveBloc(),
    );
    blocCore.addBlocModule<BlocProcessing>(
      BlocProcessing.name,
      BlocProcessing(),
    );

    blocCore.addBlocModule<DrawerMainMenuBloc>(
      DrawerMainMenuBloc.name,
      DrawerMainMenuBloc(),
    );

    blocCore.addBlocModule<CounterBloc>(
      CounterBloc.name,
      CounterBloc(),
    );

    /// register onboarding
    blocCore.addBlocModule(
      OnboardingBloc.name,
      OnboardingBloc(
        [
          () {
            blocCore.addBlocModule<DrawerSecondaryMenuBloc>(
              DrawerSecondaryMenuBloc.name,
              DrawerSecondaryMenuBloc(
                blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name),
              ),
            );
          },
          testMe,
          testMe,
          testMe,
          testMe,
          testMe,
          () async {
            //  blocCore
            //      .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
            //      .setHomePage(
            //        const MyHomePage(title: 'Onboarding cargado'),
            //      );
            /*
            blocCore
                .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
                .setHomePage(TestScreenIIPage(
                  blocResponsive: blocCore
                      .getBlocModule<ResponsiveBloc>(ResponsiveBloc.name),
                ));
            await Future.delayed(const Duration(milliseconds: 200), () {
              blocCore
                  .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
                  .update();
            });
            Future.delayed(const Duration(seconds: 10), () {
              blocCore
                  .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
                  .pushPage(
                    'Test Widgets',
                    TestScreenWidgetsPage(
                      blocResponsive: blocCore
                          .getBlocModule<ResponsiveBloc>(ResponsiveBloc.name),
                      drawerSecondaryMenuBloc:
                          blocCore.getBlocModule<DrawerSecondaryMenuBloc>(
                              DrawerSecondaryMenuBloc.name),
                    ),
                  );
            });
*/
            await Future.delayed(const Duration(seconds: 10), () {
              blocCore
                  .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
                  .setHomePage(
                    const CounterHomePage(),
                  );
            });
            await Future.delayed(const Duration(milliseconds: 200), () {
              blocCore
                  .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
                  .update();
            });
          }
        ],
      ),
    );

    blocCore.addBlocModule<ThemeBloc>(
        ThemeBloc.name,
        ThemeBloc(
          ThemeService(
              lightColorScheme: lightColorScheme,
              darkColorScheme: darkColorScheme,
              colorSeed: colorSeed),
        ));
    blocCore.addBlocModule(
      NavigatorBloc.name,
      NavigatorBloc(
        myPageManager,
        MyOnboardingPage(
          onboardingBloc:
              blocCore.getBlocModule<OnboardingBloc>(OnboardingBloc.name),
          responsiveBloc:
              blocCore.getBlocModule<ResponsiveBloc>(ResponsiveBloc.name),
        ),
      ),
    );

    _init = true;
  }
}
