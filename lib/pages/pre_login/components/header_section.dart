import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iron_fit/utils/responsive_utils.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection>
    with TickerProviderStateMixin {
  late AnimationController _typewriterController;
  final String _fullText =
      'Say goodbye to messy spreadsheets! Streamline your workflow with smooth, stress-free management';
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _typewriterController.addListener(() {
      final progress = _typewriterController.value;
      final textLength = (_fullText.length * progress).round();

      setState(() {
        _currentText = _fullText.substring(0, textLength);
      });
    });

    // Start typewriter after a short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      _typewriterController.forward();
    });
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final descriptionStyle = GoogleFonts.poppins(
      fontSize: ResponsiveUtils.fontSize(context, 16),
      color: FlutterFlowTheme.of(context).info.withValues(alpha: 0.9),
      height: 1.5,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: ResponsiveUtils.height(context, 40)),
        Text(
          'IRONFIT',
          style: GoogleFonts.poppins(
            fontSize: ResponsiveUtils.fontSize(context, 40),
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).info.withValues(alpha: 0.8),
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 12)),
        AnimatedOpacity(
          opacity: _currentText.isEmpty ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.width(context, 16), 
              vertical: ResponsiveUtils.height(context, 12)
            ),
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.width(context, 8)
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _currentText,
                  textAlign: TextAlign.center,
                  style: descriptionStyle,
                ),
                SizedBox(height: ResponsiveUtils.height(context, 24)),
                // Container(
                //   padding: const EdgeInsets.all(6),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withValues(alpha: 0.2),
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(
                //       color: Colors.white.withValues(alpha: 0.3),
                //       width: 1.5,
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withValues(alpha: 0.1),
                //         blurRadius: 10,
                //         spreadRadius: 1,
                //       ),
                //     ],
                //   ),
                //   child: Lottie.asset(
                //     'assets/lottie/fitness2.json',
                //     width: 50,
                //     height: 50,
                //     fit: BoxFit.contain,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.height(context, 24)),
      ],
    );
  }
}
