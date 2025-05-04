import 'package:iron_fit/componants/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_fit/utils/logger.dart';
import 'package:iron_fit/utils/responsive_utils.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class CheckSubscribe extends StatefulWidget {
  final VoidCallback showInterstitialAd;
  final String page;
  final VoidCallback? showDialog;

  /// create navbar has: home, clients, plans, messages and analytics
  const CheckSubscribe({
    super.key,
    required this.showInterstitialAd,
    required this.page,
    this.showDialog,
  });

  @override
  State<CheckSubscribe> createState() => _CheckSubscribeState();
}

class _CheckSubscribeState extends State<CheckSubscribe> {
  String _monthlyPrice = '20\$';

  @override
  void initState() {
    super.initState();
    _fetchPrice();
  }

  Future<void> _fetchPrice() async {
    try {
      final pricesCollection =
          await FirebaseFirestore.instance.collection('price').get();
      if (pricesCollection.docs.isNotEmpty) {
        final data = pricesCollection.docs.first.data();
        setState(() {
          _monthlyPrice =
              data['monthly'] != null ? '${data['monthly']}\$' : '20\$';
        });
      }
    } catch (e) {
      Logger.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: ResponsiveUtils.width(context, 320),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: ResponsiveUtils.padding(context, horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  FFLocalizations.of(context)
                      .getText('jqy87hqi' /* Continue Watching */),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: ResponsiveUtils.fontSize(context, 20),
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 4)),
                Text(
                  FFLocalizations.of(context).getText(
                      'xjwed7h7' /* Choose how you'd like to acces... */),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    color: theme.secondaryText,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                _buildPremiumOption(context, theme),
                SizedBox(height: ResponsiveUtils.height(context, 16)),
                _buildWatchAdOption(context, theme),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: theme.secondaryText,
                size: ResponsiveUtils.iconSize(context, 24),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumOption(BuildContext context, FlutterFlowTheme theme) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        context.pushNamed('Subscription');
      },
      child: Container(
        width: double.infinity,
        height: ResponsiveUtils.height(context, 100),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
          child: _PremiumOptionContent(monthlyPrice: _monthlyPrice),
        ),
      ),
    );
  }

  Widget _buildWatchAdOption(BuildContext context, FlutterFlowTheme theme) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        widget.showInterstitialAd();
        if (widget.page.isNotEmpty) {
          context.pushNamed(widget.page);
        } else if (widget.showDialog != null) {
          widget.showDialog!();
        }
      },
      child: Container(
        width: double.infinity,
        height: ResponsiveUtils.height(context, 100),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: ResponsiveUtils.padding(context, horizontal: 12, vertical: 12),
          child: const _WatchAdOptionContent(),
        ),
      ),
    );
  }
}

class _PremiumOptionContent extends StatelessWidget {
  final String monthlyPrice;

  const _PremiumOptionContent({
    required this.monthlyPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspace_premium,
              color: theme.primary,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 8)),
            Text(
              FFLocalizations.of(context)
                  .getText('w5rfrseu' /* Premium Access */),
              style: AppStyles.textCairo(
                context,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.height(context, 8)),
        Text(
          '$monthlyPrice${FFLocalizations.of(context).getText('29k2j7bb' /* /month - No ads, unlimite... */)}',
          textAlign: TextAlign.center,
          style: AppStyles.textCairo(
            context,
            color: theme.secondaryText,
            fontSize: ResponsiveUtils.fontSize(context, 12),
          ),
        ),
      ],
    );
  }
}

class _WatchAdOptionContent extends StatelessWidget {
  const _WatchAdOptionContent();

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle,
              color: theme.tertiary,
              size: ResponsiveUtils.iconSize(context, 24),
            ),
            SizedBox(width: ResponsiveUtils.width(context, 8)),
            Text(
              FFLocalizations.of(context).getText('bsb8adg1' /* Watch Ad */),
              style: AppStyles.textCairo(
                context,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.height(context, 8)),
        Text(
          FFLocalizations.of(context)
              .getText('cpwu14gx1' /* Watch a 30-second ad to contin... */),
          textAlign: TextAlign.center,
          style: AppStyles.textCairo(
            context,
            color: theme.secondaryText,
            fontSize: ResponsiveUtils.fontSize(context, 12),
          ),
        ),
      ],
    );
  }
}
