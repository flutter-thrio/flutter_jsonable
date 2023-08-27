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

import 'jsonable.dart';

class JsonableBuilder<T> extends Jsonable<T> {
  JsonableBuilder(this._encoder, this._decoder) {
    if (T == dynamic || T == Object || T == Null) {
      throw ArgumentError.value(T, 'T', 'T can not be dynamic, Object or Null');
    }
    final typeName = T.toString();
    if (typeName.contains('<')) {
      throw ArgumentError.value(
          T, 'T', 'generic type cannot be used as jsonable type');
    }
  }

  final Map<String, dynamic> Function(T obj) _encoder;

  final T? Function(Map<String, dynamic>) _decoder;

  @override
  Map<String, dynamic> toJson(final T obj) => _encoder(obj);

  @override
  T? fromJson(final Map<String, dynamic> json) => _decoder(json);
}
