import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import 'package:iron_fit/widgets/build_text_filed.dart';
import '../coach_enter_info_model.dart';
import 'package:provider/provider.dart';
import '../coach_enter_info_widget.dart';

class PricingSection extends StatefulWidget {
  final CoachEnterInfoModel model;
  final BuildContext context;

  const PricingSection({
    super.key,
    required this.model,
    required this.context,
  });

  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection>
    with AutomaticKeepAliveClientMixin {
  // Memoized animation widgets
  Widget? _cachedAnimation;
  String? _lastPrice;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Rebuild if price has changed
    if (_lastPrice != widget.model.priceTextController.text) {
      _lastPrice = widget.model.priceTextController.text;
      _cachedAnimation = null;
    }

    // Return cached UI if available
    if (_cachedAnimation != null) {
      return _cachedAnimation!;
    }

    // Build and cache the UI
    _cachedAnimation = _buildPricingUI();
    return _cachedAnimation!;
  }

  Widget _buildPricingUI() {
    return Padding(
      padding: ResponsiveUtils.padding(context, horizontal: 24, vertical: 16),
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
                    textAlign: TextAlign.center,
                    FFLocalizations.of(context).getText('pricing_step'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: ResponsiveUtils.fontSize(context, 22),
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: ResponsiveUtils.height(context, 24)),
          // Price Input with Animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: buildTextField(
              onTap: () {
                // Move cursor to end of text
                widget.model.priceTextController.selection =
                    TextSelection.fromPosition(
                  TextPosition(
                      offset: widget.model.priceTextController.text.length),
                );
              },
              context: context,
              controller: widget.model.priceTextController,
              focusNode: widget.model.priceFocusNode,
              labelText: FFLocalizations.of(context).getText('price_per_month'),
              hintText: FFLocalizations.of(context).getText('enter_price'),
              validator: (val) => val == null || val.isEmpty
                  ? FFLocalizations.of(context).getText('thisFieldIsRequired')
                  : null,
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (_) =>
                  Provider.of<CoachInfoState>(context, listen: false)
                      .onFieldSubmitted(context),
            ),
          ),
        ],
      ),
    );
  }
}
