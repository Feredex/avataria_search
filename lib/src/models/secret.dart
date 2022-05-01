import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class SecretLoader {
  static const String _secretsPath = 'secrets.json';

  static Future<String> load(String secretKey) {
    return rootBundle.loadStructuredData<String>(
      _secretsPath,
      (jsonStr) async => json.decode(jsonStr)[secretKey],
    );
  }
}
