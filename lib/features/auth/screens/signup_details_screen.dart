import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/dropdown_chip.dart';
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

  int _height = 160;
  int _weight = 70;
  int _targetWeight = 70;
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';
  String _targetUnit = 'kg';

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
          child: Column(
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
                units: const ['cm', 'ft'],
                onUnit: (u) => setState(() => _heightUnit = u),
                min: 120,
                max: 220,
                value: _height,
                onChanged: (v) => _height = v,
              ),
              const SizedBox(height: 20),
              _rulerSection(
                title: 'Weight',
                unit: _weightUnit,
                units: const ['kg', 'lb'],
                onUnit: (u) => setState(() => _weightUnit = u),
                min: 40,
                max: 150,
                value: _weight,
                onChanged: (v) => _weight = v,
              ),
              const SizedBox(height: 20),
              _rulerSection(
                title: 'Target Weight',
                unit: _targetUnit,
                units: const ['kg', 'lb'],
                onUnit: (u) => setState(() => _targetUnit = u),
                min: 40,
                max: 150,
                value: _targetWeight,
                onChanged: (v) => _targetWeight = v,
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.main, (r) => false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.chevron_right,
                            color: Colors.black, size: 22),
                      ],
                    ),
                  ),
                ),
              ),
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
