// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library event_kit.base;

import 'dart:async';

import 'package:disposable/disposable.dart';

/// A utility class to be used when implementing event-based APIs that allows
/// for handlers registered via [on] to be invoked with calls to [emit].
/// Instances of this class are intended to be used internally by classes
/// that expose an event-based API.
class Emitter<K> implements Disposable {
  final Map<K, StreamController> _emitterMap = new Map<K, StreamController>();

  bool _isDisposed = false;

  @override
  bool get isDisposed => _isDisposed;

  StreamController _getOrCreateEmitter(K eventName) {
    var emitter = _emitterMap[eventName];
    if (emitter == null) {
      emitter = new StreamController.broadcast(sync: true);
      _emitterMap[eventName] = emitter;
    }
    return emitter;
  }

  /// Registers the given event [handler] to be invoked whenever events by
  /// the given [eventName] are emitted via [emit].
  ///
  /// Returns a [Disposable] on which `.dispose()` can be called to unsubscribe.
  Disposable on(K eventName, Function handler) {
    StreamController emitter = _getOrCreateEmitter(eventName);
    final subscription = emitter.stream.listen((List arguments) {
      switch (arguments.length) {
        case 0:
          handler();
          break;
        case 1:
          handler(arguments[0]);
          break;
        case 2:
          handler(arguments[0], arguments[1]);
          break;
        case 3:
          handler(arguments[0], arguments[1], arguments[2]);
          break;
        case 4:
          handler(arguments[0], arguments[1], arguments[2], arguments[3]);
          break;
        case 5:
          handler(arguments[0], arguments[1], arguments[2], arguments[3],
              arguments[4]);
          break;
        default:
          throw new UnsupportedError('exceeded max arguments size');
      }
    });
    return new Disposable.from(subscription);
  }

  /// Invokes handlers registered via [on] for the given [eventName].
  ///
  /// Callbacks will be invoked with [arguments] as arguments.
  void emit(K eventName, [List arguments = const []]) {
    StreamController emitter = _getOrCreateEmitter(eventName);
    emitter.add(arguments);
  }

  /// Invokes handlers registered via [on] for the given [eventName].
  ///
  /// Callbacks will be invoked with no arguments.
  void emit0(K eventName) => emit(eventName, []);

  /// Invokes handlers registered via [on] for the given [eventName].
  ///
  /// Callbacks will be invoked with [arg1] as arguments.
  void emit1(K eventName, arg1) => emit(eventName, [arg1]);

  /// Invokes handlers registered via [on] for the given [eventName].
  ///
  /// Callbacks will be invoked with [arg1] and [arg2] as arguments.
  void emit2(K eventName, arg1, arg2) => emit(eventName, [arg1, arg2]);

  /// Invokes handlers registered via [on] for the given [eventName].
  ///
  /// Callbacks will be invoked with [arg1], [arg2] and [arg3] as arguments.
  void emit3(K eventName, arg1, arg2, arg3) =>
      emit(eventName, [arg1, arg2, arg3]);

  /// Invokes handlers registered via [on] for the given [eventName].
  ///
  /// Callbacks will be invoked with [arg1], [arg2], [arg3] and [arg4]
  /// as arguments.
  void emit4(K eventName, arg1, arg2, arg3, arg4) =>
      emit(eventName, [arg1, arg2, arg3, arg4]);

  /// Invokes handlers registered via [on] for the given [eventName].
  ///
  /// Callbacks will be invoked with [arg1], [arg2], [arg3], [arg4] and [arg5]
  /// as arguments.
  void emit5(K eventName, arg1, arg2, arg3, arg4, arg5) =>
      emit(eventName, [arg1, arg2, arg3, arg4, arg5]);

  /// Checks if there is any active handler for the given [eventName].
  bool hasHandler(K eventName) {
    var emitter = _emitterMap[eventName];
    return emitter != null && emitter.hasListener;
  }

  /// Clears out any existing subscribers.
  void clear() {
    for (final emitter in _emitterMap.values) {
      emitter.close();
    }
    _emitterMap.clear();
  }

  @override
  void dispose() {
    _isDisposed = true;
    clear();
  }
}
