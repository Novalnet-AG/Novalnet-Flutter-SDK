import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class ConfigLoader {
  static Future<Map<String, dynamic>> loadConfig() async {
    final yamlString = await rootBundle.loadString('assets/config.yaml');
    final yamlMap = loadYaml(yamlString);
    return Map<String, dynamic>.from(yamlMap);
  }
}
