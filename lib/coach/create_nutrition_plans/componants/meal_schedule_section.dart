import 'package:flutter/material.dart';
import 'package:iron_fit/coach/create_nutrition_plans/componants/form_field_components.dart';
import 'package:iron_fit/componants/Styles.dart';
import '/backend/schema/structs/index.dart';
import '/dialogs/create_meal/create_meal_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MealScheduleSection extends StatefulWidget {
  final NutPlanStruct? nutPlan;
  final Function(MealStruct) onMealAdded;
  final Function(MealStruct) onMealDeleted;

  const MealScheduleSection({
    super.key,
    required this.nutPlan,
    required this.onMealAdded,
    required this.onMealDeleted,
  });

  @override
  State<MealScheduleSection> createState() => _MealScheduleSectionState();
}

class _MealScheduleSectionState extends State<MealScheduleSection> {
  final _isExpanded = <String, bool>{};
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<MealStruct> _currentMeals;

  @override
  void initState() {
    super.initState();
    _currentMeals = widget.nutPlan?.meals.toList() ?? [];
    _initializeExpansionState();
  }

  @override
  void didUpdateWidget(MealScheduleSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newMeals = widget.nutPlan?.meals.toList() ?? [];
    if (!_areListsEqual(_currentMeals, newMeals)) {
      _currentMeals = newMeals;
    }
  }

  bool _areListsEqual(List<MealStruct> list1, List<MealStruct> list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].name != list2[i].name || list1[i].desc != list2[i].desc) {
        return false;
      }
    }

    return true;
  }

  void _initializeExpansionState() {
    if (widget.nutPlan != null && widget.nutPlan!.meals != null) {
      for (var meal in widget.nutPlan!.meals) {
        _isExpanded[meal.name] = false;
      }
    }
  }

  Future<void> _addMeal() async {
    final value = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: const CreateMealWidget(),
          ),
        );
      },
    );

    if (value == null) {
      return;
    }

    setState(() {
      if (!_isExpanded.containsKey(value.name)) {
        _isExpanded[value.name] = true;
      }

      _currentMeals = [..._currentMeals, value];

      _listKey.currentState?.insertItem(_currentMeals.length - 1);
    });

    widget.onMealAdded(value);
  }

  void _toggleMealExpansion(MealStruct meal) {
    setState(() {
      if (_isExpanded.containsKey(meal.name)) {
        _isExpanded[meal.name] = !_isExpanded[meal.name]!;
      } else {
        _isExpanded[meal.name] = true;
      }
    });
  }

  void _showDeleteConfirmationDialog(MealStruct meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  FFLocalizations.of(context).getText('confirmDelete'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FFLocalizations.of(context)
                    .getText('areYouSureYouWantToDeleteThisMeal'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lunch_dining_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        meal.name,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                FFLocalizations.of(context).getText('cancel'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                final index =
                    _currentMeals.indexWhere((m) => m.name == meal.name);
                if (index != -1) {
                  setState(() {
                    _isExpanded.remove(meal.name);

                    final removedMeal = _currentMeals.removeAt(index);

                    _listKey.currentState?.removeItem(
                      index,
                      (context, animation) =>
                          _buildRemovedItem(removedMeal, animation),
                      duration: const Duration(milliseconds: 300),
                    );
                  });

                  widget.onMealDeleted(meal);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: FlutterFlowTheme.of(context).info,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${meal.name} ${FFLocalizations.of(context).getText('hasBeenDeleted')}',
                            style: AppStyles.textCairo(
                              context,
                              color: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: FlutterFlowTheme.of(context).error,
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor:
                    FlutterFlowTheme.of(context).error.withValues(alpha: 0.1),
              ),
              child: Text(
                FFLocalizations.of(context).getText('delete'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 16,
                  color: FlutterFlowTheme.of(context).error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRemovedItem(MealStruct meal, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildMealItem(meal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            icon: Icons.restaurant_menu,
            title: FFLocalizations.of(context)
                .getText('9yr4jrvm' /* Meal Schedule */),
            trailing: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).primary,
              borderRadius: 12,
              borderWidth: 1,
              buttonSize: 40,
              fillColor: FlutterFlowTheme.of(context).primary,
              icon: Icon(
                Icons.add_rounded,
                color: FlutterFlowTheme.of(context).info,
                size: 24,
              ),
              onPressed: _addMeal,
            ),
          ),
          const SizedBox(height: 16),
          _buildMealsList(),
        ],
      ),
    );
  }

  Widget _buildMealsList() {
    final meals = _currentMeals;
    if (meals.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 48,
              color: FlutterFlowTheme.of(context).secondaryText.withAlpha(150),
            ),
            const SizedBox(height: 16),
            Text(
              FFLocalizations.of(context)
                  .getText('noMealsYet' /* No meals added yet */),
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              FFLocalizations.of(context)
                  .getText('tapPlusToAdd' /* Tap + to add a new meal */),
              style: AppStyles.textCairo(
                context,
                color: FlutterFlowTheme.of(context).secondaryText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      initialItemCount: meals.length,
      itemBuilder: (context, index, animation) {
        final meal = meals[index];
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMealItem(meal),
          ),
        );
      },
    );
  }

  Widget _buildMealItem(MealStruct meal) {
    final isExpanded = _isExpanded[meal.name] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _toggleMealExpansion(meal),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lunch_dining_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          meal.name,
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: FlutterFlowTheme.of(context).error,
                            size: 20,
                          ),
                          onPressed: () => _showDeleteConfirmationDialog(meal),
                          splashRadius: 24,
                        ),
                        AnimatedRotation(
                          duration: const Duration(milliseconds: 200),
                          turns: isExpanded ? 0.5 : 0,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(height: 0),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      meal.desc,
                      style: AppStyles.textCairo(
                        context,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
