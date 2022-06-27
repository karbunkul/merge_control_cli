import 'package:merge_control_cli/merge_control.dart';
import 'package:test/test.dart';

void main() {
  group('Merge control cli test', () {
    test('resolve merge flow', () {
      final rules = [
        'ios-*,master > development',
        'development > testflight',
        'testflight,hotfix-* > master',
      ];

      const feature = 'ios-16-test';
      const hotfix = 'hotfix-test';
      const development = 'development';
      const testflight = 'testflight';
      const master = 'master';

      final cases = [
        // ios-* > development success
        TestCase(from: feature, to: development, expected: true),
        // ios-* > testflight fail
        TestCase(from: feature, to: testflight, expected: false),
        // ios-* > master success
        TestCase(from: feature, to: master, expected: false),
        // master > development success
        TestCase(from: master, to: development, expected: true),
        // development > testflight success
        TestCase(from: development, to: testflight, expected: true),
        // testflight > master success
        TestCase(from: testflight, to: master, expected: true),
        // hotfix-* > master success
        TestCase(from: hotfix, to: master, expected: true),
      ];

      runTestCase(rules, cases);
    });

    test('parser tests', () {
      final rules = [
        'ios-*,master > development',
        'development > testflight',
        'testflight,hotfix-* > master',
      ];

      final constraints = ConstraintParser.parse(rules);

      expect(constraints.length, equals(5));
    });

    test('merge constraint tests', () {
      final constraint = MergeConstraint(from: '/^ios-*/i', to: 'development');

      expect(constraint.source.hasMatch('iOs-123-test'), equals(true));
      expect(constraint.source.hasMatch('fix-iOs-123-test'), equals(false));
    });
  });
}

void runTestCase(List<String> rules, List<TestCase> cases) {
  final constraints = ConstraintParser.parse(rules);
  final checker = ConstraintChecker(constraints);

  for (final testCase in cases) {
    expect(
      checker.check(from: testCase.from, to: testCase.to),
      equals(testCase.expected),
    );
  }
}

class TestCase {
  final String from;
  final String to;
  final bool expected;

  TestCase({
    required this.from,
    required this.to,
    required this.expected,
  });
}
