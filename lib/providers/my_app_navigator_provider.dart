import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppRouterDelegate extends RouterDelegate<PageManager>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageManager> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyAppRouterDelegate() {
    myPageManager.addListener(notifyListeners);
  }

  @override
  PageManager? get currentConfiguration => myPageManager.currentConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: myPageManager.pages,
      onPopPage: myPageManager.didPop,
    );
    // return const _MyNavigator();
  }

  @override
  Future<void> setNewRoutePath(PageManager configuration) async {
    configuration.update();
  }

  @override
  Future<bool> popRoute() {
    //print('Atras desde el dispositivo');
    myPageManager.back();
    return Future.value(true);
  }
}

class MyAppRouteInformationParser extends RouteInformationParser<PageManager> {
  @override
  Future<PageManager> parseRouteInformation(RouteInformation routeInformation) {
    return Future.value(
        PageManager.fromRouteInformation(routeInformation, myPageManager));
  }

  @override
  RouteInformation? restoreRouteInformation(PageManager configuration) {
    return configuration.getCurrentUrl();
  }
}

const String _k404Name = '/404';

class PageManager extends ChangeNotifier {
  // Este page manager deberia ser unico en la aplicacion ???
  Widget page404Widget = const Page404Widget();
  Widget onBoardingPage = const OnBoardingPage();

  void update() {
    notifyListeners();
  }

  void removePageFromRoute(String route) {
    _removePageFromRoute(route);
    notifyListeners();
  }

  void _removePageFromRoute(String route) {
    if (route == '/') {
      return;
    }
    final tmpPages = <MaterialPage>[];
    for (final tmp in _pages) {
      if (tmp.name != route) {
        tmpPages.add(tmp);
      }
    }
    _pages.clear();
    _pages.addAll(tmpPages);
  }

  PageManager([this.routeInformation]) {
    setHomePage(onBoardingPage, null);
    set404Page(page404Widget, null);
  }

  PageManager.fromRouteInformation(
      this.routeInformation, PageManager currentPageManager) {
    setHomePage(currentPageManager.onBoardingPage);
    set404Page(currentPageManager.page404Widget);
    _pages.clear();
    _pages.addAll(currentPageManager.getAllPages);
    if (routeInformation != null) {
      final uri = Uri.parse(routeInformation?.location ?? '');
      MaterialPage page = currentPageManager.getPageFromDirectory(uri.path,
          arguments: uri.queryParametersAll);
      currentPageManager.push('/', onBoardingPage);
      currentPageManager.pushFromRoutesettings(uri.path, page);
    }
  }

  void setPageTitle(String title, [int? color]) {
    if (kIsWeb) {
      title = title.replaceAll('/', ' ').trim();
      try {
        SystemChrome.setApplicationSwitcherDescription(
            ApplicationSwitcherDescription(
          label: title,
          primaryColor: color, // This line is required
        ));
      } catch (e) {
        debugPrint('$e');
      }
    }
  }

  final pageController = StreamController<int>.broadcast()..add(1);

  Stream<int> get pagesStream => pageController.stream;

  final _directoryPagesMap = <String, MaterialPage>{};

  List<String> get directoryOfPages => _directoryPagesMap.keys.toList();

  void registerPageToDirectory(
      {required String routeName, required Widget widget, Object? arguments}) {
    routeName = validateRouteName(routeName);
    _directoryPagesMap[routeName] =
        MaterialPage(name: routeName, child: widget, arguments: arguments);
  }

  void removePageFromDirectory(String routeName) {
    _directoryPagesMap.remove(routeName);
    notifyListeners();
  }

  void _cleanDuplicateHomePages() {
    if (_pages.length > 1) {
      if (_pages.length > 1) {
        final tmpPages = <MaterialPage>[_pages[0]];
        for (int i = 1; i < _pages.length; i++) {
          final value = _pages[i];
          if (value.name != '/') {
            tmpPages.add(value);
          }
        }
        _pages.clear();
        _pages.addAll(tmpPages);
      }
    }
  }

  void setHomePage(Widget widget, [Object? arguments]) {
    /// This acts like the base of the navigator the main idea is first set the starting functions,
    _directoryPagesMap['/'] = MaterialPage(
        name: '/', key: UniqueKey(), child: widget, arguments: arguments);
    _pages[0] = _directoryPagesMap['/']!;
    _cleanDuplicateHomePages();
    onBoardingPage = widget;
  }

  void set404Page(Widget widget, [Object? arguments]) {
    _directoryPagesMap[_k404Name] = MaterialPage(
        name: _k404Name, key: UniqueKey(), child: widget, arguments: arguments);
    page404Widget = widget;
  }

  final _pages = <MaterialPage>[
    MaterialPage(name: '/', key: UniqueKey(), child: const OnBoardingPage()),
  ];

  PageManager get currentConfiguration => this;

  bool isThisRouteNameInDirectory(String routeName) {
    return _directoryPagesMap.containsKey(validateRouteName(routeName));
  }

  String validateRouteName(String routeName) {
    if (routeName.isEmpty || routeName[0] != '/') {
      routeName = '/$routeName';
    }
    return routeName;
  }

  void push(String routeName, Widget widget, [Object? arguments]) {
    routeName = validateRouteName(routeName);
    final page = MaterialPage(
        name: routeName, key: UniqueKey(), child: widget, arguments: arguments);
    _directoryPagesMap[routeName] = page;
    _pages.remove(page);
    _pages.add(page);
    pageController.sink.add(_pages.length);
    notifyListeners();
  }

  void pushAndReplacement(String routeName, Widget widget,
      [Object? arguments]) {
    back();
    push(routeName, widget, arguments);
  }

  void pushNamed(String routeName, [Object? arguments]) {
    Widget widget = getPageFromDirectory(routeName).child;
    push(routeName, widget, arguments);
  }

  void pushNamedAndReplacement(String routeName, [Object? arguments]) {
    back();
    Widget widget = getPageFromDirectory(routeName).child;
    push(routeName, widget, arguments);
  }

  void pushFromRoutesettings(String routeName, MaterialPage routeSettings) {
    if (validateRouteName(routeName).length > 1) {
      _pages.remove(routeSettings);
      _pages.add(routeSettings);
      pageController.sink.add(_pages.length);
      notifyListeners();
    }
  }

  int get historyPagesCount => _pages.length;

  RouteSettings get currentPage => _pages.last;

  List<Page> get pages => [List<Page>.unmodifiable(_pages).last];
  final RouteInformation? routeInformation;

  bool get isHome => true;

  List<MaterialPage> get getAllPages => List.unmodifiable(_pages);

  void back() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
    }
  }

  bool didPop(route, result) {
    back();
    return true;
  }

  @override
  dispose() {
    pageController.close();
    super.dispose();
  }

  MaterialPage getPageFromDirectory(String routeName, {Object? arguments}) {
    MaterialPage page = get404PageFromDirectory(arguments);
    if (isThisRouteNameInDirectory(routeName)) {
      page = _directoryPagesMap[routeName]!;
      page = MaterialPage(
          name: routeName,
          key: page.key,
          arguments: arguments,
          child: page.child);
    }
    return page;
  }

  MaterialPage get404PageFromDirectory([Object? arguments]) {
    if (!_directoryPagesMap.containsKey(_k404Name)) {
      set404Page(const Page404Widget(), arguments);
    }
    MaterialPage page = _directoryPagesMap[_k404Name]!;
    page = MaterialPage(
        child: page.child,
        arguments: arguments,
        key: page.key,
        name: page.name);
    return page;
  }

  void goTo404Page([Object? arguments]) {
    pushFromRoutesettings(_k404Name, get404PageFromDirectory(arguments));
  }

  RouteInformation? getCurrentUrl() {
    final uri = Uri(
        path: currentPage.name,
        queryParameters: currentPage.arguments as Map<String, dynamic>?);
    String location = uri.path;
    if (uri.query.isNotEmpty) {
      location = '$location?${uri.query}';
    }
    return RouteInformation(
      location: location,
    );
  }

  void clearHistory() {
    final tmp = _pages[0];
    _pages.clear();
    _pages.add(tmp);
    notifyListeners();
  }
}

final myPageManager = PageManager();

debugPrint(dynamic msg) {
  if (kDebugMode) {
    print(msg.toString());
  }
}

class Page404Widget extends StatelessWidget {
  const Page404Widget({Key? key, this.currentPageManager}) : super(key: key);

  final PageManager? currentPageManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Error 404'),
          leading: myPageManager.historyPagesCount > 1
              ? BackButton(
                  onPressed: myPageManager.back,
                )
              : null),
      body: Center(
        child:
            Text('Pagina No encontrada ${myPageManager.currentPage.arguments}'),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key, this.currentPageManager}) : super(key: key);
  final PageManager? currentPageManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Welcome page'),
          leading: myPageManager.historyPagesCount > 1
              ? BackButton(
                  onPressed: myPageManager.back,
                )
              : null),
      body: const Center(
        child: Text('Welcome Page'),
      ),
    );
  }
}
