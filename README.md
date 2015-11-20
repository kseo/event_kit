# event_kit

This is a simple library for implementing event subscription APIs. This project is inspired by [event-kit][event-kit].

[event-kit]: https://www.npmjs.com/package/event-kit

## Implementing Event Subscription APIs

```dart
import 'package:event_kit/event_kit.dart';

class User {
  final Emitter<String> _emitter = new Emitter<String>();

  String _name = '';

  Disposable onDidChangeName(void handler(String name)) =>
      _emitter.on('did-change-name', handler);

  void set name(String name) {
    if (_name != name) {
      _name = name;
      _emitter.emit('did-change-name', [name]);
    }
  }
}
```


In the example above, we implement `onDidChangeName` on the user object, which
will register callbacks to be invoked whenever the user's name changes. To do
so, we make use of an internal `Emitter` instance. We use `on` to subscribe
the given callback in `onDidChangeName`, and `emit` in `setName` to notify
subscribers. Finally, when the `User` instance is destroyed we call `dispose`
on the emitter to unsubscribe all subscribers.

## Consuming Event Subscription APIs

`Emitter.on` returns a `Disposable` instance, which has a `dispose` method.
To unsubscribe, simply call dispose on the returned object.

```dart
import 'package:event_kit/event_kit.dart';

var subscription = user.onDidChangeName((name) => print('My name is ${name}'));
// Later, to unsubscribe...
subscription.dispose();
```

You can also use `CompositeDisposable` to combine disposable instances together.

```dart
import 'package:event_kit/event_kit.dart';

var subscriptions = new CompositeDisposable();
subscriptions.add(user1.onDidChangeName((name) => print('User 1: ${name}')));
subscriptions.add(user2.onDidChangeName((name) => print('User 2: ${name}')));

// Later, to unsubscribe from *both*...
subscriptions.dispose();
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/kseo/event_kit/issues
