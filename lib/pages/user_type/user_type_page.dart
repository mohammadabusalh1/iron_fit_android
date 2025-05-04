import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:animate_do/animate_do.dart';

class UserTypePage extends StatefulWidget {
  const UserTypePage({super.key});

  @override
  State<UserTypePage> createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ValueNotifier<int?> _hoveredCardNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<int?> _activeCardNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<bool> _isAnimatingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoveredCardNotifier.dispose();
    _activeCardNotifier.dispose();
    _isAnimatingNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleUserTypeSelection(String userType, int index) async {
    if (_isAnimatingNotifier.value) return;

    _isAnimatingNotifier.value = true;
    _activeCardNotifier.value = index;

    // Add a small delay to show the effect before navigating
    await Future.delayed(const Duration(milliseconds: 600));

    // Animate out
    await _animationController.reverse();

    // Update state and navigate
    FFAppState().userType = userType;
    if (mounted) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                FlutterFlowTheme.of(context).primary.withOpacity(0.05),
                FlutterFlowTheme.of(context).secondaryBackground,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.width(context, 24.0), 
                vertical: ResponsiveUtils.height(context, 16.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    FFLocalizations.of(context).getText('selectUserTypeTitle'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 26),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 8)),
                FadeInDown(
                  duration: const Duration(milliseconds: 900),
                  child: Text(
                    textAlign: TextAlign.center,
                    FFLocalizations.of(context)
                        .getText('selectUserTypeDescription'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 14),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 32)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: UserTypeCard(
                          index: 0,
                          title: FFLocalizations.of(context).getText('coach'),
                          subtitle: FFLocalizations.of(context)
                              .getText('coachDescription'),
                          icon: Icons.sports_kabaddi,
                          hoveredCardNotifier: _hoveredCardNotifier,
                          activeCardNotifier: _activeCardNotifier,
                          onTap: () => _handleUserTypeSelection('coach', 0),
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.height(context, 24)),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1100),
                        child: UserTypeCard(
                          index: 1,
                          title: FFLocalizations.of(context).getText('trainee'),
                          subtitle: FFLocalizations.of(context)
                              .getText('traineeDescription'),
                          icon: Icons.directions_run,
                          hoveredCardNotifier: _hoveredCardNotifier,
                          activeCardNotifier: _activeCardNotifier,
                          onTap: () => _handleUserTypeSelection('trainee', 1),
                        ),
                      ),
                    ],
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

class UserTypeCard extends StatefulWidget {
  const UserTypeCard({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.hoveredCardNotifier,
    required this.activeCardNotifier,
  });

  final int index;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final ValueNotifier<int?> hoveredCardNotifier;
  final ValueNotifier<int?> activeCardNotifier;

  @override
  State<UserTypeCard> createState() => _UserTypeCardState();
}

class _UserTypeCardState extends State<UserTypeCard> {
  final WidgetStatesController _statesController = WidgetStatesController();

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.hoveredCardNotifier.value = widget.index,
      onExit: (_) => widget.hoveredCardNotifier.value = null,
      child: ValueListenableBuilder<int?>(
        valueListenable: widget.hoveredCardNotifier,
        builder: (context, hoveredIndex, _) {
          final bool isHovered = hoveredIndex == widget.index;

          return ValueListenableBuilder<int?>(
            valueListenable: widget.activeCardNotifier,
            builder: (context, activeIndex, _) {
              final bool isActive = activeIndex == widget.index;

              return _buildCard(
                context: context,
                isHovered: isHovered,
                isActive: isActive,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required bool isHovered,
    required bool isActive,
  }) {
    final scaleMatrix = Matrix4.identity()
      ..scale(isActive ? 0.98 : (isHovered ? 1.03 : 1.0));
    final isPressing = _statesController.value.contains(WidgetState.pressed);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      transform: scaleMatrix,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Visual feedback then execute onTap
            HapticFeedback.mediumImpact();
            widget.onTap();
          },
          borderRadius: BorderRadius.circular(20),
          splashColor:
              FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
          highlightColor:
              FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
          statesController: _statesController,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveUtils.width(context, 24)),
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive
                    ? FlutterFlowTheme.of(context).primary
                    : (isHovered || isPressing
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).alternate),
                width: (isActive || isHovered || isPressing) ? 2.0 : 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isPressing
                      ? FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.15)
                      : (isActive || isHovered
                          ? FlutterFlowTheme.of(context).primaryBackground
                          : FlutterFlowTheme.of(context).secondaryBackground),
                  isPressing
                      ? FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.1)
                      : (isActive || isHovered
                          ? FlutterFlowTheme.of(context)
                              .primaryBackground
                              .withValues(alpha: 0.9)
                          : FlutterFlowTheme.of(context).secondaryBackground),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? FlutterFlowTheme.of(context)
                          .primary
                          .withValues(alpha: 0.25)
                      : (isPressing
                          ? FlutterFlowTheme.of(context)
                              .primary
                              .withValues(alpha: 0.2)
                          : (isHovered
                              ? FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.15)
                              : FlutterFlowTheme.of(context)
                                  .secondaryText
                                  .withValues(alpha: 0.08))),
                  spreadRadius:
                      isActive || isPressing ? 2 : (isHovered ? 4 : 1),
                  blurRadius:
                      isActive || isPressing ? 15 : (isHovered ? 20 : 10),
                  offset: isActive || isPressing
                      ? const Offset(0, 2)
                      : (isHovered ? const Offset(0, 6) : const Offset(0, 4)),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween<double>(
                    begin: 0,
                    end: isActive || isPressing ? 0.2 : (isHovered ? 0.1 : 0),
                  ),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.all(isActive || isPressing
                            ? ResponsiveUtils.width(context, 22)
                            : (isHovered ? ResponsiveUtils.width(context, 20) : ResponsiveUtils.width(context, 16))),
                        decoration: BoxDecoration(
                          color: isActive
                              ? FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.3)
                              : (isPressing
                                  ? FlutterFlowTheme.of(context)
                                      .primary
                                      .withValues(alpha: 0.25)
                                  : (isHovered
                                      ? FlutterFlowTheme.of(context)
                                          .primary
                                          .withValues(alpha: 0.2)
                                      : FlutterFlowTheme.of(context)
                                          .primary
                                          .withValues(alpha: 0.1))),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          widget.icon,
                          color: isActive || isPressing
                              ? FlutterFlowTheme.of(context).primary
                              : (isHovered
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).primary),
                          size: isActive || isPressing
                              ? ResponsiveUtils.iconSize(context, 42)
                              : (isHovered ? ResponsiveUtils.iconSize(context, 40) : ResponsiveUtils.iconSize(context, 36)),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: ResponsiveUtils.height(context, 12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 200),
                      tween: Tween<double>(
                        begin: 0,
                        end: isActive || isPressing ? 1.2 : (isHovered ? 1 : 0),
                      ),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(value * 8, 0),
                          child: Text(
                            widget.title,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: ResponsiveUtils.fontSize(context, 20 + (value * 2)),
                              fontWeight: FontWeight.w600,
                              color: isActive || isPressing || isHovered
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 4)),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 14),
                        color: isActive || isPressing
                            ? FlutterFlowTheme.of(context).primary
                            : (isHovered
                                ? FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.8)
                                : FlutterFlowTheme.of(context).secondaryText),
                      ),
                      child: Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
