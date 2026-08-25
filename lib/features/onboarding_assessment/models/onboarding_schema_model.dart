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
  final String? infoNote;
  final String? icon;
  final num? min;
  final num? max;
  final dynamic defaultVal;
  final String? storeAs;
  final VisibleWhenModel? visibleWhen;
  final List<OptionItemModel> options;
  final List<UnitItemModel> units;
  final List<CategoryItemModel> categories;

  OnboardingStepModel({
    required this.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.isRequired,
    required this.isSkippable,
    this.infoNote,
    this.icon,
    this.min,
    this.max,
    this.defaultVal,
    this.storeAs,
    this.visibleWhen,
    required this.options,
    required this.units,
    required this.categories,
  });

  factory OnboardingStepModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStepModel(
      key: json['key'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      isRequired: json['required'] ?? false,
      isSkippable: json['skippable'] ?? true,
      infoNote: json['info_note']?.toString(),
      icon: json['icon']?.toString(),
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
      categories: (json['categories'] as List? ?? [])
          .map((e) => CategoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CategoryItemModel {
  final String title;
  final String key;
  final String? icon;
  final List<OptionItemModel> options;

  CategoryItemModel({
    required this.title,
    required this.key,
    this.icon,
    required this.options,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      title: json['title'] ?? '',
      key: json['key'] ?? '',
      icon: json['icon']?.toString(),
      options: (json['options'] as List? ?? [])
          .map((e) => OptionItemModel.fromJson(e as Map<String, dynamic>))
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
  final String? icon;

  OptionItemModel({
    required this.value,
    required this.label,
    this.description,
    this.icon,
  });

  factory OptionItemModel.fromJson(Map<String, dynamic> json) {
    return OptionItemModel(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
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
