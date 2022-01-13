@JS()
library flutter_zoom_sdk_stringify;

import 'package:js/js.dart';

// Calls invoke JavaScript `JSON.stringify(obj)`.
@JS('JSON.stringify')
external String stringify(Object obj);
