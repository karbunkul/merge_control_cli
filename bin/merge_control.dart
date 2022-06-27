import 'package:merge_control_cli/merge_control.dart';

void main(List<String> args) {
  final runner = MergeGuardianRunner('merge-control', 'merge flow checker');

  runner.argParser.addOption(
    'from',
    abbr: 'f',
    help: 'Source branch',
  );
  runner.argParser.addOption(
    'to',
    abbr: 't',
    help: 'Destination branch',
  );

  final parser = runner.parse(args);

  print(checker('ios-123-test', 'development'));

  // runner.run(args);
}

bool checker(String from, String to) {
  final rules = [
    MergeConstraint(from: 'ios-*', to: 'development'),
    MergeConstraint(from: 'development', to: 'testflight'),
    MergeConstraint(from: 'testflight', to: 'master'),
    MergeConstraint(from: 'hotfix-*', to: 'master'),
  ];

  for (final rule in rules) {
    if (rule.resolve(from: from, to: to)) {
      return true;
    }
  }

  return false;
}
