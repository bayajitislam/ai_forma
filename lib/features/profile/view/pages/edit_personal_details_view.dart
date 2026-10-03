import 'dart:io';

import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/app_snackbar.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/profile/constants/profile_strings.dart';
import 'package:ai_forma/features/profile/view/widgets/edit_profile_avatar.dart';
import 'package:ai_forma/features/profile/view/widgets/gender_selection_sheet.dart';
import 'package:ai_forma/features/profile/view/widgets/height_selection_sheet.dart';
import 'package:ai_forma/features/profile/view/widgets/profile_text_form_field.dart';
import 'package:ai_forma/features/profile/view/widgets/weight_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditPersonalDetailsView extends StatefulWidget {
  const EditPersonalDetailsView({super.key});

  @override
  State<EditPersonalDetailsView> createState() =>
      _EditPersonalDetailsViewState();
}

class _EditPersonalDetailsViewState extends State<EditPersonalDetailsView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _genderController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  late final UserController _userController;
  DateTime? _selectedDate;
  String? _selectedGender;
  double? _selectedHeightCm;
  double? _selectedWeightKg;
  bool _isSaving = false;
  File? _pickedImage;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();

    final user = _userController.currentUser.value;
    final initialName = user?.fullName ?? '';
    final initialEmail = user?.email ?? '';
    final rawDob = user?.profile?.dateOfBirth;

    _selectedGender = user?.gender;
    if (user?.profile?.heightCm != null &&
        user!.profile!.heightCm!.isNotEmpty) {
      _selectedHeightCm = double.tryParse(user.profile!.heightCm!);
    }
    if (user?.profile?.weightKg != null &&
        user!.profile!.weightKg!.isNotEmpty) {
      _selectedWeightKg = double.tryParse(user.profile!.weightKg!);
    }

    _nameController = TextEditingController(text: initialName);
    _emailController = TextEditingController(text: initialEmail);
    _genderController = TextEditingController(
      text: _formatGenderDisplay(_selectedGender),
    );
    _heightController = TextEditingController(
      text: _selectedHeightCm != null
          ? '${_selectedHeightCm!.toStringAsFixed(1)} cm'
          : '',
    );
    _weightController = TextEditingController(
      text: _selectedWeightKg != null
          ? '${_selectedWeightKg!.toStringAsFixed(1)} kg'
          : '',
    );

    if (rawDob != null && rawDob.isNotEmpty) {
      try {
        final parsed = DateTime.parse(rawDob);
        _selectedDate = parsed;
        _dobController = TextEditingController(
          text: DateFormat('yyyy-MM-dd').format(parsed),
        );
      } catch (_) {
        _dobController = TextEditingController(text: rawDob);
      }
    } else {
      _dobController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String _formatGenderDisplay(String? gender) {
    if (gender == null || gender.isEmpty) return '';
    if (gender == 'male') return ProfileStrings.genderMale;
    if (gender == 'female') return ProfileStrings.genderFemale;
    if (gender == 'prefer_not_to_say') return ProfileStrings.genderPreferNotToSay;
    return gender[0].toUpperCase() + gender.substring(1);
  }

  String? _getProfileImageUrl() {
    final user = _userController.currentUser.value;
    return user?.profileImageUrl ?? user?.profile?.profileImageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (picked == null) return;

    setState(() {
      _pickedImage = File(picked.path);
      _isUploadingImage = true;
    });

    final result = await _userController.updateProfileImage(picked.path);

    if (!mounted) return;

    setState(() {
      _isUploadingImage = false;
    });

    result.fold(
      (failure) {
        AppSnackbar.showError(
          failure.message,
          title: ProfileStrings.error,
        );
      },
      (_) {
        AppSnackbar.showSuccess(
          ProfileStrings.photoUpdatedSuccess,
          title: ProfileStrings.success,
        );
      },
    );
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final initial = _selectedDate ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandTeal,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showGenderSheet() {
    GenderSelectionSheet.show(
      context,
      initialGender: _selectedGender,
      onSelected: (gender) {
        setState(() {
          _selectedGender = gender;
          _genderController.text = _formatGenderDisplay(gender);
        });
      },
    );
  }

  void _showHeightSheet() {
    HeightSelectionSheet.show(
      context,
      initialHeightCm: _selectedHeightCm,
      onSelected: (height) {
        setState(() {
          _selectedHeightCm = height;
          _heightController.text = '${height.toStringAsFixed(1)} cm';
        });
      },
    );
  }

  void _showWeightSheet() {
    WeightSelectionSheet.show(
      context,
      initialWeightKg: _selectedWeightKg,
      onSelected: (weight) {
        setState(() {
          _selectedWeightKg = weight;
          _weightController.text = '${weight.toStringAsFixed(1)} kg';
        });
      },
    );
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();
    final newDob = _dobController.text.trim();

    if (newName.isEmpty) {
      AppSnackbar.showWarning(
        ProfileStrings.nameRequiredMessage,
        title: ProfileStrings.required,
      );
      return;
    }

    final payload = <String, dynamic>{
      'full_name': newName,
      if (newDob.isNotEmpty) 'date_of_birth': newDob,
      if (_selectedGender != null && _selectedGender!.isNotEmpty)
        'gender': _selectedGender,
      if (_selectedHeightCm != null)
        'height_cm': double.parse(_selectedHeightCm!.toStringAsFixed(1)),
      if (_selectedWeightKg != null)
        'weight_kg': double.parse(_selectedWeightKg!.toStringAsFixed(1)),
    };

    setState(() {
      _isSaving = true;
    });

    final result = await _userController.updateProfile(payload);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    result.fold(
      (failure) {
        AppSnackbar.showError(
          failure.message,
          title: ProfileStrings.error,
        );
      },
      (updatedUser) {
        AppSnackbar.showSuccess(
          ProfileStrings.profileUpdatedSuccess,
          title: ProfileStrings.success,
        );
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          ProfileStrings.editPersonalDetailsTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Profile Image Avatar
                      EditProfileAvatar(
                        pickedImage: _pickedImage,
                        imageUrl: _getProfileImageUrl(),
                        isUploadingImage: _isUploadingImage,
                        onTap: _pickAndUploadImage,
                      ),
                      const SizedBox(height: 24),
                      ProfileTextFormField(
                        label: ProfileStrings.fullNameLabel,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 20),
                      ProfileTextFormField(
                        label: ProfileStrings.emailLabel,
                        controller: _emailController,
                        enabled: false,
                        hintText: ProfileStrings.emailDisabledHint,
                      ),
                      const SizedBox(height: 20),
                      ProfileTextFormField(
                        label: ProfileStrings.dateOfBirthLabel,
                        controller: _dobController,
                        readOnly: true,
                        onTap: _selectDateOfBirth,
                        hintText: ProfileStrings.dobHint,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: _selectDateOfBirth,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ProfileTextFormField(
                        label: ProfileStrings.genderLabel,
                        controller: _genderController,
                        readOnly: true,
                        onTap: _showGenderSheet,
                        hintText: ProfileStrings.genderHint,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: _showGenderSheet,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ProfileTextFormField(
                        label: ProfileStrings.heightLabel,
                        controller: _heightController,
                        readOnly: true,
                        onTap: _showHeightSheet,
                        hintText: ProfileStrings.heightHint,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.straighten,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: _showHeightSheet,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ProfileTextFormField(
                        label: ProfileStrings.weightLabel,
                        controller: _weightController,
                        readOnly: true,
                        onTap: _showWeightSheet,
                        hintText: ProfileStrings.weightHint,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.monitor_weight_outlined,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: _showWeightSheet,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: _isSaving ? () {} : _saveChanges,
                label: _isSaving
                    ? ProfileStrings.saving
                    : ProfileStrings.saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
