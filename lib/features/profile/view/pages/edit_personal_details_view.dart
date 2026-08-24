import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';
import 'package:ai_forma/features/auth/controllers/user_controller.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/measurement_wheel_picker.dart';
import 'package:ai_forma/features/onboarding_assessment/view/widgets/weight_selector.dart';

class EditPersonalDetailsView extends StatefulWidget {
  const EditPersonalDetailsView({super.key});

  @override
  State<EditPersonalDetailsView> createState() => _EditPersonalDetailsViewState();
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
  String? _selectedGender; // "male", "female", "prefer_not_to_say"
  double? _selectedHeightCm;
  double? _selectedWeightKg;
  bool _isSaving = false;
  File? _pickedImage;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : Get.put(UserController(Get.find()));

    final user = _userController.currentUser.value;
    final initialName = user?.fullName ?? '';
    final initialEmail = user?.email ?? '';
    final rawDob = user?.profile?.dateOfBirth;

    _selectedGender = user?.gender;
    if (user?.profile?.heightCm != null && user!.profile!.heightCm!.isNotEmpty) {
      _selectedHeightCm = double.tryParse(user.profile!.heightCm!);
    }
    if (user?.profile?.weightKg != null && user!.profile!.weightKg!.isNotEmpty) {
      _selectedWeightKg = double.tryParse(user.profile!.weightKg!);
    }

    _nameController = TextEditingController(text: initialName);
    _emailController = TextEditingController(text: initialEmail);
    _genderController = TextEditingController(text: _formatGenderDisplay(_selectedGender));
    _heightController = TextEditingController(
      text: _selectedHeightCm != null ? '${_selectedHeightCm!.toStringAsFixed(1)} cm' : '',
    );
    _weightController = TextEditingController(
      text: _selectedWeightKg != null ? '${_selectedWeightKg!.toStringAsFixed(1)} kg' : '',
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
    if (gender == 'male') return 'Male';
    if (gender == 'female') return 'Female';
    if (gender == 'prefer_not_to_say') return 'Prefer not to say';
    return gender[0].toUpperCase() + gender.substring(1);
  }

  String? _getProfileImageUrl() {
    final user = _userController.currentUser.value;
    return user?.profileImageUrl ?? user?.profile?.profileImageUrl;
  }

  DecorationImage? _getProfileImageDecoration() {
    final url = _getProfileImageUrl();
    if (url == null || url.isEmpty) return null;
    return DecorationImage(
      image: NetworkImage(url),
      fit: BoxFit.cover,
    );
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
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (_) {
        Get.snackbar(
          'Success',
          'Profile photo updated.',
          backgroundColor: AppColors.brandTeal,
          colorText: Colors.white,
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

  void _showGenderBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String tempGender = _selectedGender ?? 'male';
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Gender',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Male', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600)),
                    trailing: tempGender == 'male' ? const Icon(Icons.check_circle, color: AppColors.brandTeal) : null,
                    onTap: () => setModalState(() => tempGender = 'male'),
                  ),
                  ListTile(
                    title: const Text('Female', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600)),
                    trailing: tempGender == 'female' ? const Icon(Icons.check_circle, color: AppColors.brandTeal) : null,
                    onTap: () => setModalState(() => tempGender = 'female'),
                  ),
                  ListTile(
                    title: const Text('Prefer not to say', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600)),
                    trailing: tempGender == 'prefer_not_to_say' ? const Icon(Icons.check_circle, color: AppColors.brandTeal) : null,
                    onTap: () => setModalState(() => tempGender = 'prefer_not_to_say'),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    onPressed: () {
                      setState(() {
                        _selectedGender = tempGender;
                        _genderController.text = _formatGenderDisplay(tempGender);
                      });
                      Navigator.pop(ctx);
                    },
                    label: 'SAVE',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showHeightBottomSheet() {
    int tempHeightCm = (_selectedHeightCm ?? 175.0).round().clamp(100, 250);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Update Height',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              MeasurementWheelPicker(
                minValue: 100,
                maxValue: 250,
                initialValue: tempHeightCm,
                unit: 'cm',
                onChanged: (val) {
                  tempHeightCm = val;
                },
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                onPressed: () {
                  setState(() {
                    _selectedHeightCm = tempHeightCm.toDouble();
                    _heightController.text = '$tempHeightCm cm';
                  });
                  Navigator.pop(ctx);
                },
                label: 'SAVE',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWeightBottomSheet() {
    double tempWeightKg = _selectedWeightKg ?? 70.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Update Weight',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              WeightSelector(
                initialWeightKg: tempWeightKg,
                onChanged: (val) {
                  tempWeightKg = val;
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                onPressed: () {
                  setState(() {
                    _selectedWeightKg = tempWeightKg;
                    _weightController.text = '${tempWeightKg.toStringAsFixed(1)} kg';
                  });
                  Navigator.pop(ctx);
                },
                label: 'SAVE',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();
    final newDob = _dobController.text.trim();

    if (newName.isEmpty) {
      Get.snackbar(
        'Required',
        'Full Name cannot be empty.',
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    final payload = <String, dynamic>{
      'full_name': newName,
      if (newDob.isNotEmpty) 'date_of_birth': newDob,
      if (_selectedGender != null && _selectedGender!.isNotEmpty) 'gender': _selectedGender,
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
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (updatedUser) {
        Get.snackbar(
          'Success',
          'Profile updated successfully.',
          backgroundColor: AppColors.brandTeal,
          colorText: Colors.white,
        );
        Navigator.pop(context);
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
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personal Details',
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
                      Center(
                        child: GestureDetector(
                          onTap: _isUploadingImage ? null : _pickAndUploadImage,
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              children: [
                                // Avatar circle
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.dashboardBackground,
                                    border: Border.all(
                                      color: AppColors.cardBorder.withValues(alpha: 0.5),
                                      width: 2,
                                    ),
                                    image: _pickedImage != null
                                        ? DecorationImage(
                                            image: FileImage(_pickedImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : _getProfileImageDecoration(),
                                  ),
                                  child: (_pickedImage == null && _getProfileImageUrl() == null)
                                      ? const Icon(
                                          Icons.person,
                                          size: 44,
                                          color: AppColors.textSecondary,
                                        )
                                      : null,
                                ),
                                // Upload loading overlay
                                if (_isUploadingImage)
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withValues(alpha: 0.4),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Edit camera icon
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.brandTeal,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormField(
                        label: 'Full Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'Email',
                        controller: _emailController,
                        enabled: false,
                        hintText: 'Email address (Not editable)',
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'Date of Birth',
                        controller: _dobController,
                        readOnly: true,
                        onTap: _selectDateOfBirth,
                        hintText: 'Update Date of Birth',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary),
                          onPressed: _selectDateOfBirth,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'Gender',
                        controller: _genderController,
                        readOnly: true,
                        onTap: _showGenderBottomSheet,
                        hintText: 'Select Gender',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          onPressed: _showGenderBottomSheet,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'Height',
                        controller: _heightController,
                        readOnly: true,
                        onTap: _showHeightBottomSheet,
                        hintText: 'Select Height',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.straighten, color: AppColors.textSecondary),
                          onPressed: _showHeightBottomSheet,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'Weight',
                        controller: _weightController,
                        readOnly: true,
                        onTap: _showWeightBottomSheet,
                        hintText: 'Select Weight',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.monitor_weight_outlined, color: AppColors.textSecondary),
                          onPressed: _showWeightBottomSheet,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: _isSaving ? () {} : _saveChanges,
                label: _isSaving ? 'SAVING...' : 'SAVE CHANGES',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    Widget? suffixIcon,
    bool enabled = true,
    bool readOnly = false,
    VoidCallback? onTap,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            filled: !enabled,
            fillColor: !enabled ? AppColors.dashboardBackground : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffixIcon,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.cardBorder.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.brandTeal,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
