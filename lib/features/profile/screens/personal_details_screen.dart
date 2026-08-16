import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/dark_card.dart';
import '../../../shared/widgets/gradient_button.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  // Editable field values (session state — matches the app's UI-only model).
  final Map<String, String> _values = {
    'Full Name': 'Kumar Ayush',
    'Email': 'ayush@example.com',
    'Age': '20',
    'Height': '160 cm',
    'Weight': '66 kg',
  };

  Future<void> _editField(String label) async {
    final keyboard = (label == 'Age')
        ? TextInputType.number
        : (label == 'Email'
            ? TextInputType.emailAddress
            : TextInputType.text);

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => _EditFieldDialog(
        label: label,
        initialValue: _values[label] ?? '',
        keyboardType: keyboard,
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _values[label] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Icon(Icons.arrow_back,
                      color: AppColors.textPrimary, size: 22),
                ),
                const SizedBox(width: 12),
                const AppLogo(fontSize: 22),
              ],
            ),
            const SizedBox(height: 18),
            DarkCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Personal Details',
                          style: AppTextStyles.cardTitle),
                      GestureDetector(
                        onTap: () => _editField('Full Name'),
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          'Edit',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.accentText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(child: _avatar()),
                  const SizedBox(height: 24),
                  for (final entry in _values.entries) ...[
                    _DetailField(
                      label: entry.key,
                      value: entry.value,
                      onTap: () => _editField(entry.key),
                    ),
                    const SizedBox(height: 18),
                  ],
                  const SizedBox(height: 4),
                  GradientButton(
                    label: 'Save Changes',
                    color: AppColors.accent,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo picker coming soon')),
      ),
      child: SizedBox(
        width: 92,
        height: 92,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: AppColors.surface,
              child:
                  Icon(Icons.person, size: 46, color: AppColors.textSecondary),
            ),
            Positioned(
              right: 0,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt,
                    color: AppColors.onAccent, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Edit dialog that owns its own [TextEditingController] so it is disposed
/// only after the dialog is fully removed (avoids the "_dependents.isEmpty"
/// assertion from disposing a controller mid pop-animation).
class _EditFieldDialog extends StatefulWidget {
  final String label;
  final String initialValue;
  final TextInputType keyboardType;

  const _EditFieldDialog({
    required this.label,
    required this.initialValue,
    required this.keyboardType,
  });

  @override
  State<_EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<_EditFieldDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Edit ${widget.label}', style: AppTextStyles.cardTitle),
      content: CustomTextField(
        hint: widget.label,
        controller: _controller,
        dark: true,
        keyboardType: widget.keyboardType,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: AppTextStyles.small
                  .copyWith(color: AppColors.textSecondary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text('Save',
              style: AppTextStyles.small.copyWith(
                  color: AppColors.accentText, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DetailField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.small.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: AppTextStyles.small),
                Icon(Icons.chevron_right,
                    color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
