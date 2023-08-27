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
T getValueFromJson<T>(final dynamic json, final String key) {
  final val = getValueFromJsonOrNull<T>(json, key);
  if (val != null) {
    return val;
  }
  throw ArgumentError.notNull('json[$key]');
}

/// Get value from [json], return `defaultValue` when`key`'s value not found .
///
T getValueFromJsonOrDefault<T>(
  final dynamic json,
  final String key,
  final T defaultValue,
) {
  final val = getValueFromJsonOrNull<T>(json, key);
  if (val != null) {
    return val;
  }
  return defaultValue;
}

/// Get value from [json], return `null` when`key`'s value not found .
///
T? getValueFromJsonOrNull<T>(final dynamic json, final String key) {
  if (json == null || json is! Map || json.isEmpty) {
    return null;
  }
  final val = json[key];
  if (val is T) {
    return val;
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

/// Get list from [json], return empty list when `key`'s value not found.
///
List<E> getListFromJson<E>(final dynamic json, final String key) {
  if (json == null || json is! Map || json.isEmpty) {
    return <E>[];
  }
  final val = json[key];
  if (val is! List || val.isEmpty) {
    return <E>[];
  }
  final first = val.first;
  if (first is Map) {
    final jsonable = jsonableRegistry.getByTypeName(E.runtimeType.toString());
    if (jsonable != null) {
      return val
          .map((final e) => e is Map
              ? jsonable.fromJson(Map<String, dynamic>.from(e))
              : null)
          .whereType<E>()
          .toList();
    }
  }
  return List<E>.from(val);
}

/// Get map from [json], return empty map when `key`'s value not found.
///
Map<String, V> getMapFromJson<V>(final dynamic json, final String key) {
  if (json == null || json is! Map || json.isEmpty) {
    return <String, V>{};
  }
  final val = json[key];
  if (val is! Map || val.isEmpty) {
    return <String, V>{};
  }
  final first = val.values.first;
  if (first is Map) {
    final jsonable = jsonableRegistry.getByTypeName(V.toString());
    if (jsonable != null) {
      final results = <String, V>{};
      final es = Map<String, dynamic>.from(val);
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
  return Map<String, V>.from(val);
}

/// Get json from [value], return [value] when `T`'s jsonable not found.
///
dynamic getJsonFromValue<T>(final T? value) {
  if (value == null) {
    return null;
  }
  final jsonable = jsonableRegistry.getByType<T>();
  if (jsonable == null) {
    return value;
  }
  return jsonable.toJson(value);
}

/// Get json from [list], support jsonable element type.
///
dynamic getJsonFromList(final dynamic list) {
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
dynamic getJsonFromMap(final dynamic map) {
  if (map == null || map is! Map || map.isEmpty) {
    return null;
  }
  final first = map.values.first;
  final typeName = first.runtimeType.toString();
  if (typeName.contains('List')) {
    return map.map((final k, final v) => MapEntry(k, getJsonFromList(v)));
  } else if (typeName.contains('Map')) {
    return map.map((final k, final v) => MapEntry(k, getJsonFromMap(v)));
  } else {
    final jsonable =
        jsonableRegistry.getByTypeName(first.runtimeType.toString());
    if (jsonable != null) {
      return map.map((final k, final v) => MapEntry(k, jsonable.toJson(v)));
    }
    return map;
  }
}
