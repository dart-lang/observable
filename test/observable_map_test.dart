// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:observable/observable.dart';
import 'package:test/test.dart';

import 'observable_test_utils.dart';

void main() {
  // TODO(jmesserly): need all standard Map API tests.

  StreamSubscription sub;

  void sharedTearDown() {
    if (sub != null) {
      sub.cancel();
      sub = null;
    }
  }

  group('observe length', () {
    ObservableMap map;
    List<ChangeRecord> changes;

    setUp(() {
      map = toObservable({'a': 1, 'b': 2, 'c': 3});
      changes = null;
      sub = map.changes.listen((records) {
        changes = getPropertyChangeRecords(records, #length);
      });
    });

    tearDown(sharedTearDown);

    test('add item changes length', () {
      map['d'] = 4;
      expect(map, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
      return Future(() {
        expect(changes, changeMatchers([_lengthChange(map, 3, 4)]));
      });
    });

    test('putIfAbsent changes length', () {
      map.putIfAbsent('d', () => 4);
      expect(map, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
      return Future(() {
        expect(changes, changeMatchers([_lengthChange(map, 3, 4)]));
      });
    });

    test('remove changes length', () {
      map.remove('c');
      map.remove('a');
      expect(map, {'b': 2});
      return Future(() {
        expect(
            changes,
            changeMatchers([
              _lengthChange(map, 3, 2),
              _lengthChange(map, 2, 1),
            ]));
      });
    });

    test('remove non-existent item does not change length', () {
      map.remove('d');
      expect(map, {'a': 1, 'b': 2, 'c': 3});
      return Future(() {
        expect(changes, null);
      });
    });

    test('set existing item does not change length', () {
      map['c'] = 9000;
      expect(map, {'a': 1, 'b': 2, 'c': 9000});
      return Future(() {
        expect(changes, []);
      });
    });

    test('clear changes length', () {
      map.clear();
      expect(map, {});
      return Future(() {
        expect(changes, changeMatchers([_lengthChange(map, 3, 0)]));
      });
    });
  });

  group('observe item', () {
    ObservableMap<String, int> map;
    List<ChangeRecord> changes;

    setUp(() {
      map = toObservable({'a': 1, 'b': 2, 'c': 3});
      changes = null;
      sub = map.changes.listen((records) {
        changes =
            records.where((r) => r is MapChangeRecord && r.key == 'b').toList();
      });
    });

    tearDown(sharedTearDown);

    test('putIfAbsent new item does not change existing item', () {
      map.putIfAbsent('d', () => 4);
      expect(map, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
      return Future(() {
        expect(changes, []);
      });
    });

    test('set item to null', () {
      map['b'] = null;
      expect(map, {'a': 1, 'b': null, 'c': 3});
      return Future(() {
        expect(changes, [_changeKey('b', 2, null)]);
      });
    });

    test('set item to value', () {
      map['b'] = 777;
      expect(map, {'a': 1, 'b': 777, 'c': 3});
      return Future(() {
        expect(changes, [_changeKey('b', 2, 777)]);
      });
    });

    test('putIfAbsent does not change if already there', () {
      map.putIfAbsent('b', () => 1234);
      expect(map, {'a': 1, 'b': 2, 'c': 3});
      return Future(() {
        expect(changes, null);
      });
    });

    test('change a different item', () {
      map['c'] = 9000;
      expect(map, {'a': 1, 'b': 2, 'c': 9000});
      return Future(() {
        expect(changes, []);
      });
    });

    test('change the item', () {
      map['b'] = 9001;
      map['b'] = 42;
      expect(map, {'a': 1, 'b': 42, 'c': 3});
      return Future(() {
        expect(changes, [
          _changeKey('b', 2, 9001),
          _changeKey('b', 9001, 42),
        ]);
      });
    });

    test('remove other items', () {
      map.remove('a');
      expect(map, {'b': 2, 'c': 3});
      return Future(() {
        expect(changes, []);
      });
    });

    test('remove the item', () {
      map.remove('b');
      expect(map, {'a': 1, 'c': 3});
      return Future(() {
        expect(changes, [_removeKey('b', 2)]);
      });
    });

    test('remove and add back', () {
      map.remove('b');
      map['b'] = 2;
      expect(map, {'a': 1, 'b': 2, 'c': 3});
      return Future(() {
        expect(changes, [
          _removeKey('b', 2),
          _insertKey('b', 2),
        ]);
      });
    });

    test('change the item as part of addAll', () {
      map.addAll({'b': 13, 'd': 4});
      expect(map, {'a': 1, 'b': 13, 'c': 3, 'd': 4});
      return Future(() {
        expect(changes, [_changeKey('b', 2, 13)]);
      });
    });

    test('change the item as part of addEntries', () {
      map.addEntries(
          [MapEntry<String, int>('b', 13), MapEntry<String, int>('d', 4)]);
      expect(map, {'a': 1, 'b': 13, 'c': 3, 'd': 4});
      return Future(() {
        expect(changes, [_changeKey('b', 2, 13)]);
      });
    });

    test('update the item', () {
      map.update('b', (int value) => value + 1);
      expect(map, {'a': 1, 'b': 3, 'c': 3});
      return Future(() {
        expect(changes, [_changeKey('b', 2, 3)]);
      });
    });

    test('update all items', () {
      map.updateAll((String key, int value) => value + 1);
      expect(map, {'a': 2, 'b': 3, 'c': 4});
      return Future(() {
        expect(changes, [_changeKey('b', 2, 3)]);
      });
    });

    test('remove the item as part of removeWhere', () {
      map.removeWhere((key, value) => value > 1);
      expect(map, {'a': 1});
      return Future(() {
        expect(changes, [_removeKey('b', 2)]);
      });
    });
  });

  test('toString', () {
    var map = toObservable({'a': 1, 'b': 2});
    expect(map.toString(), '{a: 1, b: 2}');
  });

  group('observe keys/values', () {
    ObservableMap map;
    int keysChanged;
    int valuesChanged;

    setUp(() {
      map = toObservable({'a': 1, 'b': 2, 'c': 3});
      keysChanged = 0;
      valuesChanged = 0;
      sub = map.changes.listen((records) {
        keysChanged += getPropertyChangeRecords(records, #keys).length;
        valuesChanged += getPropertyChangeRecords(records, #values).length;
      });
    });

    tearDown(sharedTearDown);

    test('add item changes keys/values', () {
      map['d'] = 4;
      expect(map, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
      return Future(() {
        expect(keysChanged, 1);
        expect(valuesChanged, 1);
      });
    });

    test('putIfAbsent changes keys/values', () {
      map.putIfAbsent('d', () => 4);
      expect(map, {'a': 1, 'b': 2, 'c': 3, 'd': 4});
      return Future(() {
        expect(keysChanged, 1);
        expect(valuesChanged, 1);
      });
    });

    test('remove changes keys/values', () {
      map.remove('c');
      map.remove('a');
      expect(map, {'b': 2});
      return Future(() {
        expect(keysChanged, 2);
        expect(valuesChanged, 2);
      });
    });

    test('remove non-existent item does not change keys/values', () {
      map.remove('d');
      expect(map, {'a': 1, 'b': 2, 'c': 3});
      return Future(() {
        expect(keysChanged, 0);
        expect(valuesChanged, 0);
      });
    });

    test('set existing item does not change keys', () {
      map['c'] = 9000;
      expect(map, {'a': 1, 'b': 2, 'c': 9000});
      return Future(() {
        expect(keysChanged, 0);
        expect(valuesChanged, 1);
      });
    });

    test('clear changes keys/values', () {
      map.clear();
      expect(map, {});
      return Future(() {
        expect(keysChanged, 1);
        expect(valuesChanged, 1);
      });
    });
  });

  group('change records', () {
    List<ChangeRecord> records;
    ObservableMap map;

    setUp(() {
      map = toObservable({'a': 1, 'b': 2});
      records = null;
      map.changes.first.then((r) => records = r);
    });

    tearDown(sharedTearDown);

    test('read operations', () {
      expect(map.length, 2);
      expect(map.isEmpty, false);
      expect(map['a'], 1);
      expect(map.containsKey(2), false);
      expect(map.containsValue(2), true);
      expect(map.containsKey('b'), true);
      expect(map.keys.toList(), ['a', 'b']);
      expect(map.values.toList(), [1, 2]);
      var copy = {};
      map.forEach((k, v) => copy[k] = v);
      expect(copy, {'a': 1, 'b': 2});
      return Future(() {
        // no change from read-only operators
        expect(records, null);

        // Make a change so the subscription gets unregistered.
        map.clear();
      });
    });

    test('putIfAbsent', () {
      map.putIfAbsent('a', () => 42);
      expect(map, {'a': 1, 'b': 2});

      map.putIfAbsent('c', () => 3);
      expect(map, {'a': 1, 'b': 2, 'c': 3});

      return Future(() {
        expect(
            records,
            changeMatchers([
              _lengthChange(map, 2, 3),
              _insertKey('c', 3),
              _propChange(map, #keys),
              _propChange(map, #values),
            ]));
      });
    });

    test('[]=', () {
      map['a'] = 42;
      expect(map, {'a': 42, 'b': 2});

      map['c'] = 3;
      expect(map, {'a': 42, 'b': 2, 'c': 3});

      return Future(() {
        expect(
            records,
            changeMatchers([
              _changeKey('a', 1, 42),
              _propChange(map, #values),
              _lengthChange(map, 2, 3),
              _insertKey('c', 3),
              _propChange(map, #keys),
              _propChange(map, #values),
            ]));
      });
    });

    test('remove', () {
      map.remove('b');
      expect(map, {'a': 1});

      return Future(() {
        expect(
            records,
            changeMatchers([
              _removeKey('b', 2),
              _lengthChange(map, 2, 1),
              _propChange(map, #keys),
              _propChange(map, #values),
            ]));
      });
    });

    test('clear', () {
      map.clear();
      expect(map, {});

      return Future(() {
        expect(
            records,
            changeMatchers([
              _removeKey('a', 1),
              _removeKey('b', 2),
              _lengthChange(map, 2, 0),
              _propChange(map, #keys),
              _propChange(map, #values),
            ]));
      });
    });
  });

  group('Updates delegate as a spy', () {
    Map delegate;
    ObservableMap map;

    setUp(() {
      delegate = {};
      map = ObservableMap.spy(delegate);
    });

    test('[]=', () {
      map['a'] = 42;
      expect(delegate, {'a': 42});
    });
  });
}

PropertyChangeRecord<int> _lengthChange(map, int oldValue, int newValue) =>
    PropertyChangeRecord<int>(map, #length, oldValue, newValue);

MapChangeRecord _changeKey(key, old, newValue) =>
    MapChangeRecord(key, old, newValue);

ChangeRecord _insertKey(key, newValue) => MapChangeRecord.insert(key, newValue);

ChangeRecord _removeKey(key, oldValue) => MapChangeRecord.remove(key, oldValue);

PropertyChangeRecord<Null> _propChange(map, prop) =>
    PropertyChangeRecord<Null>(map, prop, null, null);
