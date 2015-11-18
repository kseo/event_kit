// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library event_kit.test;

import 'package:event_kit/event_kit.dart';
import 'package:test/test.dart';

void main() {
  group('Emitter tests', () {
    Emitter emitter;

    setUp(() {
      emitter = new Emitter();
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

      expect(fooEvents, equals([['a', 1], ['a', 2]]));
      expect(barEvents, equals([['b', 3], ['b', 5]]));
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
