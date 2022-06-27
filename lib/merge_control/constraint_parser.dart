import 'package:merge_control_cli/merge_control/merge_constraint.dart';

class ConstraintParser {
  static List<MergeConstraint> parse(List<String> data) {
    final List<MergeConstraint> result = [];

    for (final rule in data) {
      result.addAll(_parseRule(rule));
    }

    return result;
  }

  static List<MergeConstraint> _parseRule(String rule) {
    final parts = rule.trim().split('>');

    assert(parts.length == 2);

    final from = parts[0].trim();
    final to = parts[1].trim();

    assert(!to.contains(','));

    if (from.contains(',')) {
      return from
          .split(',')
          .map((e) => MergeConstraint(from: e, to: to))
          .toList();
    } else {
      return [MergeConstraint(from: from, to: to)];
    }
  }
}
