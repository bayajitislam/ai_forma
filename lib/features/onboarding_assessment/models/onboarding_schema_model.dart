class OnboardingSchemaModel {
  final int version;
  final List<OnboardingStepModel> steps;

  OnboardingSchemaModel({required this.version, required this.steps});

  factory OnboardingSchemaModel.fromJson(Map<String, dynamic> json) {
    return OnboardingSchemaModel(
      version: json['version'] ?? 1,
      steps: (json['steps'] as List? ?? [])
          .map((e) => OnboardingStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OnboardingStepModel {
  final String key;
  final String type;
  final String title;
  final String subtitle;
  final bool isRequired;
  final bool isSkippable;
  final num? min;
  final num? max;
  final dynamic defaultVal;
  final String? storeAs;
  final VisibleWhenModel? visibleWhen;
  final List<OptionItemModel> options;
  final List<UnitItemModel> units;

  OnboardingStepModel({
    required this.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.isRequired,
    required this.isSkippable,
    this.min,
    this.max,
    this.defaultVal,
    this.storeAs,
    this.visibleWhen,
    required this.options,
    required this.units,
  });

  factory OnboardingStepModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStepModel(
      key: json['key'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      isRequired: json['required'] ?? false,
      isSkippable: json['skippable'] ?? true,
      min: json['min'],
      max: json['max'],
      defaultVal: json['default'],
      storeAs: json['store_as'],
      visibleWhen: json['visible_when'] != null
          ? VisibleWhenModel.fromJson(
              json['visible_when'] as Map<String, dynamic>,
            )
          : null,
      options: (json['options'] as List? ?? [])
          .map((e) => OptionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      units: (json['units'] as List? ?? [])
          .map((e) => UnitItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VisibleWhenModel {
  final String field;
  final String equals;

  VisibleWhenModel({required this.field, required this.equals});

  factory VisibleWhenModel.fromJson(Map<String, dynamic> json) {
    return VisibleWhenModel(
      field: json['field'] ?? '',
      equals: json['equals'] ?? '',
    );
  }
}

class OptionItemModel {
  final String value;
  final String label;
  final String? description;

  OptionItemModel({
    required this.value,
    required this.label,
    this.description,
  });

  factory OptionItemModel.fromJson(Map<String, dynamic> json) {
    return OptionItemModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
      description: json['description'],
    );
  }
}

class UnitItemModel {
  final String unit;
  final num min;
  final num max;
  final num defaultVal;

  UnitItemModel({
    required this.unit,
    required this.min,
    required this.max,
    required this.defaultVal,
  });

  factory UnitItemModel.fromJson(Map<String, dynamic> json) {
    return UnitItemModel(
      unit: json['unit'] ?? '',
      min: json['min'] ?? 0,
      max: json['max'] ?? 100,
      defaultVal: json['default'] ?? 0,
    );
  }
}
