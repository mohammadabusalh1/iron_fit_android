import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class MealItem extends StatelessWidget {
  final MealStruct meal;

  const MealItem({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.height(context, 16.0)),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Add meal detail navigation here if needed
        },
        borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 16.0)),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.width(context, 16.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'meal-${meal.name}',
                child: Container(
                  width: ResponsiveUtils.width(context, 65.0),
                  height: ResponsiveUtils.height(context, 65.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.width(context, 12.0)),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/meal.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveUtils.width(context, 16.0)),
              // Content section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: ResponsiveUtils.fontSize(context, 18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.height(context, 8.0)),
                    Text(
                      meal.desc,
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.textCairo(
                        context,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: ResponsiveUtils.fontSize(context, 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 400.ms, delay: 400.ms)
        .slideX(begin: 0.1, end: 0);
  }
}
