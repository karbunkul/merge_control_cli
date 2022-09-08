import 'package:args/command_runner.dart';
import 'package:merge_control_cli/core/cli_helper.dart';

mixin BaseCommand on Command {
  /// Return project directory, default current dir
  String get projectDir {
    return CliHelper.projectDir(globalResults?[CliHelper.projectDirOption]);
  }
}
