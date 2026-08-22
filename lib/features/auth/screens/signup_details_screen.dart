import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../profile/services/user_repository.dart';
import '../services/auth_service.dart';
import '../../../shared/widgets/animations/entrance.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/dropdown_chip.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/ruler_picker.dart';

/// "Enter your details" walkthrough shown after sign-up.
/// UI only — values are held in local state and not persisted.
class SignupDetailsScreen extends StatefulWidget {
  const SignupDetailsScreen({super.key});

  @override
  State<SignupDetailsScreen> createState() => _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends State<SignupDetailsScreen> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _username = TextEditingController();

  // Values are always kept in the currently selected unit and converted when
  // the unit toggles, so the physical measurement stays the same.
  int _height = 173; // cm
  int _weight = 70; // kg
  int _targetWeight = 70; // kg
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';
  String _targetUnit = 'kg';

  static const double _cmPerInch = 2.54;
  static const double _lbPerKg = 2.20462;

  // Ranges per unit — used for the ruler bounds so the same physical span is
  // covered regardless of unit.
  static const int _heightMinCm = 120, _heightMaxCm = 220;
  static const int _weightMinKg = 40, _weightMaxKg = 150;
  int get _heightMin =>
      _heightUnit == 'cm' ? _heightMinCm : (_heightMinCm / _cmPerInch).round();
  int get _heightMax =>
      _heightUnit == 'cm' ? _heightMaxCm : (_heightMaxCm / _cmPerInch).round();
  int _weightMin(String unit) =>
      unit == 'kg' ? _weightMinKg : (_weightMinKg * _lbPerKg).round();
  int _weightMax(String unit) =>
      unit == 'kg' ? _weightMaxKg : (_weightMaxKg * _lbPerKg).round();

  void _onHeightUnit(String u) {
    if (u == _heightUnit) return;
    setState(() {
      _height = u == 'in'
          ? (_height / _cmPerInch).round() // cm -> in
          : (_height * _cmPerInch).round(); // in -> cm
      _heightUnit = u;
    });
  }

  void _onWeightUnit(String u) {
    if (u == _weightUnit) return;
    setState(() {
      _weight = u == 'lb'
          ? (_weight * _lbPerKg).round() // kg -> lb
          : (_weight / _lbPerKg).round(); // lb -> kg
      _weightUnit = u;
    });
  }

  void _onTargetUnit(String u) {
    if (u == _targetUnit) return;
    setState(() {
      _targetWeight = u == 'lb'
          ? (_targetWeight * _lbPerKg).round()
          : (_targetWeight / _lbPerKg).round();
      _targetUnit = u;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _username.dispose();
    super.dispose();
  }

  double _toCm(int v, String unit) => unit == 'in' ? v * _cmPerInch : v.toDouble();
  double _toKg(int v, String unit) => unit == 'lb' ? v / _lbPerKg : v.toDouble();

  /// Writes the entered details onto the Firebase account (display name) and
  /// the Firestore profile document, then drops the user into the app. Wrapped
  /// so a write failure (e.g. offline) never traps them on this screen.
  Future<void> _finish() async {
    try {
      await AuthService.instance.updateDisplayName(_name.text);
      await UserRepository.instance.updateProfile(
        displayName: _name.text.trim().isEmpty ? null : _name.text.trim(),
        age: int.tryParse(_age.text.trim()),
        heightCm: _toCm(_height, _heightUnit),
        weightKg: _toKg(_weight, _weightUnit),
        targetWeightKg: _toKg(_targetWeight, _targetUnit),
      );
    } catch (_) {
      // Non-fatal: the profile can be completed later from the Profile tab.
    }
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.main, (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: StaggerReveal(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your details',
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 28),
              _label('Name'),
              CustomTextField(hint: 'Name *', controller: _name, pill: true),
              const SizedBox(height: 20),
              _label('Age'),
              CustomTextField(
                hint: 'Age *',
                controller: _age,
                keyboardType: TextInputType.number,
                pill: true,
              ),
              const SizedBox(height: 20),
              _label('Username'),
              CustomTextField(
                  hint: 'Username *', controller: _username, pill: true),
              const SizedBox(height: 24),
              _rulerSection(
                title: 'Height',
                unit: _heightUnit,
                units: const ['cm', 'in'],
                onUnit: _onHeightUnit,
                min: _heightMin,
                max: _heightMax,
                value: _height,
                onChanged: (v) => _height = v,
                onEdit: () => _editValue(
                  title: 'Height',
                  unit: _heightUnit,
                  min: _heightMin,
                  max: _heightMax,
                  current: _height,
                  onSet: (v) => setState(() => _height = v),
                ),
              ),
              const SizedBox(height: 20),
              _rulerSection(
                title: 'Weight',
                unit: _weightUnit,
                units: const ['kg', 'lb'],
                onUnit: _onWeightUnit,
                min: _weightMin(_weightUnit),
                max: _weightMax(_weightUnit),
                value: _weight,
                onChanged: (v) => _weight = v,
                onEdit: () => _editValue(
                  title: 'Weight',
                  unit: _weightUnit,
                  min: _weightMin(_weightUnit),
                  max: _weightMax(_weightUnit),
                  current: _weight,
                  onSet: (v) => setState(() => _weight = v),
                ),
              ),
              const SizedBox(height: 20),
              _rulerSection(
                title: 'Target Weight',
                unit: _targetUnit,
                units: const ['kg', 'lb'],
                onUnit: _onTargetUnit,
                min: _weightMin(_targetUnit),
                max: _weightMax(_targetUnit),
                value: _targetWeight,
                onChanged: (v) => _targetWeight = v,
                onEdit: () => _editValue(
                  title: 'Target Weight',
                  unit: _targetUnit,
                  min: _weightMin(_targetUnit),
                  max: _weightMax(_targetUnit),
                  current: _targetWeight,
                  onSet: (v) => setState(() => _targetWeight = v),
                ),
              ),
              const SizedBox(height: 32),
              GradientButton(
                label: 'Next',
                color: AppColors.accent,
                onPressed: _finish,
                trailingIcon: const Icon(Icons.chevron_right,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      );

  Widget _rulerSection({
    required String title,
    required String unit,
    required List<String> units,
    required ValueChanged<String> onUnit,
    required int min,
    required int max,
    required int value,
    required ValueChanged<int> onChanged,
    required VoidCallback onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                // Manual entry — type an exact value instead of dragging.
                IconButton(
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Enter manually',
                  icon: const Icon(Icons.keyboard_alt_outlined,
                      color: Colors.white70, size: 22),
                ),
                const SizedBox(width: 4),
                DropdownChip(value: unit, options: units, onSelected: onUnit),
              ],
            ),
          ],
        ),
        RulerPicker(
          // Keyed on the value/unit so a manual edit or unit switch re-seeds
          // the ruler to the new number instead of keeping the dragged one.
          key: ValueKey('$title-$value-$unit'),
          min: min,
          max: max,
          initialValue: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// Opens a small dialog to type an exact value, clamped to [min]..[max].
  Future<void> _editValue({
    required String title,
    required String unit,
    required int min,
    required int max,
    required int current,
    required ValueChanged<int> onSet,
  }) async {
    final result = await showDialog<int>(
      context: context,
      builder: (_) => _NumberEntryDialog(
        title: title,
        unit: unit,
        min: min,
        max: max,
        current: current,
      ),
    );
    if (result != null) onSet(result);
  }
}

/// Number-entry dialog for the ruler sections. Owns its own controller so it
/// is disposed only after the dialog is fully gone.
class _NumberEntryDialog extends StatefulWidget {
  final String title;
  final String unit;
  final int min;
  final int max;
  final int current;

  const _NumberEntryDialog({
    required this.title,
    required this.unit,
    required this.min,
    required this.max,
    required this.current,
  });

  @override
  State<_NumberEntryDialog> createState() => _NumberEntryDialogState();
}

class _NumberEntryDialogState extends State<_NumberEntryDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: '${widget.current}');
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final parsed = int.tryParse(_controller.text.trim());
    if (parsed == null) {
      setState(() => _error = 'Enter a number');
      return;
    }
    if (parsed < widget.min || parsed > widget.max) {
      setState(() => _error = 'Must be ${widget.min}–${widget.max} ${widget.unit}');
      return;
    }
    Navigator.pop(context, parsed);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('${widget.title} (${widget.unit})',
          style: AppTextStyles.cardTitle),
      content: CustomTextField(
        hint: '${widget.min}–${widget.max}',
        controller: _controller,
        dark: true,
        keyboardType: TextInputType.number,
        errorText: _error,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style:
                  AppTextStyles.small.copyWith(color: AppColors.textSecondary)),
        ),
        TextButton(
          onPressed: _submit,
          child: Text('Set',
              style: AppTextStyles.small.copyWith(
                  color: AppColors.accentText, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
