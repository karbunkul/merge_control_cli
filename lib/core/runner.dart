import 'dart:io';

import 'package:args/args.dart';
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
      CliHelper.presetOption,
      abbr: 's',
      help: 'Preset from environment variables',
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

    final String? preset = results.wasParsed(CliHelper.presetOption)
        ? results[CliHelper.presetOption]
        : null;

    String? from, to;

    if (preset != null) {
      final env = Platform.environment;
      switch (preset.toLowerCase()) {
        case 'gitlab':
          from = env['CI_MERGE_REQUEST_SOURCE_BRANCH_NAME'];
          to = env['CI_MERGE_REQUEST_TARGET_BRANCH_NAME'];
          break;

        default:
          from = results.parsed(CliHelper.fromOption);
          to = results.parsed(CliHelper.toOption);
          break;
      }
    }

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
      }
    }

    super.run(args);
  }
}

extension ParsedArg on ArgResults {
  String? parsed(String key) => wasParsed(key) ? this[key] : null;
}
