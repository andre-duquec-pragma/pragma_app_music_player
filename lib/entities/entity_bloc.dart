import 'dart:async';

extension RepeatLastValueExtension<T> on Stream<T> {
  Stream<T> call(T lastValue) {
    var done = false;
    var currentListeners = <MultiStreamController<T>>{};
    listen(
      (event) {
        for (var listener in [...currentListeners]) {
          listener.addSync(event);
        }
      },
      onError: (Object error, StackTrace stack) {
        for (var listener in [...currentListeners]) {
          listener.addErrorSync(error, stack);
        }
      },
      onDone: () {
        done = true;
        for (var listener in currentListeners) {
          listener.closeSync();
        }
        currentListeners.clear();
      },
    );
    return Stream.multi((controller) {
      if (done) {
        controller.close();
        return;
      }
      currentListeners.add(controller);
      controller.add(lastValue);
      controller.onCancel = () {
        currentListeners.remove(controller);
      };
    });
  }
}

/// [Bloc] es la clase de logica de negocios que derivara el resto de las clases bloc
abstract class Bloc<T> {
  T? _value;

  T get value => _value as T;
  // final StreamController<T> _streamController = BehaviorSubject<T>();
  final StreamController<T> _streamController = StreamController<T>.broadcast();

  Stream<T> get stream => _streamController.stream(value);

  set value(T val) {
    _streamController.sink.add(val);
    _value = val;
  }

  StreamSubscription? _suscribe;

  bool get isSubscribeActive => !(_suscribe == null);

  void _desuscribeStream() {
    _suscribe?.cancel();
    _suscribe = null;
  }

  void _setStreamSubsciption(void Function(T event) function) {
    _desuscribeStream();
    _suscribe = stream.listen((T event) {
      function(event);
    });
  }

  void dispose() {
    _desuscribeStream();
    _streamController.close();
  }
}

abstract class BlocModule {
  FutureOr<void> dispose();
}

class BlocCore {
  final Map<String, BlocGeneral> _injector = {};
  final Map<String, BlocModule> _moduleInjector = {};
  BlocGeneral<T> getBloc<T>(String key) {
    final tmp = _injector[key.toLowerCase()];
    if (tmp == null) throw ('The BlocGeneral were not initialized');
    return _injector[key.toLowerCase()] as BlocGeneral<T>;
  }

  T getBlocModule<T>(String key) {
    final tmp = _moduleInjector[key.toLowerCase()];
    if (tmp == null) throw ('The BlocModule were not initialized');
    return _moduleInjector[key.toLowerCase()] as T;
  }

  void addBlocGeneral<T>(String key, BlocGeneral<T> blocGeneral) {
    _injector[key.toLowerCase()] = blocGeneral;
  }

  void addBlocModule<T>(String key, BlocModule blocModule) {
    _moduleInjector[key.toLowerCase()] = blocModule;
  }

  void deleteBlocGeneral(String key) {
    key = key.toLowerCase();
    _injector[key]?.dispose();
    _injector.remove(key);
  }

  void deleteBlocModule(String key) {
    key = key.toLowerCase();
    _moduleInjector[key]?.dispose();
    _moduleInjector.remove(key);
  }

  void dispose() {
    _injector.forEach(
      (key, value) {
        value.dispose();
      },
    );
    _moduleInjector.forEach(
      (key, value) {
        value.dispose();
      },
    );
  }
}

class BlocGeneral<T> extends Bloc<T> {
  BlocGeneral(T valueTmp) {
    value = valueTmp;
    _setStreamSubsciption((event) {
      for (final element in _functionsMap.values) {
        element(event);
      }
    });
  }

  final Map<String, void Function(T val)> _functionsMap = {};

  void addFunctionToProcessTValueOnStream(
    String key,
    Function(T val) function,
  ) {
    _functionsMap[key.toLowerCase()] = function;
    // Ejecutamos la funcion instantaneamente con el valor actual
    function(value);
  }

  void deleteFunctionToProcessTValueOnStream(String key) {
    _functionsMap.remove(key);
  }

  get valueOrNull => value;

  void close() {
    dispose();
  }
}
