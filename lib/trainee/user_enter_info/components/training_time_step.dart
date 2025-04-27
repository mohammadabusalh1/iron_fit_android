import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

class TrainingTimeStep extends StatefulWidget {
  const TrainingTimeStep({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
  });

  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay? initialTime;

  @override
  State<TrainingTimeStep> createState() => _TrainingTimeStepState();
}

class _TrainingTimeStepState extends State<TrainingTimeStep> {
  TimeOfDay? _selectedTime;
  late final _localizations = FFLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizations.getText('training_time_title'),
            style: AppStyles.textCairo(
              context,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _localizations.getText('training_time_subtitle'),
            style: AppStyles.textCairo(context),
          ),
          const SizedBox(height: 24),
          _buildTimeSelector(),
          const SizedBox(height: 16),
          if (_selectedTime != null) _buildSelectedTimeCard(),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _showTimePicker,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _localizations.getText('select_training_time'),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _selectedTime == null
                            ? _localizations.getText('tap_to_select_time')
                            : _localizations.getText('change_training_time'),
                        style: AppStyles.textCairo(
                          context,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTimeCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _localizations.getText('selected_time'),
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(_selectedTime!),
            style: AppStyles.textCairo(
              context,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: FlutterFlowTheme.of(context).primary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: FlutterFlowTheme.of(context).primary,
              onPrimary: FlutterFlowTheme.of(context).info,
              surface: FlutterFlowTheme.of(context).secondaryBackground,
              onSurface: FlutterFlowTheme.of(context).primaryText,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? FlutterFlowTheme.of(context).primary
                      : Colors.transparent),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? FlutterFlowTheme.of(context).info
                      : FlutterFlowTheme.of(context).primaryText),
              hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).primaryBackground),
              hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? FlutterFlowTheme.of(context).info
                      : FlutterFlowTheme.of(context).primaryText),
              dialHandColor: FlutterFlowTheme.of(context).primary,
              dialBackgroundColor:
                  FlutterFlowTheme.of(context).primaryBackground,
              dialTextColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.selected)
                      ? FlutterFlowTheme.of(context).info
                      : FlutterFlowTheme.of(context).primaryText),
              entryModeIconColor: FlutterFlowTheme.of(context).primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
      widget.onTimeSelected(pickedTime);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hours = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minutes = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }
}
