/// Parses the install time from either JSON or plain `bm dump` output.
DateTime? parseDebugAppInstallTime(String? output) {
  if (output == null) return null;
  final match =
      RegExp(r'\binstallTime"?\s*:\s*(\d+)(?=[,\s}]|$)').firstMatch(output);
  final milliseconds = int.tryParse(match?.group(1) ?? '');
  if (milliseconds == null) return null;
  try {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  } on RangeError {
    return null;
  }
}
