// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library event_kit.test;

import 'package:event_kit/event_kit.dart';
import 'package:test/test.dart';

void main() {
  group('Emitter tests', () {
    Emitter<String> emitter;

    setUp(() {
      emitter = new Emitter<String>();
    });

    test('invokes subscribers when the named event is emitted', () {
      final fooEvents = [];
      final barEvents = [];

      final sub1 = emitter.on('foo', (value) => fooEvents.add(['a', value]));
      final sub2 = emitter.on('bar', (value) => barEvents.add(['b', value]));

      emitter.emit('foo', [1]);
      emitter.emit('foo', [2]);
      emitter.emit('bar', [3]);

      sub1.dispose();

      emitter.emit('foo', [4]);
      emitter.emit('bar', [5]);

      sub2.dispose();

      emitter.emit('bar', [6]);

      expect(
          fooEvents,
          equals([
            ['a', 1],
            ['a', 2]
          ]));
      expect(
          barEvents,
          equals([
            ['b', 3],
            ['b', 5]
          ]));
    });

    test('invokes subscribers using emit0-event5', () {
      final arg0Events = [];
      final arg1Events = [];
      final arg2Events = [];
      final arg3Events = [];
      final arg4Events = [];
      final arg5Events = [];

      emitter.on('arg0', () => arg0Events.add([]));
      emitter.on('arg1', (arg1) => arg1Events.add([arg1]));
      emitter.on('arg2', (arg1, arg2) => arg2Events.add([arg1, arg2]));
      emitter.on(
          'arg3', (arg1, arg2, arg3) => arg3Events.add([arg1, arg2, arg3]));
      emitter.on('arg4',
          (arg1, arg2, arg3, arg4) => arg4Events.add([arg1, arg2, arg3, arg4]));
      emitter.on(
          'arg5',
          (arg1, arg2, arg3, arg4, arg5) =>
              arg5Events.add([arg1, arg2, arg3, arg4, arg5]));

      emitter.emit0('arg0');
      emitter.emit1('arg1', 1);
      emitter.emit2('arg2', 1, 2);
      emitter.emit3('arg3', 1, 2, 3);
      emitter.emit4('arg4', 1, 2, 3, 4);
      emitter.emit5('arg5', 1, 2, 3, 4, 5);

      expect(arg0Events, equals([[]]));
      expect(
          arg1Events,
          equals([
            [1]
          ]));
      expect(
          arg2Events,
          equals([
            [1, 2]
          ]));
      expect(
          arg3Events,
          equals([
            [1, 2, 3]
          ]));
      expect(
          arg4Events,
          equals([
            [1, 2, 3, 4]
          ]));
      expect(
          arg5Events,
          equals([
            [1, 2, 3, 4, 5]
          ]));
    });

    test('tests if there is any handler', () {
      final subscription = emitter.on('active', (_) {});

      expect(emitter.hasHandler('active'), isTrue);
      expect(emitter.hasHandler('unknown'), isFalse);

      subscription.dispose();
      expect(emitter.hasHandler('active'), isFalse);
    });

    test('clears all subscribers at once', () {
      final events = [];

      emitter.on('foo', (value) => events.add(['a', value]));
      emitter.on('foo', (value) => events.add(['b', value]));
      emitter.clear();

      emitter.emit('foo', [1]);
      emitter.emit('foo', [2]);

      expect(events, isEmpty);
    });
  });
}
