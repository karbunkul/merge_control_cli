import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:merge_control_cli/core/cli_helper.dart';

class MergeControlRunner extends CommandRunner {
  MergeControlRunner() : super('merge-control', 'merge flow checker') {
    _setup();
  }

  void _setup() {
    argParser.addOption(
      CliHelper.fromOption,
      abbr: 'f',
      help: 'Source branch',
    );

    argParser.addOption(
      CliHelper.toOption,
      abbr: 't',
      help: 'Destination branch',
    );

    argParser.addOption(
      CliHelper.projectDirOption,
      abbr: 'd',
      help: 'Default current directory',
    );

    argParser.addFlag(
      CliHelper.verboseFlag,
      help: 'Output log information',
      defaultsTo: true,
    );
  }

  @override
  String get invocation {
    return '$executableName [arguments]';
  }

  @override
  Future run(Iterable<String> args) async {
    final results = parse(args);

    final from = results.wasParsed('from') ? results['from'] : null;
    final to = results.wasParsed('to') ? results['to'] : null;

    if (from != null && to != null) {
      final projectDir = CliHelper.projectDir(
        results[CliHelper.projectDirOption],
      );

      if (await CliHelper.existConfig(projectDir)) {
        final constraints = await CliHelper.loadConstraints(projectDir);

        for (final constraint in constraints) {
          if (constraint.resolve(from: from, to: to)) {
            exit(0);
          }
        }
        print('Access denied');
        exit(1);
      } else {}
    }

    super.run(args);
  }
}
