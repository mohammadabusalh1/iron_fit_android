import 'package:flutter/material.dart';
import '../models/partner_search_models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Common styles for the partner search feature
class PartnerSearchStyles {
  // Colors
  static const Color primary = Color(0xFFFFBB02);
  static const Color secondary = Color(0xFF292929);
  static const Color tertiary = Color(0xFFEB8317);
  static const Color alternate = Color(0xFF262D34);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF95A1AC);
  static const Color primaryBackground = Color(0xFF1D2428);
  static const Color secondaryBackground = Color(0xFF14181B);
  static const Color accent1 = Color(0xFF10375C);
  static const Color accent2 = Color(0x4D39D2C0);
  static const Color accent3 = Color(0x4DEE8B60);
  static const Color accent4 = Color(0xB3262D34);
  static const Color success = Color(0xFF249689);
  static const Color warning = Color(0xFFF9CF58);
  static const Color error = Color(0xFFf03e3e);
  static const Color info = Color(0xFFFFFFFF);
  static const Color newPrimary = Color(0xFF57370d);
  static const Color newSecondary = Color(0xFFffe998);

  // Gradients
  static const LinearGradient cardGradient = LinearGradient(
    colors: [primaryBackground, secondaryBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text Styles
  static TextStyle get h1 => GoogleFonts.cairo(
        color: primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );

  static TextStyle get h2 => GoogleFonts.cairo(
        color: primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  static TextStyle get h3 => GoogleFonts.cairo(
        color: primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );

  static TextStyle get bodyText => GoogleFonts.cairo(
        color: primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );

  static TextStyle get smallText => GoogleFonts.cairo(
        color: secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12,
      );

  static TextStyle get tinyText => GoogleFonts.cairo(
        color: secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 10,
      );

  // Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get bentoContainerDecoration => BoxDecoration(
        color: accent4,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Input Decorations
  static InputDecoration searchInputDecoration({required String hintText}) =>
      InputDecoration(
        filled: true,
        fillColor: alternate,
        hintText: hintText,
        hintStyle: GoogleFonts.cairo(
          color: secondaryText.withOpacity(0.7),
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: secondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      );

  static InputDecoration textInputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) =>
      InputDecoration(
        filled: true,
        fillColor: alternate,
        hintText: hintText,
        hintStyle: GoogleFonts.cairo(
          color: secondaryText.withOpacity(0.7),
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: secondaryText,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: secondaryText.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: secondaryText.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: primary,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      );

  // Button Styles
  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primary),
    foregroundColor: MaterialStateProperty.all<Color>(secondaryBackground),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static ButtonStyle secondaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    foregroundColor: MaterialStateProperty.all<Color>(primary),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: primary, width: 1.5),
      ),
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static ButtonStyle textButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    foregroundColor: MaterialStateProperty.all<Color>(primaryText),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

/// Widget to display a status indicator
class StatusIndicator extends StatelessWidget {
  final RequestStatus status;

  const StatusIndicator({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: status.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          status.displayName,
          style: PartnerSearchStyles.smallText.copyWith(
            color: status.color,
          ),
        ),
      ],
    );
  }
}

/// Widget to display training type chip
class TrainingTypeChip extends StatelessWidget {
  final TrainingType type;
  final bool isSelected;
  final VoidCallback? onTap;

  const TrainingTypeChip({
    super.key,
    required this.type,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? type.color : PartnerSearchStyles.alternate,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: type.color),
        ),
        child: Text(
          type.displayName,
          style: PartnerSearchStyles.smallText.copyWith(
            color: isSelected
                ? PartnerSearchStyles.secondaryBackground
                : type.color,
          ),
        ),
      ),
    );
  }
}

/// Widget to display training time
class TrainingTimeDisplay extends StatelessWidget {
  final TimeOfDay time;
  final Color? color;

  const TrainingTimeDisplay({
    super.key,
    required this.time,
    this.color,
  });

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); // 6:00 AM
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: color ?? PartnerSearchStyles.secondaryText,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTimeOfDay(time),
          style: PartnerSearchStyles.smallText.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Widget to display a trainee card
class TraineeCard extends StatelessWidget {
  final AvailableTrainee trainee;
  final VoidCallback onTap;

  const TraineeCard({
    super.key,
    required this.trainee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: PartnerSearchStyles.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trainee info with image
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Profile image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        trainee.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: PartnerSearchStyles.accent1,
                          child: const Icon(
                            Icons.person,
                            color: PartnerSearchStyles.primaryText,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Trainee details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainee.name,
                          style: PartnerSearchStyles.h3,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 14,
                              color: PartnerSearchStyles.secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trainee.experienceLevel,
                              style: PartnerSearchStyles.smallText,
                            ),
                            const SizedBox(width: 8),
                            // Rating
                            Icon(
                              Icons.star,
                              size: 14,
                              color: PartnerSearchStyles.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trainee.rating.toString(),
                              style: PartnerSearchStyles.smallText,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Gym name
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: PartnerSearchStyles.secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                trainee.gymName,
                                style: PartnerSearchStyles.smallText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Training preferences
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تفضيلات التدريب',
                    style: PartnerSearchStyles.smallText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Training types
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trainee.preferredTrainingTypes
                        .map((type) => TrainingTypeChip(type: type))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  // Available times
                  Text(
                    'الأوقات المتاحة',
                    style: PartnerSearchStyles.smallText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trainee.availableTimes
                        .map(
                          (time) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: PartnerSearchStyles.accent1,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TrainingTimeDisplay(time: time),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display a training request card
class RequestCard extends StatelessWidget {
  final TrainingRequest request;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onViewDetails;

  const RequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onReject,
    this.onViewDetails,
  });

  String _formatDate(DateTime date) {
    return DateFormat('d MMM, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool showActions = request.status == RequestStatus.pending &&
        request.receiverId == 'current-user-id';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: PartnerSearchStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with request status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusIndicator(status: request.status),
                Text(
                  _formatDate(request.requestDate),
                  style: PartnerSearchStyles.smallText,
                ),
              ],
            ),
          ),
          // Divider
          const Divider(
            height: 1,
            thickness: 1,
            color: PartnerSearchStyles.secondaryBackground,
          ),
          // Request details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile image
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      request.senderId == 'current-user-id'
                          ? request.receiverImageUrl
                          : request.senderImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: PartnerSearchStyles.accent1,
                        child: const Icon(
                          Icons.person,
                          color: PartnerSearchStyles.primaryText,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Request content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.senderId == 'current-user-id'
                            ? request.receiverName
                            : request.senderName,
                        style: PartnerSearchStyles.h3,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          TrainingTypeChip(
                            type: request.trainingType,
                            isSelected: true,
                          ),
                          const SizedBox(width: 8),
                          TrainingTimeDisplay(
                            time: request.trainingTime,
                            color: PartnerSearchStyles.primaryText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Message
                      if (request.message.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: PartnerSearchStyles.accent4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            request.message,
                            style: PartnerSearchStyles.bodyText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          if (showActions)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PartnerSearchStyles.error,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: const Size(80, 36),
                    ),
                    child: Text(
                      'رفض',
                      style: PartnerSearchStyles.smallText.copyWith(
                        color: PartnerSearchStyles.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PartnerSearchStyles.success,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: const Size(80, 36),
                    ),
                    child: Text(
                      'قبول',
                      style: PartnerSearchStyles.smallText.copyWith(
                        color: PartnerSearchStyles.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onViewDetails,
                  style: PartnerSearchStyles.textButtonStyle,
                  child: Text(
                    'عرض التفاصيل',
                    style: PartnerSearchStyles.smallText.copyWith(
                      color: PartnerSearchStyles.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget to display an empty state
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: PartnerSearchStyles.secondaryText.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: PartnerSearchStyles.bodyText.copyWith(
                color: PartnerSearchStyles.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
