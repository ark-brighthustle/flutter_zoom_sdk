@JS()
library zoom_interpo;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

/// A workaround to converting an object from JS to a Dart Map.
Map jsToMap(jsObject) {
  return Map.fromIterable(
    _getKeysOfObject(jsObject),
    value: (key) => getProperty(jsObject, key),
  );
}

/// A workaround to converting an object to a Dart.
dynamic convertToDart(value) {
  /// Value types.
  if (value == null) return null;
  if (value is bool || value is num || value is DateTime || value is String) {
    return value;
  }

  /// JsArray.
  if (value is Iterable) return value.map(convertToDart).toList();
  return jsToMap(value);
}

// Both of these interfaces exist to call `Object.keys` from Dart.
//
// But you don't use them directly. Just see `jsToMap`.
@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);
