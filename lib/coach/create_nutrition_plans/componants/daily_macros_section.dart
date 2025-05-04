import 'package:flutter/material.dart';
import 'package:iron_fit/coach/create_nutrition_plans/componants/form_field_components.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class DailyMacrosSection extends StatelessWidget {
  final TextEditingController proteinController;
  final FocusNode proteinFocusNode;
  final TextEditingController carbsController;
  final FocusNode carbsFocusNode;
  final TextEditingController fatsController;
  final FocusNode fatsFocusNode;

  const DailyMacrosSection({
    super.key,
    required this.proteinController,
    required this.proteinFocusNode,
    required this.carbsController,
    required this.carbsFocusNode,
    required this.fatsController,
    required this.fatsFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            icon: Icons.fitness_center,
            title: FFLocalizations.of(context)
                .getText('v6nv5qtk' /* Daily Macros Target */),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MacroInputField(
                controller: proteinController,
                focusNode: proteinFocusNode,
                labelText: FFLocalizations.of(context)
                    .getText('ciujpvfr' /* Protein (g) */),
                icon: Icons.egg_outlined,
                color: const Color(0xFFE57373),
              ),
              MacroInputField(
                controller: carbsController,
                focusNode: carbsFocusNode,
                labelText: FFLocalizations.of(context)
                    .getText('gxgmhgxs' /* Carbs (g) */),
                icon: Icons.grain_outlined,
                color: const Color(0xFF81C784),
              ),
              MacroInputField(
                controller: fatsController,
                focusNode: fatsFocusNode,
                labelText: FFLocalizations.of(context)
                    .getText('atjwz1s7' /* Fats (g) */),
                icon: Icons.water_drop_outlined,
                color: const Color(0xFF64B5F6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
