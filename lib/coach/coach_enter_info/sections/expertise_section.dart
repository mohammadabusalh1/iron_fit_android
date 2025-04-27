import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/widgets/build_text_filed.dart';
import '../coach_enter_info_model.dart';
import 'package:provider/provider.dart';
import '../coach_enter_info_widget.dart';

class ExpertiseSection extends StatefulWidget {
  final CoachEnterInfoModel model;
  final BuildContext context;
  final int currentSubStage;

  const ExpertiseSection({
    super.key,
    required this.model,
    required this.context,
    required this.currentSubStage,
  });

  @override
  State<ExpertiseSection> createState() => _ExpertiseSectionState();
}

class _ExpertiseSectionState extends State<ExpertiseSection>
    with AutomaticKeepAliveClientMixin {
  // Cache animations to prevent rebuilds
  late final Map<String, Widget> _animationCache = {};

  // Cached specialization cards
  // late final Map<String, Widget> _specializationCards = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _animationCache.clear();
    // _specializationCards.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentInput(),
        ),
      ],
    );
  }

  Widget _buildCurrentInput() {
    // Use the current sub-stage as a key for caching
    final cacheKey = 'substage_${widget.currentSubStage}';

    // Return cached widget if it exists and specialization hasn't changed
    if (_animationCache.containsKey(cacheKey)) {
      return _animationCache[cacheKey]!;
    }

    // Create new widget based on current sub-stage
    Widget result;
    switch (widget.currentSubStage) {
      case 0:
        result = _buildExperienceInput();
        break;
      case 1:
        result = _buildAboutMeInput();
        break;
      case 2:
        result = _buildSpecializationsInput();
        break;
      default:
        result = const SizedBox();
    }

    // Cache the widget
    _animationCache[cacheKey] = result;
    return result;
  }

  Widget _buildExperienceInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    FFLocalizations.of(context)
                        .getText('expertise_step' /* Expertise */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          buildTextField(
            context: context,
            controller: widget.model.yearsofExperienceTextController,
            focusNode: widget.model.yearsofExperienceFocusNode,
            labelText:
                FFLocalizations.of(context).getText('years_of_experience'),
            hintText: FFLocalizations.of(context)
                .getText('enter_years_of_experience'),
            validator: (val) => val == null || val.isEmpty
                ? FFLocalizations.of(context).getText('thisFieldIsRequired')
                : null,
            prefixIcon: Icons.work_outline,
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) =>
                Provider.of<CoachInfoState>(context, listen: false)
                    .onFieldSubmitted(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    FFLocalizations.of(context)
                        .getText('i1jyd81k' /* About Me */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          buildTextField(
            context: context,
            controller: widget.model.aboutMeTextController,
            focusNode: widget.model.aboutMeFocusNode,
            labelText: FFLocalizations.of(context).getText('about_me'),
            hintText: FFLocalizations.of(context).getText('enter_about_me'),
            validator: (val) => val == null || val.isEmpty
                ? FFLocalizations.of(context).getText('thisFieldIsRequired')
                : null,
            prefixIcon: Icons.person_outline,
            maxLines: 3,
            onFieldSubmitted: (_) =>
                Provider.of<CoachInfoState>(context, listen: false)
                    .onFieldSubmitted(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationsInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    FFLocalizations.of(context)
                        .getText('expertise_step' /* Expertise */),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Specializations Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildSpecializationCard(
                context,
                FFLocalizations.of(context)
                    .getText('z4uf52a6'), // Strength Training
                Icons.fitness_center,
              ),
              _buildSpecializationCard(
                context,
                FFLocalizations.of(context).getText('0daxpqom'), // Nutrition
                Icons.restaurant_menu,
              ),
              _buildSpecializationCard(
                context,
                FFLocalizations.of(context)
                    .getText('ifgkvihc'), // Physical Fitness
                Icons.directions_run,
              ),
              _buildSpecializationCard(
                context,
                FFLocalizations.of(context).getText('zojont2z'), // Yoga
                Icons.self_improvement,
              ),
              _buildSpecializationCard(
                context,
                FFLocalizations.of(context).getText('mfdtfkgi'), // Cardio
                Icons.favorite,
              ),
              _buildSpecializationCard(
                context,
                FFLocalizations.of(context)
                    .getText('6qgiotpz'), // Sports Training
                Icons.sports,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationCard(
      BuildContext context, String title, IconData icon) {
    // Create a unique key for this card
    // final cardKey = 'card_$title';

    // If specialization changed, we need to rebuild the card
    // if (widget.model.specializationsValue == title) {
    //   // Always rebuild selected card to reflect selection state
    //   _specializationCards.remove(cardKey);
    // }

    // // Return cached card if available
    // if (_specializationCards.containsKey(cardKey)) {
    //   return _specializationCards[cardKey]!;
    // }

    final isSelected = widget.model.specializationsValue == title;
    final theme = FlutterFlowTheme.of(context);

    final card = InkWell(
      onTap: () {
        setState(
          () {
            widget.model.specializationsValue = title;
            // Clear animation cache when selection changes
            _animationCache.clear();
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.15)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.primary : theme.alternate,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: FlutterFlowTheme.of(context)
                  .primaryText
                  .withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.primary : theme.secondaryText,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.textCairo(
                context,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? theme.primary : theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );

    // Cache the card
    // _specializationCards[cardKey] = card;
    return card;
  }
}
