import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_widgets.dart';

class CaptchaWidget extends StatefulWidget {
  final Function(bool) onVerified;
  final bool isDarkMode;

  const CaptchaWidget({
    super.key,
    required this.onVerified,
    this.isDarkMode = false,
  });

  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();

  static Widget simpleCaptcha(BuildContext context, Function(bool) onVerified) {
    return SimpleCaptchaWidget(
      onVerified: onVerified,
    );
  }

  /// Shows a CAPTCHA verification dialog and returns whether verification was successful
  static Future<bool> showCaptchaDialog(BuildContext context) async {
    bool isVerified = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      FlutterFlowTheme.of(context).black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                          'humanVerification' /* Human Verification */),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CaptchaWidget(
                  onVerified: (verified) {
                    isVerified = verified;
                    if (verified) {
                      if (context.mounted) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        });
                      }
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 16),
                FFButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  text: FFLocalizations.of(context)
                      .getText('cancel' /* Cancel */),
                  options: FFButtonOptions(
                    width: 120,
                    height: 40,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: AppStyles.textCairo(
                      context,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return isVerified;
  }

  /// Shows a simple CAPTCHA verification dialog and returns whether verification was successful
  static Future<bool> showSimpleCaptchaDialog(BuildContext context) async {
    bool isVerified = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      FlutterFlowTheme.of(context).black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      FFLocalizations.of(context).getText(
                          'humanVerification' /* Human Verification */),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SimpleCaptchaWidget(
                  onVerified: (verified) {
                    isVerified = verified;
                    if (verified) {
                      if (context.mounted) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  FFLocalizations.of(context).getText(
                      'verifyToProveYouAreHuman' /* Please verify to prove you are human */),
                  textAlign: TextAlign.center,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 14,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
                const SizedBox(height: 16),
                FFButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  text: FFLocalizations.of(context)
                      .getText('cancel' /* Cancel */),
                  options: FFButtonOptions(
                    width: 120,
                    height: 40,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: AppStyles.textCairo(
                      context,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return isVerified;
  }
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  late String _captchaText;
  late int _answer;
  final TextEditingController _controller = TextEditingController();
  bool _isVerified = false;
  bool _isError = false;
  int _attempts = 0;
  final int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    final random = Random();
    final operations = ['+', '-', '×'];
    final operation = operations[random.nextInt(operations.length)];

    int num1, num2;

    // Generate numbers based on operation to keep it simple
    if (operation == '+') {
      num1 = random.nextInt(10) + 1; // 1-10
      num2 = random.nextInt(10) + 1; // 1-10
      _answer = num1 + num2;
    } else if (operation == '-') {
      num1 = random.nextInt(10) + 11; // 11-20
      num2 = random.nextInt(10) + 1; // 1-10
      _answer = num1 - num2;
    } else {
      // multiplication
      num1 = random.nextInt(5) + 1; // 1-5
      num2 = random.nextInt(5) + 1; // 1-5
      _answer = num1 * num2;
    }

    _captchaText = '$num1 $operation $num2 = ?';
    _controller.clear();
    _isError = false;
  }

  void _verifyCaptcha() {
    final userAnswer = int.tryParse(_controller.text.trim());

    if (userAnswer == _answer) {
      setState(() {
        _isVerified = true;
        _isError = false;
      });
      widget.onVerified(true);
    } else {
      setState(() {
        _isError = true;
        _attempts++;
        if (_attempts >= _maxAttempts) {
          _attempts = 0;
          _generateCaptcha();
        }
      });
      widget.onVerified(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? FlutterFlowTheme.of(context)
                .primaryBackground
                .withValues(alpha: 0.1)
            : FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isError
              ? FlutterFlowTheme.of(context).error.withValues(alpha: 0.5)
              : FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: FlutterFlowTheme.of(context).black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FFLocalizations.of(context)
                    .getText('humanVerification' /* Human Verification */),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode
                      ? FlutterFlowTheme.of(context).primaryBackground
                      : FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _generateCaptcha();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? FlutterFlowTheme.of(context)
                      .primaryBackground
                      .withValues(alpha: 0.2)
                  : FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: FlutterFlowTheme.of(context)
                    .alternate
                    .withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _captchaText,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode
                        ? FlutterFlowTheme.of(context).primaryBackground
                        : FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: FFLocalizations.of(context)
                  .getText('enterYourAnswer' /* Enter your answer */),
              hintStyle: AppStyles.textCairo(
                context,
                fontSize: 14,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              filled: true,
              fillColor: widget.isDarkMode
                  ? FlutterFlowTheme.of(context)
                      .primaryBackground
                      .withValues(alpha: 0.1)
                  : FlutterFlowTheme.of(context).secondaryBackground,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isError
                      ? FlutterFlowTheme.of(context).error
                      : FlutterFlowTheme.of(context).alternate,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isError
                      ? FlutterFlowTheme.of(context).error
                      : FlutterFlowTheme.of(context).primary,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(
                  _isVerified ? Icons.check_circle : Icons.arrow_forward,
                  color: _isVerified
                      ? FlutterFlowTheme.of(context).success
                      : FlutterFlowTheme.of(context).primary,
                ),
                onPressed: _verifyCaptcha,
              ),
            ),
            style: AppStyles.textCairo(
              context,
              fontSize: 16,
              color: widget.isDarkMode
                  ? FlutterFlowTheme.of(context).primaryBackground
                  : FlutterFlowTheme.of(context).primaryText,
            ),
            onFieldSubmitted: (_) => _verifyCaptcha(),
          ),
          if (_isError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${FFLocalizations.of(context).getText('incorrectAnswerPleaseRetry' /* Incorrect answer. Please try again. */
                    )} (${_maxAttempts - _attempts} ${FFLocalizations.of(context).getText('attemptsLeft' /* attempts left */)})',
                style: AppStyles.textCairo(
                  context,
                  fontSize: 12,
                  color: FlutterFlowTheme.of(context).error,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            FFLocalizations.of(context).getText(
                'solveTheMathProblem' /* Solve the math problem to verify you are human. */),
            style: AppStyles.textCairo(
              context,
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// A simpler version for image-based CAPTCHA
class SimpleCaptchaWidget extends StatefulWidget {
  final Function(bool) onVerified;
  final bool isDarkMode;

  const SimpleCaptchaWidget({
    super.key,
    required this.onVerified,
    this.isDarkMode = false,
  });

  @override
  State<SimpleCaptchaWidget> createState() => _SimpleCaptchaWidgetState();
}

class _SimpleCaptchaWidgetState extends State<SimpleCaptchaWidget> {
  bool _isChecked = false;
  bool _isVerifying = false;
  bool _isVerified = false;

  void _verify() {
    if (_isChecked) {
      setState(() {
        _isVerifying = true;
      });

      // Simulate verification delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isVerifying = false;
            _isVerified = true;
          });
          widget.onVerified(true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? FlutterFlowTheme.of(context)
                .primaryBackground
                .withValues(alpha: 0.1)
            : FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (_isVerifying)
            Container(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            )
          else
            Checkbox(
              value: _isChecked || _isVerified,
              onChanged: _isVerified
                  ? null
                  : (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                      if (value == true) {
                        _verify();
                      } else {
                        widget.onVerified(false);
                      }
                    },
              checkColor: _isVerified
                  ? FlutterFlowTheme.of(context).success
                  : FlutterFlowTheme.of(context).secondary,
              fillColor: WidgetStateProperty.all(
                FlutterFlowTheme.of(context).primaryText,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            _isVerified
                ? FFLocalizations.of(context).getText(
                    'verificationSuccessful' /* Verification successful */)
                : FFLocalizations.of(context)
                    .getText('iAmNotARobot' /* I am not a robot */),
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              color: widget.isDarkMode
                  ? FlutterFlowTheme.of(context).primaryBackground
                  : FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
