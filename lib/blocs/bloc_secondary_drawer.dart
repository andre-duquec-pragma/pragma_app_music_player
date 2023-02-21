import 'dart:async';

import '../entities/entity_bloc.dart';
import '../ui/widgets/responsive/secondary_drawer_option_widget.dart';
import 'bloc_responsive.dart';

class DrawerSecondaryMenuBloc extends BlocModule {
  static const name = 'drawerSecondaryMenuBloc';
  final _blocSecondary = BlocGeneral<List<SecondarydrawerOptionWidget>>([]);

  DrawerSecondaryMenuBloc(this.responsiveBloc);
  final ResponsiveBloc responsiveBloc;

  void tmpFunction() {
    clearSecondaryMainDrawer();
  }

  Stream<List<SecondarydrawerOptionWidget>> get listDrawerOptionSizeStream =>
      _blocSecondary.stream;

  List<SecondarydrawerOptionWidget> get listMenuOptions => _blocSecondary.value;

  void clearSecondaryMainDrawer() {
    _blocSecondary.value = <SecondarydrawerOptionWidget>[];
  }

  String mainCover = 'assets/icon.png';

  void addSecondaryDrawerOptionMenu({
    required onPressed,
    required title,
    description = '',
    required icondata,
  }) {
    final tmpList = <SecondarydrawerOptionWidget>[];
    final optionWidget = SecondarydrawerOptionWidget(
      onPressed: onPressed,
      toolTip: title,
      icondata: icondata,
      blocResponsive: responsiveBloc,
    );
    for (final option in _blocSecondary.value) {
      if (option.toolTip != title) {
        tmpList.add(option);
      }
    }
    tmpList.add(optionWidget);
    _blocSecondary.value = tmpList;
  }

  @override
  FutureOr<void> dispose() {
    _blocSecondary.dispose();
  }
}
