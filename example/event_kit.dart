// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library event_kit.example;

import 'package:event_kit/event_kit.dart';

class User {
  final Emitter<String> _emitter = new Emitter<String>();

  String _name = '';
  int _age = 0;

  Disposable onDidChangeName(void handler(String name)) =>
      _emitter.on('did-change-name', handler);

  Disposable onDidChangeAge(void handler(int oldAge, newAge)) =>
      _emitter.on('did-change-age', handler);

  void set name(String name) {
    if (_name != name) {
      _name = name;
      _emitter.emit('did-change-name', [name]);
    }
  }

  void set age(int newAge) {
    if (_age != newAge) {
      final oldAge = _age;
      _age = newAge;
      _emitter.emit('did-change-age', [oldAge, newAge]);
    }
  }
}

main() {
  final user = new User();
  final userSubscription = user.onDidChangeName((String name) {
    print('name: $name');
  });
  final ageSubscription = user.onDidChangeAge((int oldAge, int newAge) {
    print('oldAge: $oldAge, newAge: $newAge');
  });

  user.name = 'John';
  user.age = 35;
  // name: John
  // oldAge: 0, newAge: 35

  userSubscription.dispose();

  user.name = 'Michael';
  user.age = 20;
  // oldAge: 35, newAge: 20

  ageSubscription.dispose();

  user.name = 'Jane';
  user.age = 40;
}
