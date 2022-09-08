import 'dart:convert';
import 'dart:io';

import 'package:merge_control_cli/merge_control.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class CliHelper {
  static const String projectDirOption = 'project-dir';
  static const String fromOption = 'from';
  static const String toOption = 'to';
  static const String verboseFlag = 'verbose';

  static String projectDir([String? dir]) {
    if (dir == null) {
      return p.current;
    }

    var path = p.normalize(dir);
    if (!p.isAbsolute(path)) {
      path = p.join(p.current, path);
    }

    if (Directory(path).existsSync()) {
      return path;
    }
    throw Exception('invalid dir');
  }

  static Future<String?> configPath(String? dir) async {
    if (dir != null) {
      return p.join(dir, 'merge-control.yaml');
    }
    return null;
  }

  static Future<bool> existConfig(String? dir) async {
    var cfgPath = await CliHelper.configPath(dir);
    if (cfgPath != null) {
      var file = File(cfgPath);
      if (await file.exists()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<List<MergeConstraint>> loadConstraints(String? dir) async {
    var cfgPath = await CliHelper.configPath(dir);
    if (cfgPath != null) {
      var file = File(cfgPath);
      if (await file.exists()) {
        var yaml = loadYaml(file.readAsStringSync());
        final json = jsonDecode(jsonEncode(yaml));
        final List<String> rules = json['constraints'].cast<String>();

        return ConstraintParser.parse(rules);
      } else {
        print('File $cfgPath not found');
        exit(1);
      }
    } else {
      throw Exception();
    }
  }
}
