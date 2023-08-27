A flutter package support jsonable class.

## Features

## Getting started

## Usage

```dart
/// a struct description a people
///
class People {
  People({
    required this.name,
    this.age = 10,
    required this.sex,
    this.children = const <People>[],
    this.parents = const <String, People>{},
  });

  factory People.fromJson(final Map<String, dynamic> json) => People(
        name: getValueFromJsonOrNull<String>(json, 'name'),
        age: getValueFromJsonOrDefault<int>(json, 'age', 10),
        sex: getValueFromJsonOrNull<String>(json, 'sex'),
        children: getListFromJson<People>(json, 'children'),
        parents: getMapFromJson<People>(json, 'parents'),
      );

  final String? name;

  final int age;

  final String? sex;

  final List<People> children;

  final Map<String, People> parents;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'age': age,
        'sex': sex,
        'children': getJsonFromList(children),
        'parents': getJsonFromMap(parents),
      };
}

```

