// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library event_kit.base;

import 'dart:async';

import 'package:disposable/disposable.dart';

/// A utility class to be used when implementing event-based APIs that allows
/// for handlers registered via [on] to be invoked with calls to [emit].
/// Instances of this class are intended to be used internally by classes
/// that expose an event-based API.
class Emitter implements Disposable {
  final Map<String, StreamController> _emitterMap =
      new Map<String, StreamController>();

  bool _isDisposed = false;

  @override
  bool get isDisposed => _isDisposed;

  StreamController _getOrCreateEmitter(String eventName) {
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
  Disposable on(String eventName, Function handler) {
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
          handler();
          break;
        case 5:
          handler(arguments[0], arguments[1], arguments[2], arguments[3],
              arguments[4]);
          handler();
          break;
        default:
          throw new UnsupportedError('exceeded max arguments size');
      }
    });
    return new Disposable.from(subscription);
  }

  /// Invokes handlers registered via [on] for the given [eventname].
  ///
  /// Callbacks will be invoked with [arguments] as arguments.
  void emit(String eventName, [List arguments = const []]) {
    StreamController emitter = _getOrCreateEmitter(eventName);
    emitter.add(arguments);
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

