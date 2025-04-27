import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';

class TitleInputView extends StatelessWidget {
  final TextEditingController titleController;
  final String dayTitle;
  final Function(String) onTitleChanged;

  const TitleInputView({
    super.key,
    required this.titleController,
    required this.dayTitle,
    required this.onTitleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 350;
    final horizontalPadding = screenSize.width * 0.06; // 6% of screen width
    final topPadding = screenSize.height * 0.03; // 3% of screen height

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                topPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated header section
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText('name_training'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Text(
                          FFLocalizations.of(context)
                              .getText('training_name_subtitle'),
                          style: AppStyles.textCairo(
                            context,
                            fontSize: isSmallScreen ? 14 : 16,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  // Modern animated input field
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 600, // Maximum width on larger screens
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
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
                      child: TextFormField(
                        onTap: () {
                          titleController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: titleController.text.length),
                          );
                        },
                        controller: titleController,
                        onChanged: onTitleChanged,
                        style: AppStyles.textCairo(
                          context,
                          fontSize: isSmallScreen ? 15 : 16,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                        decoration: InputDecoration(
                          labelText: FFLocalizations.of(context)
                              .getText('training_title'),
                          hintText: FFLocalizations.of(context)
                              .getText('training_title_hint'),
                          hintStyle: AppStyles.textCairo(
                            context,
                            fontSize: isSmallScreen ? 14 : 15,
                            color: FlutterFlowTheme.of(context)
                                .secondaryText
                                .withValues(alpha: 0.5),
                          ),
                          labelStyle: AppStyles.textCairo(
                            context,
                            fontSize: isSmallScreen ? 14 : 15,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.fitness_center_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          suffixIcon: dayTitle.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.check_circle_rounded,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                  onPressed: null,
                                )
                              : null,
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 20,
                            vertical: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Character count and suggestions
                  if (dayTitle.isNotEmpty)
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: constraints.maxHeight * 0.02),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: isSmallScreen ? 4 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${dayTitle.length} ${FFLocalizations.of(context).getText('characters')}',
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: isSmallScreen ? 11 : 12,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                                if (dayTitle.length < 3)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: isSmallScreen ? 4 : 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .error
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      FFLocalizations.of(context)
                                          .getText('title_too_short'),
                                      style: AppStyles.textCairo(
                                        context,
                                        fontSize: isSmallScreen ? 11 : 12,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  // Recommendation section for larger screens
                  if (screenSize.height > 600)
                    Padding(
                      padding:
                          EdgeInsets.only(top: constraints.maxHeight * 0.06),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 700),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.05),
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      FFLocalizations.of(context)
                                          .getText('tips'),
                                      style: AppStyles.textCairo(
                                        context,
                                        fontSize: isSmallScreen ? 16 : 18,
                                        fontWeight: FontWeight.w600,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                FFLocalizations.of(context)
                                    .getText('title_tips'),
                                style: AppStyles.textCairo(
                                  context,
                                  fontSize: isSmallScreen ? 13 : 14,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
