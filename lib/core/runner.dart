import 'package:args/command_runner.dart';

class MergeGuardianRunner extends CommandRunner {
  MergeGuardianRunner(super.executableName, super.description);

  @override
  String get invocation {
    return '$executableName [arguments]';
  }
}
