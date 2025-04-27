import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

class RestTimeStep extends StatefulWidget {
  const RestTimeStep({
    super.key,
    required this.onRestTimeSelected,
    this.initialRestTime,
  });

  final Function(int) onRestTimeSelected;
  final int? initialRestTime;

  @override
  State<RestTimeStep> createState() => _RestTimeStepState();
}

class _RestTimeStepState extends State<RestTimeStep> {
  // Rest time in seconds
  late int _selectedRestTime;
  late final FFLocalizations _localizations = FFLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    _selectedRestTime = widget.initialRestTime ?? 90; // Default to 1:30m (90s)
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizations.getText('rest_time_title'),
            style: AppStyles.textCairo(
              context,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _localizations.getText('rest_time_subtitle'),
            style: AppStyles.textCairo(context),
          ),
          const SizedBox(height: 24),
          _buildRestTimeOptions(),
        ],
      ),
    );
  }

  Widget _buildRestTimeOptions() {
    // Define rest time options (in seconds)
    final List<Map<String, dynamic>> _restTimeOptions = [
      {
        'value': 30,
        'label': '30s',
        'description': FFLocalizations.of(context).getText('short_rest')
      },
      {
        'value': 60,
        'label': '1m',
        'description': FFLocalizations.of(context).getText('standard_rest')
      },
      {
        'value': 90,
        'label': '1:30m',
        'description': FFLocalizations.of(context).getText('recommended'),
        'isRecommended': true
      },
      {
        'value': 120,
        'label': '2m',
        'description': FFLocalizations.of(context).getText('long_rest')
      },
    ];
    return Column(
      children: _restTimeOptions
          .map((option) => _buildRestTimeOption(option))
          .toList(),
    );
  }

  Widget _buildRestTimeOption(Map<String, dynamic> option) {
    final bool isSelected = _selectedRestTime == option['value'];
    final bool isRecommended = option['isRecommended'] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: FlutterFlowTheme.of(context).primaryText.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (_selectedRestTime != option['value']) {
                setState(() {
                  _selectedRestTime = option['value'];
                });
                widget.onRestTimeSelected(option['value']);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      border: Border.all(
                        color: isSelected
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context)
                                .secondaryText
                                .withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: FlutterFlowTheme.of(context).info,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              option['label'],
                              style: AppStyles.textCairo(
                                context,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            if (isRecommended)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .tertiary
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _localizations.getText('recommended'),
                                  style: AppStyles.textCairo(
                                    context,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option['description'],
                          style: AppStyles.textCairo(
                            context,
                            fontSize: 14,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.timer_outlined,
                    color: isSelected
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
