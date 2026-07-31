class WeightRecord {
  final String id;
  final double weightKg;
  final DateTime date;

  WeightRecord({
    required this.id,
    required this.weightKg,
    required this.date,
  });

  // For GetX equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightRecord &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  WeightRecord copyWith({
    String? id,
    double? weightKg,
    DateTime? date,
  }) {
    return WeightRecord(
      id: id ?? this.id,
      weightKg: weightKg ?? this.weightKg,
      date: date ?? this.date,
    );
  }
}
