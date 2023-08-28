import 'package:flutter/foundation.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jsonable/flutter_jsonable.dart';

import 'people.dart';
import 'house.dart';

void main() {
  setUp(() {
    jsonableRegistry.registerJsonable(JsonableBuilder<People>(
      (obj) => obj.toJson(),
      (json) => People.fromJson(json),
    ));
    jsonableRegistry.registerJsonable(JsonableBuilder<House>(
      (obj) => obj.toJson(),
      (json) => House.fromJson(json),
    ));
  });

  test('People <=> json', () {
    final p1 = People(
      name: 'Jack_0',
      age: 10,
      sex: 'male',
      children: [
        People(name: 'Nacy', age: 2, sex: 'female'),
      ],
      parents: <String, People>{
        'mother': People(name: 'mother', age: 100, sex: 'female')
      },
    );
    final j1 = getJsonFromValue(p1);
    final p2 = getValueFromJson(<String, dynamic>{'people': j1}, 'people');
    final j2 = getJsonFromValue(p2);
    mapEquals(j1, j2);
  });

  test('List<People> <=> json', () {
    final p1 = <People>[
      People(
        name: 'Jack_0',
        age: 10,
        sex: 'male',
        children: [
          People(name: 'Nacy', age: 2, sex: 'female'),
        ],
        parents: <String, People>{
          'mother': People(name: 'mother', age: 100, sex: 'female')
        },
      )
    ];
    final j1 = getJsonFromList(p1);
    final p2 = getListFromJson<People>(<String, dynamic>{'peoples': j1}, 'peoples');
    listEquals(p1, p2);
  });

  test('Map<String, People> <=> json', () {
    final p1 = <String, People>{
      'people': People(
        name: 'Jack_0',
        age: 10,
        sex: 'male',
        children: [
          People(name: 'Nacy', age: 2, sex: 'female'),
        ],
        parents: <String, People>{
          'mother': People(name: 'mother', age: 100, sex: 'female')
        },
      )
    };
    final j1 = getJsonFromMap(p1);
    final p2 = getMapFromJson<People>(<String, dynamic>{'peoples': j1}, 'peoples');
    mapEquals(p1, p2);
  });
}
