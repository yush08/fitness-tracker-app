import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
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
              ),
              const SizedBox(height: 32),
              GradientButton(
                label: 'Next',
                color: AppColors.accent,
                onPressed: () async {
                  // Persist the name onto the freshly-created Firebase account.
                  // Non-blocking: navigation proceeds regardless of the result.
                  await AuthService.instance.updateDisplayName(_name.text);
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.main, (r) => false);
                  }
                },
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
            DropdownChip(value: unit, options: units, onSelected: onUnit),
          ],
        ),
        RulerPicker(
          min: min,
          max: max,
          initialValue: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
