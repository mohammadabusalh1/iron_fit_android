import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:iron_fit/backend/schema/structs/index.dart';
import 'package:iron_fit/backend/schema/exercises_record.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

// Import our component files
import 'package:iron_fit/dialogs/select_day_for_plan/components/day_selection_view.dart';
import 'package:iron_fit/dialogs/select_day_for_plan/components/exercise_selection_view.dart';
import 'package:iron_fit/dialogs/select_day_for_plan/components/title_input_view.dart';
import 'package:iron_fit/dialogs/select_day_for_plan/components/selected_exercises_dialog.dart';

// Import our utils file
import 'package:iron_fit/utils/training_day_utils.dart';

class SelectDayForPlan extends StatefulWidget {
  SelectDayForPlan({
    super.key,
    List<String>? existingDays,
    this.editingDay,
  }) : existingDays = existingDays ?? [];

  final List<String> existingDays;
  final TrainingDayStruct? editingDay;

  @override
  State<SelectDayForPlan> createState() => _SelectDayForPlanState();
}

class _SelectDayForPlanState extends State<SelectDayForPlan> {
  final _pageController = PageController();
  int _currentPage = 0;
  List<String> _selectedDays = [];
  String _dayTitle = '';
  List<ExerciseStruct> _selectedExercises = [];
  final _titleController = TextEditingController();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late String _selectedBodyPart;
  late String _selectedEquipment;
  bool _isEditMode = false;
  bool _isAppBarVisible = true;

  // Variables for lazy loading
  final _exerciseCache = <String, List<ExercisesRecord>>{};
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _exercisePage = 0;
  final int _pageSize = 20;
  final _scrollController = ScrollController();

  final List<String> _weekDays = [];

  @override
  void initState() {
    super.initState();
    _selectedBodyPart = 'all';
    _selectedEquipment = 'all';

    // Add scroll listener for lazy loading and app bar visibility
    _scrollController.addListener(() {
      _scrollListener();
      // Add scroll position detection
      if (_scrollController.position.pixels > 0) {
        if (_isAppBarVisible) {
          setState(() => _isAppBarVisible = false);
        }
      } else {
        if (!_isAppBarVisible) {
          setState(() => _isAppBarVisible = true);
        }
      }
    });

    // Prefetch first page of exercises
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchCommonData();
      _initializeEditMode();
    });
  }

  void _initializeEditMode() {
    if (widget.editingDay != null) {
      setState(() {
        _isEditMode = true;
        // Initialize with the current day, but allow selecting more days in edit mode
        _selectedDays = [widget.editingDay!.day];
        _dayTitle = widget.editingDay!.title;
        _titleController.text = widget.editingDay!.title;
        _selectedExercises = List.from(widget.editingDay!.exercises);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_weekDays.isEmpty) {
      _initializeWeekDays();
    }
  }

  void _initializeWeekDays() {
    _weekDays.addAll([
      FFLocalizations.of(context).getText('duazsqnb'), // Monday
      FFLocalizations.of(context).getText('o89upwj1'), // Tuesday
      FFLocalizations.of(context).getText('6g27x925'), // Wednesday
      FFLocalizations.of(context).getText('yq96r5o7'), // Thursday
      FFLocalizations.of(context).getText('ap0v00n3'), // Friday
      FFLocalizations.of(context).getText('0w2atzto'), // Saturday
      FFLocalizations.of(context).getText('56cey9g0'), // Sunday
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (_isEditMode) {
        if (_selectedDays.length == 1) {
          // Return a single updated day (backwards compatibility)
          final trainingDay = TrainingDayStruct(
            day: _selectedDays.first,
            title: _dayTitle,
            exercises: _selectedExercises,
            source: 0, // This will be calculated in the create plan widget
          );
          Navigator.pop(context, trainingDay);
        } else {
          // In edit mode with multiple days selected, return only the days that were selected
          final originalDay = widget.editingDay!.day;
          final List<Object> result = [];

          // If the original day is still selected, update it instead of creating new
          if (_selectedDays.contains(originalDay)) {
            final updatedOriginalDay = TrainingDayStruct(
              day: originalDay,
              title: _dayTitle,
              exercises: _selectedExercises,
              source: 0, // This will be calculated in the create plan widget
            );
            result.add(updatedOriginalDay);

            // Add all other selected days as new days
            for (String day in _selectedDays) {
              if (day != originalDay) {
                result.add(TrainingDayStruct(
                  day: day,
                  title: _dayTitle,
                  exercises: _selectedExercises,
                  source:
                      0, // This will be calculated in the create plan widget
                ));
              }
            }
          } else {
            // The original day was unselected, so we need to indicate it should be removed
            // and add all the newly selected days

            // Add a special marker to indicate the original day should be removed
            result.add({'action': 'remove', 'day': originalDay});

            // Add all selected days as new days
            for (String day in _selectedDays) {
              result.add(TrainingDayStruct(
                day: day,
                title: _dayTitle,
                exercises: _selectedExercises,
                source: 0, // This will be calculated in the create plan widget
              ));
            }
          }

          Navigator.pop(context, result);
        }
      } else {
        // In create mode, create and return multiple training days if selected
        final List<TrainingDayStruct> trainingDays = [];

        for (String day in _selectedDays) {
          trainingDays.add(TrainingDayStruct(
            day: day,
            title: _dayTitle,
            exercises: _selectedExercises,
            source: 0, // This will be calculated in the create plan widget
          ));
        }

        Navigator.pop(context, trainingDays);
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreExercises();
    }
  }

  void _loadMoreExercises() {
    setState(() {
      _isLoadingMore = true;
    });

    // Load next page of exercises
    TrainingDayUtils.fetchExercises(
      context: context,
      selectedBodyPart: _selectedBodyPart,
      selectedEquipment: _selectedEquipment,
      searchQuery: _searchQuery,
      page: ++_exercisePage,
      pageSize: _pageSize,
      existingExercises: _exerciseCache[
              '${_selectedBodyPart}_${_selectedEquipment}_${_searchQuery}'] ??
          [],
    ).then((newExercises) {
      setState(() {
        // Update cache and UI
        final cacheKey =
            '${_selectedBodyPart}_${_selectedEquipment}_${_searchQuery}';
        final existingExercises = _exerciseCache[cacheKey] ?? [];

        if (newExercises.isNotEmpty) {
          _exerciseCache[cacheKey] = [...existingExercises, ...newExercises];
        } else {
          _hasMoreData = false;
        }

        _isLoadingMore = false;
      });
    });
  }

  void _prefetchCommonData() async {
    final prefetchedCache = await TrainingDayUtils.prefetchCommonData(context);
    setState(() {
      _exerciseCache.addAll(prefetchedCache);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
            FlutterFlowTheme.of(context).primaryBackground,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: _currentPage == 0 ? false : true,
          toolbarHeight: _currentPage == 0 ? 0 : null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: _currentPage == 0
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                  onPressed: _previousPage,
                ),
          title: _currentPage == 0
              ? null
              : Text(
                  _isEditMode
                      ? FFLocalizations.of(context).getText('edit_training_day')
                      : FFLocalizations.of(context).getText('add_training_day'),
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  // Day Selection View
                  DaySelectionView(
                    weekDays: _weekDays,
                    selectedDays: _selectedDays,
                    existingDays: widget.existingDays,
                    editingDay: widget.editingDay,
                    onDaysSelected: (days) {
                      setState(() => _selectedDays = days);
                    },
                  ),

                  // Exercise Selection View
                  ExerciseSelectionView(
                    selectedExercises: _selectedExercises,
                    selectedBodyPart: _selectedBodyPart,
                    selectedEquipment: _selectedEquipment,
                    searchQuery: _searchQuery,
                    searchController: _searchController,
                    scrollController: _scrollController,
                    isAppBarVisible: _isAppBarVisible,
                    onBodyPartSelected: (bodyPart) {
                      setState(() {
                        _selectedBodyPart = bodyPart;
                        _exercisePage = 0;
                        _hasMoreData = true;
                        _searchQuery = '';
                      });
                    },
                    onEquipmentSelected: (equipment) {
                      setState(() {
                        _selectedEquipment = equipment;
                        _exercisePage = 0;
                        _hasMoreData = true;
                        _searchQuery = '';
                      });
                    },
                    onSearchChanged: (query) {
                      setState(() {
                        _selectedEquipment =
                            FFLocalizations.of(context).getText('all');
                        _selectedBodyPart =
                            FFLocalizations.of(context).getText('all');
                        _searchQuery = query;
                        _exercisePage = 0;
                        _hasMoreData = true;
                        _scrollController.jumpTo(0.0);
                      });
                    },
                    onExercisesChanged: (exercises) {
                      setState(() {
                        _selectedExercises = exercises;
                      });
                    },
                    onConfigurePressed: _showSelectedExercisesDialog,
                    exercisesStream: queryExercisesRecord(),
                    isLoadingMore: _isLoadingMore,
                  ),

                  // Title Input View
                  TitleInputView(
                    titleController: _titleController,
                    dayTitle: _dayTitle,
                    onTitleChanged: (value) =>
                        setState(() => _dayTitle = value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        width: index == _currentPage ? 16 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).alternate,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Show configure button on exercise selection page
                  if (_currentPage == 1 && _selectedExercises.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.8),
                              FlutterFlowTheme.of(context).primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            _showSelectedExercisesDialog();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.fitness_center,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${_selectedExercises.length} ${FFLocalizations.of(context).getText('exercises_selected')}',
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  FFLocalizations.of(context)
                                      .getText('configure'),
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: 14,
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  FFButtonWidget(
                    onPressed: _canProceed() ? _nextPage : null,
                    text: _currentPage == 2
                        ? _isEditMode
                            ? FFLocalizations.of(context).getText('update')
                            : FFLocalizations.of(context).getText('finish')
                        : FFLocalizations.of(context).getText('next'),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: AppStyles.textCairo(
                        context,
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      elevation: 2,
                      borderRadius: BorderRadius.circular(12),
                      disabledColor: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_isEditMode) {
      switch (_currentPage) {
        case 0:
          return true; // Already have a selected day
        case 1:
          return _selectedExercises.isNotEmpty;
        case 2:
          return _dayTitle.isNotEmpty;
        default:
          return false;
      }
    } else {
      switch (_currentPage) {
        case 0:
          return _selectedDays.isNotEmpty;
        case 1:
          return _selectedExercises.isNotEmpty;
        case 2:
          return _dayTitle.isNotEmpty;
        default:
          return false;
      }
    }
  }

  void _showSelectedExercisesDialog() {
    showDialog(
      context: context,
      barrierColor: FlutterFlowTheme.of(context).black.withValues(alpha: 0.8),
      builder: (context) => SelectedExercisesDialog(
        selectedExercises: _selectedExercises,
        onExercisesChanged: (exercises) {
          setState(() {
            _selectedExercises = exercises;
          });
        },
      ),
    );
  }

  Stream<List<ExercisesRecord>> queryExercisesRecord() {
    final cacheKey =
        '${_selectedBodyPart}_${_selectedEquipment}_${_searchQuery}';

    // Reset pagination when filters change
    _exercisePage = 0;
    _hasMoreData = true;

    // Check if we have cached data for these filters
    if (_exerciseCache.containsKey(cacheKey)) {
      return Stream.value(_exerciseCache[cacheKey]!).asBroadcastStream();
    }

    // Fetch initial page
    return Stream.fromFuture(TrainingDayUtils.fetchExercises(
      context: context,
      selectedBodyPart: _selectedBodyPart,
      selectedEquipment: _selectedEquipment,
      searchQuery: _searchQuery,
      page: 0,
      pageSize: _pageSize,
      existingExercises: null,
    )).map((exercises) {
      _exerciseCache[cacheKey] = exercises;
      return exercises;
    }).asBroadcastStream();
  }
}
