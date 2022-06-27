class MergeConstraint {
  late RegExp source;
  late RegExp destination;

  MergeConstraint({
    required String from,
    required String to,
  }) {
    source = _toPattern(from);
    destination = _toPattern(to);
  }

  RegExp _toPattern(String src) {
    var val = src
        .trim()
        // replace all any symbol class to *
        .replaceAll('.*', '*')
        // remove leading /
        .replaceFirst(RegExp(r'^\/'), '')
        // remove trailing /
        .replaceFirst(RegExp(r'\/$'), '')
        // remove leading ^
        .replaceAll(RegExp(r'\^'), '')
        // replace * to any symbol class
        .replaceAll('*', '.*');

    final trailingIndex = val.indexOf(RegExp(r'\/.+'));
    if (trailingIndex != -1) {
      final flags = val.substring(trailingIndex + 1);
      val = val.substring(0, trailingIndex);

      return RegExp(
        '^$val\$',
        caseSensitive: !flags.contains('i'),
        dotAll: flags.contains('s'),
        unicode: flags.contains('u'),
      );
    }

    return RegExp('^$val\$');
  }

  bool resolve({required String from, required String to}) {
    return source.hasMatch(from) && destination.hasMatch(to);
  }
}
