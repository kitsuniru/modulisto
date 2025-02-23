import 'dart:async';

import 'package:modulisto/src/adapter/unit_adapter.dart';
import 'package:modulisto/src/interfaces.dart';

extension UnitToStreamAdapter<T> on UnitAdapter<Unit<T>> {
  Stream<T> stream({
    bool emitFirstImmediately = false,
  }) {
    late final StreamController<T> controller;

    void callback(T value) => controller.add(value);
    controller = StreamController.broadcast(
      onListen: () {
        if (unit is ValueUnit<T> && emitFirstImmediately) {
          controller.add((unit as ValueUnit<T>).value);
        }
      },
      onCancel: () => unit.removeListener(callback),
    );

    unit.addListener(callback);
    return controller.stream;
  }
}
