import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/componants/coach_appbar/coach_appbar.dart';
import 'package:iron_fit/flutter_flow/custom_functions.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_model.dart';
export 'contact_model.dart';

// Reusable contact item widget
class ContactItem extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final BorderRadius borderRadius;
  final BoxDecoration decoration;
  final EdgeInsetsDirectional padding;

  const ContactItem({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.borderRadius,
    required this.decoration,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: decoration,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: borderRadius,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.textCairo(
                        context,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF57636C),
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ].divide(const SizedBox(width: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable section container
class SectionContainer extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final EdgeInsetsDirectional padding;
  final Widget divider;

  const SectionContainer({
    super.key,
    this.title,
    required this.children,
    required this.borderRadius,
    required this.backgroundColor,
    required this.padding,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: AppStyles.textCairo(
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ...children,
            ].divide(divider),
          ),
        ),
      ),
    );
  }
}

class ContactWidget extends StatefulWidget {
  /// I want a technical support page that includes the ability to send a
  /// message via email as well as a WhatsApp number
  const ContactWidget({super.key});

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  late ContactModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Create static constant values that don't need to be recreated on each build
  static const _borderRadius16 = BorderRadius.all(Radius.circular(16));
  static const _borderRadius8 = BorderRadius.all(Radius.circular(8));
  static const _borderRadius12 = BorderRadius.all(Radius.circular(12));
  static const _borderRadius25 = BorderRadius.all(Radius.circular(12));
  static const _padding24 = EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24);
  static const _padding16 = EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16);
  static const _padding0 = EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0);
  static const _whatsappColor = Color(0xFF25D366);
  static const _transparentColor = Color(0x00000000);
  static const _dividerHeight16 = SizedBox(height: 16);
  static const _dividerHeight24 = SizedBox(height: 24);
  static const _dividerWidth12 = SizedBox(width: 12);
  static const _zeroHeight = SizedBox(height: 0);

  // Cached theme values to avoid retrieving them on each build
  late Color _primaryBackground;
  late Color _primary;
  late Color _accent1;
  late Color _info;
  late Color _alternate;
  late Color _secondaryText;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContactModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache theme values once per context change to avoid repeated lookups
    _primaryBackground = FlutterFlowTheme.of(context).primaryBackground;
    _primary = FlutterFlowTheme.of(context).primary;
    _accent1 = FlutterFlowTheme.of(context).accent1;
    _info = FlutterFlowTheme.of(context).info;
    _alternate = FlutterFlowTheme.of(context).alternate;
    _secondaryText = FlutterFlowTheme.of(context).secondaryText;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _sendEmail() async {
    final name = _model.textController1.text;
    final email = _model.textController2.text;
    final message = _model.textController3.text;

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      showErrorDialog(
          FFLocalizations.of(context).getText('pleaseFillAllRequiredFields'),
          context);
      return;
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'abusalhm102@gmail.com',
      queryParameters: {
        'subject': 'Support Request from $name',
        'body': 'From: $name\nEmail: $email\n\nMessage:\n$message',
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch email';
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(
            FFLocalizations.of(context).getText('failed_to_send_email'),
            context);
      }
    }
  }

  // Create a method that builds the transparent BorderSide to avoid recreation
  BorderSide get _transparentBorderSide => const BorderSide(
        color: _transparentColor,
        width: 1.0,
      );

  // Create a method to build text form field to avoid repetition
  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    int minLines = 1,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: FFLocalizations.of(context).getText(labelText),
        labelStyle: AppStyles.textCairo(
          context,
          fontSize: 12,
        ),
        hintStyle: AppStyles.textCairo(
          context,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _alternate,
            width: 1.0,
          ),
          borderRadius: _borderRadius8,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: _transparentBorderSide,
          borderRadius: _borderRadius8,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: _transparentBorderSide,
          borderRadius: _borderRadius8,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: _transparentBorderSide,
          borderRadius: _borderRadius8,
        ),
        filled: true,
        fillColor: _primaryBackground,
      ),
      style: FlutterFlowTheme.of(context).bodyLarge.override(
            fontFamily: 'Inter',
            letterSpacing: 0.0,
          ),
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cache screen width to avoid repeated MediaQuery calls
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Create contact section box decoration once
    final contactItemDecoration = BoxDecoration(
      color: _primaryBackground,
      borderRadius: _borderRadius12,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: _primaryBackground,
          extendBodyBehindAppBar: true,
          appBar: CoachAppBar.coachAppBar(
              context,
              FFLocalizations.of(context).getText(
                'e1g3ko1c' /* Support */,
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
              null),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).padding.top, 20, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primaryBackground,
                  FlutterFlowTheme.of(context).success.withOpacity(0.2),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Support section
                    SectionContainer(
                      borderRadius: _borderRadius16,
                      backgroundColor: _primaryBackground,
                      padding: _padding24,
                      divider: _dividerHeight16,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _accent1,
                                borderRadius: _borderRadius25,
                              ),
                              child: Icon(
                                Icons.support_agent,
                                color: _primary,
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      '247_support' /* 24/7 Support */,
                                    ),
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'we_here_to_help' /* We're here to help you */,
                                    ),
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: 12,
                                      color: _secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ].divide(_dividerWidth12),
                        ),
                      ],
                    ),

                    // Contact form section
                    SectionContainer(
                      title: FFLocalizations.of(context).getText(
                        'send_us_a_message' /* Send us a message */,
                      ),
                      borderRadius: _borderRadius16,
                      backgroundColor: _primaryBackground,
                      padding: _padding24,
                      divider: _dividerHeight16,
                      children: [
                        _buildTextField(
                          controller: _model.textController1!,
                          focusNode: _model.textFieldFocusNode1!,
                          labelText: 'your_name' /* Your Name */,
                          validator: _model.textController1Validator
                              .asValidator(context),
                        ),
                        _buildTextField(
                          controller: _model.textController2!,
                          focusNode: _model.textFieldFocusNode2!,
                          labelText: 'your_email' /* Email Address */,
                          validator: _model.textController2Validator
                              .asValidator(context),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          controller: _model.textController3!,
                          focusNode: _model.textFieldFocusNode3!,
                          labelText: 'your_message' /* Message */,
                          validator: _model.textController3Validator
                              .asValidator(context),
                          minLines: 3,
                          maxLines: 5,
                        ),
                        FFButtonWidget(
                          onPressed: _sendEmail,
                          text: FFLocalizations.of(context).getText(
                            'send_message' /* Send Message */,
                          ),
                          options: FFButtonOptions(
                            width: screenWidth,
                            height: 50,
                            padding: _padding0,
                            iconPadding: _padding0,
                            color: _primary,
                            textStyle: AppStyles.textCairo(
                              context,
                              color: _info,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 2,
                            borderRadius: _borderRadius25,
                          ),
                        ),
                      ],
                    ),

                    // Direct contact section
                    SectionContainer(
                      title: FFLocalizations.of(context).getText(
                        'contact_us_directly' /* Contact Us Directly */,
                      ),
                      borderRadius: _borderRadius16,
                      backgroundColor: _primaryBackground,
                      padding: _padding24,
                      divider: _dividerHeight16,
                      children: [
                        ContactItem(
                          icon: Icons.wechat_sharp,
                          iconBackgroundColor: _whatsappColor,
                          iconColor: _info,
                          title: FFLocalizations.of(context)
                              .getText('whatsapp_support'),
                          subtitle: '+970 592 455 040',
                          borderRadius: _borderRadius25,
                          decoration: contactItemDecoration,
                          padding: _padding16,
                        ),
                        ContactItem(
                          icon: Icons.email,
                          iconBackgroundColor: Colors.blue,
                          iconColor: _info,
                          title: FFLocalizations.of(context)
                              .getText('email_support'),
                          subtitle: 'abusalhm102@gmail.com',
                          borderRadius: _borderRadius25,
                          decoration: contactItemDecoration,
                          padding: _padding16,
                        ),
                      ],
                    ),
                    _zeroHeight,
                  ].divide(_dividerHeight24),
                ),
              ),
            ),
          )),
    );
  }
}
