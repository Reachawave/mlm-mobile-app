Map<String, dynamic> changedFields(
  Map<String, dynamic> original,
  Map<String, dynamic> edited,
) {
  final out = <String, dynamic>{};
  for (final key in edited.keys) {
    final newVal = edited[key];
    if (newVal == null) continue;

    final oldVal = original[key];

    // normalize for comparison
    final normOld = (oldVal is String) ? oldVal.trim() : oldVal;
    final normNew = (newVal is String) ? newVal.trim() : newVal;

    if (normOld != normNew) {
      out[key] = newVal is String ? newVal.trim() : newVal;
    }
  }
  return out;
}
