// The MIT License (MIT)
//
// Copyright (c) 2023 foxsofter
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import 'jsonable_registry.dart';

/// Get value from [json], throw ArgumentError when`key`'s value not found .
///
T getValueFromJson<T>(dynamic json, String key) =>
    getValueFromJsonOrNull<T>(json, key) ??
    (throw ArgumentError.notNull('json[$key]'));

/// Get value from [json], return `defaultValue` when`key`'s value not found .
///
T getValueFromJsonOrDefault<T>(
  final dynamic json,
  final String key,
  final T defaultValue,
) =>
    getValueFromJsonOrNull<T>(json, key) ?? defaultValue;

/// Get value from [json], return [null] when`key`'s value not found .
///
T? getValueFromJsonOrNull<T>(dynamic json, String key) {
  if (json == null || json is! Map || json.isEmpty) {
    return null;
  }
  final val = json[key];
  if (val is T) {
    return val;
  }
  if (T == DateTime && val is String) {
    return DateTime.tryParse(val) as T?;
  }
  if (val is Map) {
    final jsonable = jsonableRegistry.getByType<T>();
    final value = jsonable?.fromJson(Map<String, dynamic>.from(val));
    if (value is T) {
      return value;
    }
  }
  return null;
}

/// Get value from [json], throw ArgumentError when`key`'s value not found .
///
List<E> getListFromJson<E>(dynamic json, String key) =>
    getListFromJsonOrNull(json, key) ??
    (throw ArgumentError.notNull('json[$key]'));

/// Get list from [json]
///
/// return [null] when `key`'s value not found.
///
/// return empty list when `key`'s value is empty list.
///
List<E>? getListFromJsonOrNull<E>(dynamic json, String key) {
  if (json == null || json is! Map || json.isEmpty) {
    return null;
  }
  final val = json[key];
  if (val is! List) {
    return null;
  }
  final first = val.first;

  if (E == DateTime && first is String) {
    return val
        .whereType<String>()
        .map<E>((e) => DateTime.tryParse(e) as E? ?? (throw Error()))
        .toList();
  }

  if (first is Map) {
    final jsonable = jsonableRegistry.getByType<E>();
    if (jsonable != null) {
      final results = <E>[];
      for (final e in val) {
        if (e is! Map) {
          continue;
        }
        final v = e.whereType<String, dynamic>();
        if (v.isNotEmpty) {
          final ev = jsonable.fromJson(v);
          if (ev is E) {
            results.add(ev);
          }
        }
      }
      return results;
    }
  }
  final list = val.whereType<E>().toList();
  if (list.isEmpty) {
    return null;
  }
  return list;
}

/// Get list from [json]
///
/// return `defaultValue` when `key`'s value not found.
///
/// return empty list when `key`'s value is empty list.
///
List<E> getListFromJsonOrDefault<E>(
  dynamic json,
  String key,
  List<E> defaultValue,
) =>
    getListFromJsonOrNull(json, key) ?? defaultValue;

/// Get map from [json], throw ArgumentError when`key`'s value not found .
///
Map<String, V> getMapFromJson<V>(dynamic json, String key) =>
    getMapFromJsonOrNull(json, key) ??
    (throw ArgumentError.notNull('json[$key]'));

/// Get map from [json]
///
/// return [null] when `key`'s value not found.
///
/// return empty map when `key`'s value is empty list.
///
Map<String, V>? getMapFromJsonOrNull<V>(dynamic json, String key) {
  if (json == null || json is! Map || json.isEmpty) {
    return null;
  }
  final val = json[key];
  if (val is! Map) {
    return null;
  }
  if (V == DateTime && val is String) {
    return val.whereType<String, String>().map((k, v) {
      final nv = DateTime.tryParse(v) as V? ?? (throw Error());
      return MapEntry(k, nv);
    });
  }
  final first = val.values.first;
  if (first is Map) {
    final jsonable = jsonableRegistry.getByType<V>();
    if (jsonable != null) {
      final results = <String, V>{};
      final es = val.whereType<String, dynamic>();
      for (final k in es.keys) {
        final v = es[k];
        if (v is Map) {
          final ev = jsonable.fromJson(Map<String, dynamic>.from(v));
          if (ev is V) {
            results[k] = ev;
          }
        }
      }
      return results;
    }
  }
  final map = val.whereType<String, V>();
  if (map.isEmpty) {
    return null;
  }
  return map;
}

/// Get map from [json]
///
/// return [defaultValue] when `key`'s value not found.
///
/// return empty map when `key`'s value is empty list.
///
Map<String, V> getMapFromJsonOrDefault<V>(
  dynamic json,
  String key,
  Map<String, V> defaultValue,
) =>
    getMapFromJsonOrNull(json, key) ?? defaultValue;

/// Get json from [value], return [value] when `T`'s jsonable not found.
///
dynamic getJsonFromValue<T>(T? value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value.toIso8601String();
  }
  final jsonable = jsonableRegistry.getByType<T>();
  if (jsonable == null) {
    return value;
  }
  return jsonable.toJson(value);
}

/// Get json from [list], support jsonable element type.
///
dynamic getJsonFromList(dynamic list) {
  if (list == null || list is! List || list.isEmpty) {
    return null;
  }
  final first = list.first;
  final typeName = first.runtimeType.toString();
  if (typeName.contains('List')) {
    return list.map(getJsonFromList).toList();
  } else if (typeName.contains('Map')) {
    return list.map(getJsonFromMap).toList();
  } else {
    final jsonable = jsonableRegistry.getByTypeName(typeName);
    if (jsonable != null) {
      return list.map(jsonable.toJson).toList();
    }
  }
  return list;
}

/// Get json form [map], support jsonable element type.
///
dynamic getJsonFromMap(dynamic map) {
  if (map == null || map is! Map || map.isEmpty) {
    return null;
  }
  final first = map.values.first;
  final typeName = first.runtimeType.toString();
  if (typeName.contains('List')) {
    return map.map((k, v) => MapEntry(k, getJsonFromList(v)));
  } else if (typeName.contains('Map')) {
    return map.map((k, v) => MapEntry(k, getJsonFromMap(v)));
  } else {
    final jsonable = jsonableRegistry.getByTypeName(typeName);
    if (jsonable != null) {
      return map.map((k, v) => MapEntry(k, jsonable.toJson(v)));
    }
    return map;
  }
}

extension MapX<K, V> on Map<K, V> {
  /// Creates a new [Map] with all keys that have type [RK]
  /// and all values have type [RV].
  ///
  Map<RK, RV> whereType<RK, RV>() {
    final map = <RK, RV>{};
    for (final k in keys) {
      final v = this[k];
      if (k is RK && v is RV) {
        map[k] = v;
      }
    }
    return map;
  }
}
