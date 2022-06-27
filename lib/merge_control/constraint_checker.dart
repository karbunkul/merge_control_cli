import 'package:merge_control_cli/merge_control/merge_constraint.dart';

class ConstraintChecker {
  final List<MergeConstraint> constraints;

  ConstraintChecker(this.constraints);

  bool check({required String from, required String to}) {
    for (final rule in constraints) {
      if (rule.resolve(from: from, to: to)) {
        return true;
      }
    }

    return false;
  }
}
