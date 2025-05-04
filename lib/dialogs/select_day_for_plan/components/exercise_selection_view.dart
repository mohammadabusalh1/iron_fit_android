import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/backend/schema/exercises_record.dart';
import 'package:iron_fit/backend/schema/structs/index.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iron_fit/dialogs/select_sets/select_sets_widget.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

class ExerciseSelectionView extends StatefulWidget {
  final List<ExerciseStruct> selectedExercises;
  final String selectedBodyPart;
  final String selectedEquipment;
  final String searchQuery;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final bool isAppBarVisible;
  final Function(String) onBodyPartSelected;
  final Function(String) onEquipmentSelected;
  final Function(String) onSearchChanged;
  final Function(List<ExerciseStruct>) onExercisesChanged;
  final Function() onConfigurePressed;
  final Stream<List<ExercisesRecord>> exercisesStream;
  final bool isLoadingMore;

  const ExerciseSelectionView({
    super.key,
    required this.selectedExercises,
    required this.selectedBodyPart,
    required this.selectedEquipment,
    required this.searchQuery,
    required this.searchController,
    required this.scrollController,
    required this.isAppBarVisible,
    required this.onBodyPartSelected,
    required this.onEquipmentSelected,
    required this.onSearchChanged,
    required this.onExercisesChanged,
    required this.onConfigurePressed,
    required this.exercisesStream,
    required this.isLoadingMore,
  });

  @override
  State<ExerciseSelectionView> createState() => _ExerciseSelectionViewState();
}

class _ExerciseSelectionViewState extends State<ExerciseSelectionView> {
  @override
  void initState() {
    super.initState();
    // Show bottom sheet when page appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _buildShowBottomSheet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          automaticallyImplyLeading: false,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          title: InkWell(
            onTap: () => _buildShowBottomSheet(),
            child: Padding(
              padding: ResponsiveUtils.padding(context, horizontal: 12.0),
              child: Text(
                FFLocalizations.of(context).getText('filter'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: ResponsiveUtils.fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _buildShowBottomSheet();
              },
              icon: Icon(
                Icons.filter_list_rounded,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
            ),
          ],
        ),
        // Exercise list
        SliverPadding(
          padding: ResponsiveUtils.padding(context, horizontal: 24.0, vertical: 8.0),
          sliver: SliverToBoxAdapter(
            child: StreamBuilder<List<ExercisesRecord>>(
              stream: widget.exercisesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: ResponsiveUtils.width(context, 40),
                          height: ResponsiveUtils.height(context, 40),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.height(context, 16)),
                        Text(
                          FFLocalizations.of(context).getText('loading'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 16),
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                List<ExercisesRecord> exercises = snapshot.data!;

                if (exercises.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fitness_center_rounded,
                            size: ResponsiveUtils.iconSize(context, 64),
                            color: FlutterFlowTheme.of(context)
                                .secondaryText
                                .withValues(alpha: 0.5),
                          ),
                          SizedBox(height: ResponsiveUtils.height(context, 16)),
                          Text(
                            FFLocalizations.of(context)
                                .getText('no_exercises_found'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 16),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ...exercises.map((exercise) {
                      final isSelected = widget.selectedExercises.any(
                        (e) => e.ref == exercise.reference,
                      );

                      return _buildExerciseItem(context, exercise, isSelected);
                    }).toList(),
                    // Add loading indicator at the bottom for infinite scrolling
                    if (widget.isLoadingMore)
                      Padding(
                        padding: ResponsiveUtils.padding(context, vertical: 16.0),
                        child: Center(
                          child: SizedBox(
                            width: ResponsiveUtils.width(context, 24),
                            height: ResponsiveUtils.height(context, 24),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _buildShowBottomSheet() {
    var keyboardHeight = 0.0;
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.6 + keyboardHeight,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).info.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag indicator
              Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveUtils.height(context, 12), 
                  bottom: ResponsiveUtils.height(context, 8)
                ),
                child: Container(
                  width: ResponsiveUtils.width(context, 40),
                  height: ResponsiveUtils.height(context, 4),
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).alternate.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding:
                    ResponsiveUtils.padding(context, horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          color: FlutterFlowTheme.of(context).black,
                          size: ResponsiveUtils.iconSize(context, 24),
                        ),
                        SizedBox(width: ResponsiveUtils.width(context, 12)),
                        Text(
                          FFLocalizations.of(context).getText('filter_exercises'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: ResponsiveUtils.fontSize(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).black,
                        size: ResponsiveUtils.iconSize(context, 24),
                      ),
                    ),
                  ],
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modern animated search bar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          onTap: () {
                            widget.searchController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: widget.searchController.text.length),
                            );
                            setState(() {
                              keyboardHeight = 130.0;
                            });
                          },
                          onFieldSubmitted: (s) {
                            widget.onSearchChanged(s);
                            setState(() {
                              keyboardHeight = 0.0;
                            });
                            context.pop();
                          },
                          onChanged: (s) {
                            if (s.isEmpty) {
                              widget.onSearchChanged(s);
                            }
                          },
                          textInputAction: TextInputAction.search,
                          controller: widget.searchController,
                          decoration: InputDecoration(
                            hintText:
                                FFLocalizations.of(context).getText('g39ttzvd'),
                            hintStyle: AppStyles.textCairo(
                              context,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: FlutterFlowTheme.of(context).info,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            suffixIcon: widget.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      widget.searchController.clear();
                                      widget.onSearchChanged('');
                                      HapticFeedback.lightImpact();
                                    },
                                  )
                                : null,
                          ),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Body Part Section
                      Text(
                        FFLocalizations.of(context).getText('body_part'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            FFLocalizations.of(context).getText('all'),
                            FFLocalizations.of(context).getText('chest'),
                            FFLocalizations.of(context).getText('back'),
                            FFLocalizations.of(context).getText('legs'),
                            FFLocalizations.of(context).getText('neck'),
                            FFLocalizations.of(context).getText('traps'),
                            FFLocalizations.of(context).getText('shoulders'),
                            FFLocalizations.of(context).getText('biceps'),
                            FFLocalizations.of(context).getText('triceps'),
                            FFLocalizations.of(context).getText('LowerArms'),
                            FFLocalizations.of(context).getText('core'),
                            FFLocalizations.of(context).getText('cardio'),
                          ].map((bodyPart) {
                            final isSelected =
                                widget.selectedBodyPart == bodyPart;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: isSelected ? 1.05 : 1.0,
                                child: FilterChip(
                                  label: Text(
                                    bodyPart,
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? FlutterFlowTheme.of(context).info
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    widget.onBodyPartSelected(selected
                                        ? bodyPart
                                        : FFLocalizations.of(context)
                                            .getText('all'));
                                    widget.onEquipmentSelected(
                                        FFLocalizations.of(context)
                                            .getText('all'));
                                    HapticFeedback.selectionClick();
                                    setModalState(() {
                                      widget.scrollController.jumpTo(0.0);
                                    }); // Rebuild the modal
                                  },
                                  selectedColor:
                                      FlutterFlowTheme.of(context).primary,
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  elevation: 0,
                                  pressElevation: 0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Equipment Section
                      Text(
                        FFLocalizations.of(context).getText('equipment'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            FFLocalizations.of(context).getText('all'),
                            FFLocalizations.of(context).getText('barbell'),
                            FFLocalizations.of(context).getText('dumbbell'),
                            FFLocalizations.of(context).getText('machine'),
                            FFLocalizations.of(context).getText('cable'),
                            FFLocalizations.of(context).getText('other'),
                          ].map((equipment) {
                            final isSelected =
                                widget.selectedEquipment == equipment;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: isSelected ? 1.05 : 1.0,
                                child: FilterChip(
                                  label: Text(
                                    equipment,
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? FlutterFlowTheme.of(context).info
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    widget.onEquipmentSelected(selected
                                        ? equipment
                                        : FFLocalizations.of(context)
                                            .getText('all'));
                                    HapticFeedback.selectionClick();
                                    setModalState(() {
                                      widget.scrollController.jumpTo(0.0);
                                    }); // Rebuild the modal
                                  },
                                  selectedColor:
                                      FlutterFlowTheme.of(context).primary,
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  elevation: 0,
                                  pressElevation: 0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseItem(
      BuildContext context, ExercisesRecord exercise, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              HapticFeedback.selectionClick();

              if (isSelected) {
                final updatedExercises = widget.selectedExercises
                    .where((e) => e.ref != exercise.reference)
                    .toList();

                widget.onExercisesChanged(updatedExercises);
              } else {
                final setsData = await _showSelectSetsDialog(context);

                if (setsData == null) {
                  return;
                }

                final updatedExercises = [...widget.selectedExercises];
                updatedExercises.add(
                  ExerciseStruct(
                    ref: exercise.reference,
                    sets: setsData.sets,
                    reps: setsData.reps,
                    time: setsData.time,
                    timeType: setsData.timeType,
                  ),
                );
                widget.onExercisesChanged(updatedExercises);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1)
                    : FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).alternate,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (exercise.gifUrl.isNotEmpty)
                    Hero(
                      tag: 'exercise_${exercise.reference.id}',
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: exercise.gifUrl,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              color: FlutterFlowTheme.of(context)
                                  .alternate
                                  .withValues(alpha: 0.3),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              return Container(
                                color: FlutterFlowTheme.of(context)
                                    .alternate
                                    .withValues(alpha: 0.3),
                                child: Icon(
                                  Icons.fitness_center,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 32,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    exercise.name,
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 80,
                              child: Text(
                                textAlign: TextAlign.center,
                                exercise.bodyPart,
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ),
                          if (exercise.equipment.isNotEmpty)
                            Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .info
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 80,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    exercise.equipment,
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                                  ),
                                )),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: isSelected
                            ? Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                            : Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<SetStruct?> _showSelectSetsDialog(BuildContext context) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: const SelectSetsWidget(),
          ),
        );
      },
    );
  }
}
