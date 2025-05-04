import 'package:flutter/material.dart';
import 'package:iron_fit/coach/create_nutrition_plans/componants/form_field_components.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class PlanDetailsSection extends StatelessWidget {
  final TextEditingController nameController;
  final FocusNode nameFocusNode;
  final TextEditingController numOfWeeksController;
  final FocusNode numOfWeeksFocusNode;
  final TextEditingController caloriesController;
  final FocusNode caloriesFocusNode;
  final Map<String, GlobalKey> fieldKeys;

  const PlanDetailsSection({
    super.key,
    required this.nameController,
    required this.nameFocusNode,
    required this.numOfWeeksController,
    required this.numOfWeeksFocusNode,
    required this.caloriesController,
    required this.caloriesFocusNode,
    required this.fieldKeys,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.description_outlined,
            title: FFLocalizations.of(context)
                .getText('jjfz2qkx' /* Create Nutrition Plan */),
          ),
          SizedBox(height: ResponsiveUtils.height(context, 24)),
          StandardTextFormField(
            controller: nameController,
            focusNode: nameFocusNode,
            labelText:
                FFLocalizations.of(context).getText('p7xtjsx8' /* Plan Name */),
            hintText: FFLocalizations.of(context)
                .getText('ch0ra7hl' /* e.g. Weight Loss Nutrition Plan */),
            prefixIcon: Icons.title_outlined,
            fieldKey: fieldKeys['name'],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterPlanName');
              }
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          StandardTextFormField(
            controller: numOfWeeksController,
            focusNode: numOfWeeksFocusNode,
            labelText: FFLocalizations.of(context)
                .getText('ngyu3mdr' /* Duration (weeks) */),
            hintText: FFLocalizations.of(context)
                .getText('7le0xaer' /* Enter number of weeks */),
            prefixIcon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
            fieldKey: fieldKeys['numOfWeeks'],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterNumberOfWeeks');
              }
              if (int.tryParse(value) == null) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterAValidNumber');
              }
              if (int.parse(value) < 1) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterAValidNumber');
              }
              if (int.parse(value) > 100) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterAValidNumber');
              }
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.height(context, 16)),
          StandardTextFormField(
            keyboardType: TextInputType.number,
            controller: caloriesController,
            focusNode: caloriesFocusNode,
            labelText:
                FFLocalizations.of(context).getText('calories' /* Calories */),
            hintText: FFLocalizations.of(context)
                .getText('caloriesHint' /* Enter total calories */),
            prefixIcon: Icons.local_fire_department_outlined,
            fieldKey: fieldKeys['calories'],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterCalories');
              }
              if (int.tryParse(value) == null) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterAValidNumber');
              }
              if (int.parse(value) < 1) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterAValidNumber');
              }
              if (int.parse(value) > 10000) {
                return FFLocalizations.of(context)
                    .getText('pleaseEnterAValidNumber');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
