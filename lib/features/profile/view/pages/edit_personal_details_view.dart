import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/widgets/primary_button.dart';

class EditPersonalDetailsView extends StatefulWidget {
  const EditPersonalDetailsView({super.key});

  @override
  State<EditPersonalDetailsView> createState() => _EditPersonalDetailsViewState();
}

class _EditPersonalDetailsViewState extends State<EditPersonalDetailsView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'JOSH BOWDEN');
    _emailController = TextEditingController(text: 'JOSH.BOWDEN@GMAIL.COM');
    _dobController = TextEditingController(text: '20/04/2026');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
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
                      const SizedBox(height: 12),
                      _buildFormField(
                        label: 'Full Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'Email',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        label: 'Date of Birth',
                        controller: _dobController,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: 'SAVE CHANGES',
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
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.cardBorder.withOpacity(0.5),
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
