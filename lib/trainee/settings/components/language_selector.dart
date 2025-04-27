import 'package:flutter/material.dart';
import '/componants/Styles.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({
    super.key,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = FFLocalizations.of(context).languageCode;
    final languageName = currentLanguage == 'en' ? 'English' : 'العربية';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main language selector button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.language,
                        color: Colors.purple,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText('language'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            languageName,
                            style: AppStyles.textCairo(
                              context,
                              fontSize: 13,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 3.14159,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: FlutterFlowTheme.of(context)
                                .secondaryText
                                .withOpacity(0.7),
                            size: 22,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Language options
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? 100 : 0,
            curve: Curves.easeInOut,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .primaryBackground
                  .withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildLanguageOption(
                    context,
                    'English',
                    'en',
                    currentLanguage == 'en',
                  ),
                  const Divider(height: 1, thickness: 0.5),
                  _buildLanguageOption(
                    context,
                    'العربية',
                    'ar',
                    currentLanguage == 'ar',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String name,
    String code,
    bool isSelected,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setAppLanguage(context, code);
          _toggleExpanded();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  name,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? Colors.purple
                        : FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
