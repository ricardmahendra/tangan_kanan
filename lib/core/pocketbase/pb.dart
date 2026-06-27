import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

String get _baseUrl {
  if (kIsWeb) {
    return 'http://127.0.0.1:8090/';
  }

  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8090';
  }

  return 'http://127.0.0.1:8090';
}

final pb = PocketBase(_baseUrl);