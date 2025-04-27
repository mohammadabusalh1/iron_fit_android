import 'package:flutter/material.dart';
import 'package:iron_fit/backend/backend.dart';
import 'package:iron_fit/componants/Styles.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_theme.dart';
import 'package:iron_fit/flutter_flow/flutter_flow_util.dart';
import 'package:iron_fit/services/trainee_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that displays trainee information in a card format.
class TraineeCard extends StatelessWidget {
  final SubscriptionsRecord subscription;
  final TraineeRecord? traineeRecord;
  final UserRecord? userRecord;
  final Widget? subscriptionStatus;
  final TraineeService traineeService;
  final Function() refreshSubscription;

  const TraineeCard({
    super.key,
    required this.subscription,
    this.traineeRecord,
    this.userRecord,
    this.subscriptionStatus,
    required this.traineeService,
    required this.refreshSubscription,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    return _buildTraineeCard(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUserProfileSection(context, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildTraineeCard(BuildContext context, {required Widget child}) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Material(
      color: Colors.transparent,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 12.0 : 16.0),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: screenSize.width < 1200 ? double.infinity : 1200,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(isSmallScreen ? 12.0 : 16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withAlpha(40),
            width: 1,
          ),
        ),
        child: child,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
          duration: 2000.ms,
          color: FlutterFlowTheme.of(context).primary.withAlpha(20),
        );
  }

  Widget _buildUserProfileSection(BuildContext context, bool isSmallScreen) {
    return _buildUnifiedUserProfile(context, isSmallScreen);
  }

  Widget _buildUnifiedUserProfile(BuildContext context, bool isSmallScreen) {
    final avatarSize = isSmallScreen ? 60.0 : 70.0;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final verticalPadding = isSmallScreen ? 16.0 : 20.0;
    final spacing = isSmallScreen ? 12.0 : 16.0;
    final isAnonymous = subscription.isAnonymous;

    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(context, avatarSize, isAnonymous),
                SizedBox(width: spacing),
                Expanded(
                  child: _buildUserInfo(
                      context, isSmallScreen, false, isAnonymous),
                ),
              ],
            ),
            // Additional trainee information (only for registered users)
            if (!isAnonymous && traineeRecord != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      context,
                      icon: Icons.person_outline,
                      label: FFLocalizations.of(context)
                          .getText('gciphuh3'), // Gender
                      value: traineeRecord?.gender.isEmpty ?? true
                          ? FFLocalizations.of(context).getText('none')
                          : traineeRecord!.gender,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      icon: Icons.monitor_weight_outlined,
                      label: FFLocalizations.of(context)
                          .getText('g6q5j6kk'), // Weight
                      value: traineeRecord?.weight == null
                          ? FFLocalizations.of(context).getText('none')
                          : '${traineeRecord!.weight} kg',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      icon: Icons.height_outlined,
                      label: FFLocalizations.of(context)
                          .getText('jpb8oaaf'), // Height
                      value: traineeRecord?.height == null
                          ? FFLocalizations.of(context).getText('none')
                          : '${traineeRecord!.height} cm',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ));
  }

  Widget _buildAvatar(BuildContext context, double size, bool isAnonymous) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withAlpha(40),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: isAnonymous || userRecord == null || userRecord!.photoUrl.isEmpty
            ? Icon(
                isAnonymous
                    ? Icons.person_outline_rounded
                    : Icons.person_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: size / 2,
              )
            : Image.network(
                userRecord!.photoUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person_rounded,
                  color: FlutterFlowTheme.of(context).primary,
                  size: size / 2,
                ),
              ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, bool isSmallScreen,
      bool isCentered, bool isAnonymous) {
    final textScaler = MediaQuery.of(context).textScaler;
    final adjustedFontSize = (size) => textScaler.scale(size.toDouble());

    return Column(
      crossAxisAlignment:
          isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Name section with edit button
        Row(
          mainAxisSize: isCentered ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Flexible(
              child: Text(
                subscription.name.isEmpty
                    ? FFLocalizations.of(context).getText('none')
                    : subscription.name,
                style: AppStyles.textCairo(
                  context,
                  fontSize: adjustedFontSize(isSmallScreen ? 16 : 18),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                textAlign: isCentered ? TextAlign.center : TextAlign.start,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: isSmallScreen ? 16 : 18,
                color: FlutterFlowTheme.of(context).primary,
              ),
              onPressed: () => _showNameEditDialog(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 2 : 4),

        // Email section with copy feature
        Row(
          mainAxisSize: isCentered ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Flexible(
              child: InkWell(
                onTap: () => traineeService.copyEmailToClipboard(context,
                    isAnonymous ? subscription.email : userRecord?.email ?? ''),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        isAnonymous
                            ? subscription.email
                            : (userRecord?.email == null ||
                                    userRecord!.email.isEmpty
                                ? FFLocalizations.of(context).getText('none')
                                : userRecord!.email),
                        style: AppStyles.textCairo(
                          context,
                          fontSize: adjustedFontSize(isSmallScreen ? 12 : 14),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          decoration: TextDecoration.underline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.copy_rounded,
                      size: isSmallScreen ? 12 : 14,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 200.ms).scale(
                    duration: 200.ms,
                    curve: Curves.easeOut,
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                  ),
            ),
            // Show email edit button only for anonymous users
            if (isAnonymous)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: isSmallScreen ? 14 : 16,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                onPressed: () => _showEmailEditDialog(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 2 : 4),

        // Membership date section
        Row(
          mainAxisSize: isCentered ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: isSmallScreen ? 12 : 14,
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${FFLocalizations.of(context).getText('memberSince')}: ${dateTimeFormat(
                  "yyyy/MM/dd",
                  subscription.startDate,
                  locale: FFLocalizations.of(context).languageCode,
                )}',
                style: AppStyles.textCairo(
                  context,
                  fontSize: adjustedFontSize(isSmallScreen ? 10 : 12),
                  color: FlutterFlowTheme.of(context).primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 4 : 8),

        // Trainee level display
        _buildTraineeLevelDisplay(context, isSmallScreen, isCentered),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: FlutterFlowTheme.of(context).primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $value',
            style: AppStyles.textCairo(
              context,
              fontSize: 14,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTraineeLevelDisplay(
      BuildContext context, bool isSmallScreen, bool isCentered) {
    final textScaler = MediaQuery.of(context).textScaler;
    final adjustedFontSize = (size) => textScaler.scale(size.toDouble());

    // Get level from subscription record
    // The level is stored as a list of strings in the subscription record
    String level = subscription.level;

    // Default level if none is set
    if (level.isEmpty) {
      level = 'Beginner';
    }

    // Generate colors for different levels - using app theme colors for consistency
    final levelColors = {
      FFLocalizations.of(context).getText('laspafpx'):
          FlutterFlowTheme.of(context).primary,
      FFLocalizations.of(context).getText('an9bjzkg'):
          FlutterFlowTheme.of(context).primary,
      FFLocalizations.of(context).getText('kd992kuh'):
          FlutterFlowTheme.of(context).primary,
    };

    // Get appropriate color for the level or use a default
    Color getLevelColor(String level) {
      return levelColors[level.toLowerCase()] ??
          levelColors[level] ??
          FlutterFlowTheme.of(context).primary;
    }

    // Get appropriate icon for the level
    IconData getLevelIcon(String level) {
      switch (level.toLowerCase()) {
        case 'Beginner':
          return Icons.star_border_rounded;
        case 'Intermediate':
          return Icons.star_half_rounded;
        case 'Advanced':
          return Icons.star_rounded;
        case 'مبتدئ':
          return Icons.star_border_rounded;
        case 'متوسط':
          return Icons.star_half_rounded;
        case 'متقدم':
          return Icons.star_rounded;
        default:
          return Icons.fitness_center_rounded;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            getLevelColor(level).withOpacity(0.8),
            getLevelColor(level),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: getLevelColor(level).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getLevelIcon(level),
            size: isSmallScreen ? 14 : 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            level,
            style: AppStyles.textCairo(
              context,
              fontSize: adjustedFontSize(isSmallScreen ? 12 : 14),
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideX(
          begin: 0.2,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutQuart,
          delay: 200.ms,
        )
        .shimmer(
          duration: 1200.ms,
          delay: 800.ms,
          color: Colors.white.withOpacity(0.4),
        );
  }

  void _showNameEditDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final textScaler = MediaQuery.of(context).textScaler;
    final adjustedFontSize = (size) => textScaler.scale(size.toDouble());

    final TextEditingController nameController =
        TextEditingController(text: subscription.name);
    final nameFocusNode = FocusNode();
    bool isLoading = false;

    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      nameFocusNode.requestFocus();
    });

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context22, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              ),
              elevation: 5,
              child: Container(
                width: screenSize.width < 600 ? double.infinity : 400,
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withAlpha(25),
                            borderRadius:
                                BorderRadius.circular(isSmallScreen ? 10 : 12),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 15),
                        Expanded(
                          child: Text(
                            FFLocalizations.of(context).getText('editName'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize:
                                  adjustedFontSize(isSmallScreen ? 18 : 20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: isSmallScreen ? 20 : 22,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    TextField(
                      onTap: () {
                        nameController.selection = TextSelection.fromPosition(
                          TextPosition(offset: nameController.text.length),
                        );
                      },
                      focusNode: nameFocusNode,
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText:
                            FFLocalizations.of(context).getText('enterName'),
                        prefixIcon: Icon(
                          Icons.edit_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: isSmallScreen ? 20 : 22,
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 10 : 12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 10 : 12),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 14 : 16,
                          horizontal: isSmallScreen ? 16 : 20,
                        ),
                      ),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: adjustedFontSize(isSmallScreen ? 14 : 16),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 10 : 12,
                              ),
                              backgroundColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 10 : 12),
                              ),
                            ),
                            child: Text(
                              FFLocalizations.of(context).getText('cancel'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize:
                                    adjustedFontSize(isSmallScreen ? 14 : 16),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 15),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 10 : 12,
                              ),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 10 : 12),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (nameController.text.trim().isNotEmpty) {
                                      setState(() => isLoading = true);
                                      Navigator.of(dialogContext).pop();
                                      await traineeService.updateTraineeName(
                                        context,
                                        subscription.reference,
                                        nameController.text.trim(),
                                      );
                                      await refreshSubscription();
                                    }
                                  },
                            child: isLoading
                                ? SizedBox(
                                    width: isSmallScreen ? 18 : 20,
                                    height: isSmallScreen ? 18 : 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).info),
                                    ),
                                  )
                                : Text(
                                    FFLocalizations.of(context).getText('save'),
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: adjustedFontSize(
                                          isSmallScreen ? 14 : 16),
                                      color: FlutterFlowTheme.of(context).info,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).scale(
                  duration: 300.ms,
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.easeOutBack,
                );
          },
        );
      },
    );
  }

  void _showEmailEditDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final textScaler = MediaQuery.of(context).textScaler;
    final adjustedFontSize = (size) => textScaler.scale(size.toDouble());

    final TextEditingController emailController =
        TextEditingController(text: subscription.email);
    final emailFocusNode = FocusNode();
    bool isLoading = false;
    bool isValidEmail = true;

    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      emailFocusNode.requestFocus();
    });

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context22, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              ),
              elevation: 5,
              child: Container(
                width: screenSize.width < 600 ? double.infinity : 400,
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withAlpha(25),
                            borderRadius:
                                BorderRadius.circular(isSmallScreen ? 10 : 12),
                          ),
                          child: Icon(
                            Icons.email_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 15),
                        Expanded(
                          child: Text(
                            FFLocalizations.of(context).getText('editEmail'),
                            style: AppStyles.textCairo(
                              context,
                              fontSize:
                                  adjustedFontSize(isSmallScreen ? 18 : 20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: isSmallScreen ? 20 : 22,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    TextField(
                      onTap: () {
                        emailController.selection = TextSelection.fromPosition(
                          TextPosition(offset: emailController.text.length),
                        );
                      },
                      focusNode: emailFocusNode,
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText:
                            FFLocalizations.of(context).getText('enterEmail'),
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: isSmallScreen ? 20 : 22,
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 10 : 12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 10 : 12),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 14 : 16,
                          horizontal: isSmallScreen ? 16 : 20,
                        ),
                        errorText: !isValidEmail
                            ? FFLocalizations.of(context)
                                .getText('invalidEmail')
                            : null,
                      ),
                      style: AppStyles.textCairo(
                        context,
                        fontSize: adjustedFontSize(isSmallScreen ? 14 : 16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        setState(() {
                          isValidEmail =
                              value.isEmpty || emailRegex.hasMatch(value);
                        });
                      },
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 10 : 12,
                              ),
                              backgroundColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 10 : 12),
                              ),
                            ),
                            child: Text(
                              FFLocalizations.of(context).getText('cancel'),
                              style: AppStyles.textCairo(
                                context,
                                fontSize:
                                    adjustedFontSize(isSmallScreen ? 14 : 16),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 15),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 10 : 12,
                              ),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 10 : 12),
                              ),
                            ),
                            onPressed: (isLoading ||
                                    !isValidEmail ||
                                    emailController.text.trim().isEmpty)
                                ? null
                                : () async {
                                    setState(() => isLoading = true);
                                    Navigator.of(dialogContext).pop();
                                    await traineeService.updateTraineeEmail(
                                      context,
                                      subscription.reference,
                                      emailController.text.trim(),
                                    );
                                    await refreshSubscription();
                                  },
                            child: isLoading
                                ? SizedBox(
                                    width: isSmallScreen ? 18 : 20,
                                    height: isSmallScreen ? 18 : 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).info),
                                    ),
                                  )
                                : Text(
                                    FFLocalizations.of(context).getText('save'),
                                    style: AppStyles.textCairo(
                                      context,
                                      fontSize: adjustedFontSize(
                                          isSmallScreen ? 14 : 16),
                                      color: FlutterFlowTheme.of(context).info,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).scale(
                  duration: 300.ms,
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.easeOutBack,
                );
          },
        );
      },
    );
  }
}
