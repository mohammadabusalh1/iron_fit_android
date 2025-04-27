import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import 'package:iron_fit/utils/logger.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerificationService {
  static const String _username = 'abusalhm102@gmail.com';
  static const String _password = 'oahj zpke csxb tyix';

  // Generate a random 6-digit verification code
  static String generateVerificationCode() {
    final random = Random();
    // Generate a random 6-digit number
    final code =
        random.nextInt(900000) + 100000; // This ensures a 6-digit number
    return code.toString();
  }

  // Send verification email
  static Future<bool> sendVerificationEmail({
    required String recipientEmail,
    required String verificationCode,
  }) async {
    final smtpServer = gmail(_username, _password);

    // Create our message.
    final message = Message()
      ..from = const Address(_username)
      ..recipients.add(recipientEmail)
      ..subject = 'Your IronFit Verification Code'
      ..text = 'Your verification code is: $verificationCode'
      ..html = '''
  <html>
    <body>
      <p>Hello,</p>
      <p>Your IronFit verification code is: <strong>$verificationCode</strong></p>
      <p>This code is valid for 10 minutes.</p>
      <p>Thanks,<br>IronFit Team</p>
    </body>
  </html>
''';

    try {
      final sendReport = await send(message, smtpServer);
      Logger.info('Verification email sent: ${sendReport.toString()}');
      return true;
    } on MailerException catch (e) {
      Logger.error('Failed to send verification email to $recipientEmail', e);
      for (var p in e.problems) {
        Logger.error('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    } catch (e, stackTrace) {
      Logger.error(
          'Unexpected error sending verification email', e, stackTrace);
      return false;
    }
  }

  // Send welcome email
  static Future<bool> sendWelcomeEmail({
    required String recipientEmail,
    required String userName,
  }) async {
    final smtpServer = gmail(_username, _password);

    // Create HTML template for welcome email
    final htmlBody = '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { text-align: center; margin-bottom: 30px; }
            .content { background-color: #f9f9f9; padding: 20px; border-radius: 8px; }
            .footer { text-align: center; margin-top: 30px; font-size: 12px; color: #666; }
            .button {
                display: inline-block;
                padding: 10px 20px;
                background-color: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Welcome to IronFit!</h1>
            </div>
            <div class="content">
                <p>Dear $userName,</p>
                <p>Welcome to IronFit! We're thrilled to have you join our community of fitness enthusiasts.</p>
                <p>With IronFit, you'll have access to:</p>
                <ul>
                    <li>Personalized workout plans</li>
                    <li>Expert coaching</li>
                    <li>Progress tracking</li>
                    <li>Nutrition guidance</li>
                </ul>
                <p>Get ready to transform your fitness journey!</p>
                <center><a href="#" class="button">Start Your Journey</a></center>
            </div>
            <div class="footer">
                <p>If you have any questions, feel free to contact our support team.</p>
                <p>© ${DateTime.now().year} IronFit. All rights reserved.</p>
            </div>
        </div>
    </body>
    </html>
    ''';

    final message = Message()
      ..from = const Address(_username, 'IronFit Team')
      ..recipients.add(recipientEmail)
      ..subject = 'Welcome to IronFit! 🎉'
      ..html = htmlBody;

    try {
      final sendReport = await send(message, smtpServer);
      Logger.info(
          'Welcome email sent to $recipientEmail: ${sendReport.toString()}');
      return true;
    } on MailerException catch (e) {
      Logger.error('Failed to send welcome email to $recipientEmail', e);
      for (var p in e.problems) {
        Logger.error('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    } catch (e, stackTrace) {
      Logger.error('Unexpected error sending welcome email', e, stackTrace);
      return false;
    }
  }

  // Show verification code dialog
  static Future<bool?> showVerificationDialog({
    required BuildContext context,
    required String email,
    required String verificationCode,
  }) async {
    Logger.debug('Showing verification dialog for email: $email');
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final codeController = TextEditingController();
        return AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(
                Icons.email_outlined,
                size: 50,
                color: FlutterFlowTheme.of(context).primary,
              ),
              const SizedBox(height: 16),
              Text(
                FFLocalizations.of(context).getText('emailVerification'),
                style: AppStyles.textCairo(
                  context,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  FFLocalizations.of(context).getText('enterVerificationCode'),
                  style: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 12,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: codeController,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 45,
                    fieldWidth: 35,
                    activeFillColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                    selectedFillColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                    inactiveFillColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                    activeColor: FlutterFlowTheme.of(context).primary,
                    selectedColor: FlutterFlowTheme.of(context).primary,
                    inactiveColor: FlutterFlowTheme.of(context).alternate,
                  ),
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    if (value == verificationCode) {
                      Logger.info(
                          'Verification code successfully validated for $email');
                      Navigator.pop(context, true);
                    } else {
                      Logger.warning(
                          'Invalid verification code entered for $email');
                      showErrorDialog(
                          FFLocalizations.of(context).getText('invalidCode'),
                          context);
                      codeController.clear();
                    }
                  },
                ),
                TextButton(
                  onPressed: () async {
                    Logger.debug('Resending verification code to $email');
                    final resendResult = await sendVerificationEmail(
                      recipientEmail: email,
                      verificationCode: verificationCode,
                    );
                    if (resendResult) {
                      if (context.mounted) {
                        Logger.info(
                            'Verification code resent successfully to $email');
                        showSuccessDialog(
                            FFLocalizations.of(context)
                                .getText('emailVerificationMessage'),
                            context);
                      }
                    } else {
                      if (context.mounted) {
                        Logger.warning(
                            'Failed to resend verification code to $email');
                        showErrorDialog(
                            FFLocalizations.of(context)
                                .getText('failedToResendCode'),
                            context);
                      }
                    }
                  },
                  child: Text(
                    FFLocalizations.of(context)
                        .getText('resendVerificationCode'),
                    style: AppStyles.textCairo(
                      context,
                      fontSize: 14,
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  FFLocalizations.of(context).getText('ifCodeDoesNotArive'),
                  style: AppStyles.textCairo(
                    context,
                    color: FlutterFlowTheme.of(context).error,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Logger.debug('Verification canceled for $email');
                Navigator.pop(context, false);
              },
              child: Text(
                FFLocalizations.of(context).getText('cancel'),
                style: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (codeController.text == verificationCode) {
                  Logger.info('Verification code manually verified for $email');
                  Navigator.pop(context, true);
                } else {
                  Logger.warning(
                      'Invalid verification code manually entered for $email');
                  showErrorDialog(
                      FFLocalizations.of(context).getText('invalidCode'),
                      context);
                  codeController.clear();
                }
              },
              child: Text(
                FFLocalizations.of(context).getText('verifyCode'),
                style: AppStyles.textCairo(
                  context,
                  color: FlutterFlowTheme.of(context).primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
