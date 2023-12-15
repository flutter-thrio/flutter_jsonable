// Copyright (c) 2023 foxsofter.
//
// Do not edit this file.
//

import 'dart:convert';

import 'package:flutter_jsonable/flutter_jsonable.dart';

/// a struct description a people
///
class People {
  People({
    this.name = '',
    this.age = 10,
    this.sex = '',
    this.birthday,
    this.balance = 0.0,
    this.wife,
    this.aliases = const <String>[],
    this.children = const <People>[],
    this.parents = const <String, People>{},
  });

  factory People.fromJson(Map<String, dynamic> json) => People(
        name: getValueFromJsonOrNull<String>(json, 'name') ?? '',
        age: getValueFromJsonOrNull<int>(json, 'age') ?? 10,
        sex: getValueFromJsonOrNull<String>(json, 'sex') ?? '',
        birthday: getValueFromJsonOrNull<DateTime>(json, 'birthday'),
        wife: getValueFromJsonOrNull<People>(json, 'wife'),
        children:
            getListFromJsonOrNull<People>(json, 'children') ?? const <People>[],
        parents: getMapFromJsonOrNull<People>(json, 'parents') ??
            const <String, People>{},
      );

  factory People.copyWith(
    People other, {
    String? name,
    int? age,
    String? sex,
    DateTime? birthday,
    double? balance,
    People? wife,
    List<String>? aliases,
    List<People>? children,
    Map<String, People>? parents,
  }) {
    final otherJson = other.toJson();
    otherJson['name'] = name ?? otherJson['name'];
    otherJson['age'] = age ?? otherJson['age'];
    otherJson['sex'] = sex ?? otherJson['sex'];
    otherJson['birthday'] =
        getJsonFromValue<DateTime>(birthday) ?? otherJson['birthday'];
    otherJson['wife'] = getJsonFromValue<People>(wife) ?? otherJson['wife'];
    otherJson['children'] = getJsonFromList(children) ?? otherJson['children'];
    otherJson['parents'] = getJsonFromMap(parents) ?? otherJson['parents'];
    return People.fromJson(otherJson)
      ..balance = balance ?? other.balance
      ..aliases = aliases ?? other.aliases;
  }

  final String name;

  final int age;

  final String sex;

  final DateTime? birthday;

  double balance;

  final People? wife;

  List<String> aliases;

  final List<People> children;

  final Map<String, People> parents;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'age': age,
        'sex': sex,
        'birthday': getJsonFromValue<DateTime>(birthday),
        'wife': getJsonFromValue<People>(wife),
        'children': getJsonFromList(children),
        'parents': getJsonFromMap(parents),
      };

  @override
  String toString() => jsonEncode(toJson());
}
