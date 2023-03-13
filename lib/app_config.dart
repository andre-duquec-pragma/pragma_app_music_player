import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:music_station/modules/classroom/ui/classroom_page.dart';
import 'package:music_station/modules/home/bloc/home_bloc.dart';
import 'package:music_station/modules/home/ui/home_page.dart';
import 'package:music_station/modules/home/utils/home_bloc_factory.dart';
import 'package:music_station/modules/login/blocs/login_bloc.dart';
import 'package:music_station/modules/login/ui/page/login_page.dart';
import 'package:music_station/modules/music_player/bloc/music_player_bloc.dart';
import 'package:music_station/modules/music_player/ui/pages/music_player_page.dart';
import 'package:music_station/modules/not_found/ui/not_found_page.dart';
import 'package:music_station/providers/session_service_factory.dart';
import 'package:music_station/services/session_service.dart';
import 'package:package_google_sign_in/service/service_google_sign_in.dart';

import 'blocs/bloc_processing.dart';
import 'blocs/bloc_responsive.dart';
import 'blocs/navigator_bloc.dart';
import 'blocs/onboarding_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'entities/entity_bloc.dart';
import 'modules/google_sheets/provider/google_sheets_provider.dart';
import 'modules/google_sheets/service/google_sheets_service.dart';
import 'modules/music_player/bloc/brand_music_player_bloc.dart';
import 'modules/music_player/bloc/config_sheet_player_current_song.dart';
import 'modules/music_player/bloc/config_sheet_player_playlist.dart';
import 'modules/music_player/channel/brand_music_player_method_channel.dart';
import 'providers/my_app_navigator_provider.dart';
import 'services/theme_config.dart';
import 'services/theme_service.dart';
import 'ui/pages/my_onboarding_page.dart';

/// Zona de configuración inicial
final BlocCore blocCore = BlocCore();
bool _init = false;
final SessionService _sessionService = SessionServiceFactory.get();

void onboarding([
  Duration initialDelay = const Duration(seconds: 2),
]) async {
  /// Register modules to use
  /// Inicializamos el responsive y la ux del usuario
  if (!_init) {
    _setDefaultBlocModules();
    _init = true;
  }
}

Future<void> _setDefaultBlocModules() async {
  blocCore.addBlocModule<ResponsiveBloc>(
    ResponsiveBloc.name,
    ResponsiveBloc(),
  );

  blocCore.addBlocModule<BlocProcessing>(
    BlocProcessing.name,
    BlocProcessing(),
  );

  blocCore.addBlocModule(
      OnboardingBloc.name,
      _createOnBoardingBloc(),
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

  await _setSessionBasedBlocModules();
  await _setSessionBasedAvailablePages();
}

Future<void> _setSessionBasedBlocModules() async {
  /*
  if (!await _sessionService.isActive) {
      blocCore.addBlocModule<GoogleSignInBloc>(
          GoogleSignInBloc.name,
          GoogleSignInBloc(googleSignInService: GoogleSignInService())
      );
    return;
  }
*/
  blocCore.addBlocModule<GoogleSignInBloc>(
      GoogleSignInBloc.name,
      GoogleSignInBloc(googleSignInService: GoogleSignInService())
  );

  blocCore.addBlocModule<HomeBloc>(
      HomeBloc.name,
      HomeBlocFactory.get()
  );

  blocCore.addBlocModule<MusicPlayerBloc>(
      MusicPlayerBloc.name,
      BrandMusicPlayerBloc(
          channel: BrandMusicPlayerMethodChannel(),
          playlistGoogleSheetService: GoogleSheetPlayListBlocSetup(
              service: GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider()
            )
          ),
          currentSongGoogleSheetService: GoogleSheetCurrentSongBlocSetup(
              service: GoogleSheetService(googleSheetProvider: GoogleApiSheetProvider()
              )
          )
      )
  );
}

Future<void> _setSessionBasedAvailablePages() async {
  //if (!await _sessionService.isActive) return;

  Map<String, Widget> availablePages = {

    HomePage.name : HomePage(
      user: await _sessionService.currentUser,
      bloc: blocCore.getBlocModule<HomeBloc>(HomeBloc.name)
    ),

    MusicPlayerPage.name : MusicPlayerPage(
      bloc: blocCore.getBlocModule<MusicPlayerBloc>(MusicPlayerBloc.name)
    ),

    ClassroomPage.name : const ClassroomPage()
  };

  blocCore.getBlocModule<NavigatorBloc>(NavigatorBloc.name)
      .addPagesForDynamicLinksDirectory(availablePages);
}

OnboardingBloc _createOnBoardingBloc() {
  return OnboardingBloc(
    [
      () async {
        blocCore
            .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
            .setHomePage( await _getInitialPage() );

        blocCore
            .getBlocModule<NavigatorBloc>(NavigatorBloc.name)
            .update();
      }
    ],
  );
}

Future<Widget> _getInitialPage() async {
  try {
    if(!await _sessionService.isActive) {
      return LoginPage(
          bloc: blocCore.getBlocModule<GoogleSignInBloc>(GoogleSignInBloc.name)
      );
    }

    return HomePage(
      user: await _sessionService.currentUser,
      bloc: blocCore.getBlocModule<HomeBloc>(HomeBloc.name)
    );

  } catch(_) {
    return const NotFoundPage();
  }
}