import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/partner_search_models.dart';
import '../providers/partner_search_provider.dart';
import '../utils/partner_search_widgets.dart';
import 'package:flutter/painting.dart' as flutter_ui show TextDirection;

class TraineeProfileScreen extends StatefulWidget {
  final AvailableTrainee trainee;

  const TraineeProfileScreen({
    super.key,
    required this.trainee,
  });

  @override
  State<TraineeProfileScreen> createState() => _TraineeProfileScreenState();
}

class _TraineeProfileScreenState extends State<TraineeProfileScreen> {
  TrainingType? _selectedTrainingType;
  TimeOfDay? _selectedTime;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default training type if the trainee has preferences
    if (widget.trainee.preferredTrainingTypes.isNotEmpty) {
      _selectedTrainingType = widget.trainee.preferredTrainingTypes.first;
    }

    // Set default time if the trainee has available times
    if (widget.trainee.availableTimes.isNotEmpty) {
      _selectedTime = widget.trainee.availableTimes.first;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: flutter_ui.TextDirection.rtl, // Support for Arabic
      child: Scaffold(
        backgroundColor: PartnerSearchStyles.primaryBackground,
        body: CustomScrollView(
          slivers: [
            // App bar with trainee image
            _buildSliverAppBar(),

            // Trainee profile content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trainee info section
                    _buildTraineeInfoSection(),

                    const SizedBox(height: 24),

                    // Training preferences section
                    _buildTrainingPreferencesSection(),

                    const SizedBox(height: 24),

                    // Available times section
                    _buildAvailableTimesSection(),

                    const SizedBox(height: 24),

                    // Request form section
                    _buildRequestFormSection(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildSendRequestButton(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: PartnerSearchStyles.secondaryBackground,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: PartnerSearchStyles.primaryText,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.darken,
          child: Image.network(
            widget.trainee.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: PartnerSearchStyles.accent1,
              child: const Icon(
                Icons.person,
                color: PartnerSearchStyles.primaryText,
                size: 80,
              ),
            ),
          ),
        ),
        title: Text(
          widget.trainee.name,
          style: PartnerSearchStyles.h1,
        ),
        titlePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  Widget _buildTraineeInfoSection() {
    return Container(
      decoration: PartnerSearchStyles.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات المتدرب',
            style: PartnerSearchStyles.h3,
          ),
          const SizedBox(height: 16),
          // Experience level
          Row(
            children: [
              const Icon(
                Icons.fitness_center,
                color: PartnerSearchStyles.secondaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'المستوى: ${widget.trainee.experienceLevel}',
                style: PartnerSearchStyles.bodyText,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Gym
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: PartnerSearchStyles.secondaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'الصالة الرياضية: ${widget.trainee.gymName}',
                  style: PartnerSearchStyles.bodyText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Location
          Row(
            children: [
              const Icon(
                Icons.map,
                color: PartnerSearchStyles.secondaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'المدينة: ${widget.trainee.location}',
                style: PartnerSearchStyles.bodyText,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Rating
          Row(
            children: [
              const Icon(
                Icons.star,
                color: PartnerSearchStyles.warning,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'التقييم: ${widget.trainee.rating}',
                style: PartnerSearchStyles.bodyText,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bio
          Text(
            'نبذة شخصية:',
            style: PartnerSearchStyles.bodyText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.trainee.bio,
            style: PartnerSearchStyles.bodyText,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingPreferencesSection() {
    return Container(
      decoration: PartnerSearchStyles.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفضيلات التدريب',
            style: PartnerSearchStyles.h3,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.trainee.preferredTrainingTypes
                .map((type) => TrainingTypeChip(type: type, isSelected: true))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableTimesSection() {
    return Container(
      decoration: PartnerSearchStyles.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأوقات المتاحة',
            style: PartnerSearchStyles.h3,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.trainee.availableTimes
                .map(
                  (time) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
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
    );
  }

  Widget _buildRequestFormSection() {
    return Container(
      decoration: PartnerSearchStyles.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إرسال طلب تدريب مشترك',
            style: PartnerSearchStyles.h3,
          ),
          const SizedBox(height: 16),
          // Training type selector
          Text(
            'نوع التدريب',
            style: PartnerSearchStyles.bodyText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.trainee.preferredTrainingTypes.map((type) {
              final isSelected = _selectedTrainingType == type;
              return TrainingTypeChip(
                type: type,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedTrainingType = type),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Training time selector
          Text(
            'وقت التدريب',
            style: PartnerSearchStyles.bodyText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.trainee.availableTimes.map((time) {
              final isSelected = _selectedTime != null &&
                  _selectedTime!.hour == time.hour &&
                  _selectedTime!.minute == time.minute;
              return GestureDetector(
                onTap: () => setState(() => _selectedTime = time),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? PartnerSearchStyles.accent1
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? PartnerSearchStyles.accent1
                          : PartnerSearchStyles.secondaryText,
                    ),
                  ),
                  child: TrainingTimeDisplay(
                    time: time,
                    color: isSelected
                        ? PartnerSearchStyles.primaryText
                        : PartnerSearchStyles.secondaryText,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Message field
          Text(
            'رسالة إلى المتدرب',
            style: PartnerSearchStyles.bodyText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            style: PartnerSearchStyles.bodyText,
            maxLines: 3,
            decoration: PartnerSearchStyles.textInputDecoration(
              hintText:
                  'اكتب رسالة توضح فيها سبب رغبتك في التدريب مع هذا المتدرب...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendRequestButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: PartnerSearchStyles.secondaryBackground,
      child: ElevatedButton(
        onPressed: _validateAndSendRequest,
        style: PartnerSearchStyles.primaryButtonStyle,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('إرسال الطلب'),
        ),
      ),
    );
  }

  void _validateAndSendRequest() {
    // Validate form
    if (_selectedTrainingType == null) {
      _showErrorMessage('يرجى اختيار نوع التدريب');
      return;
    }

    if (_selectedTime == null) {
      _showErrorMessage('يرجى اختيار وقت التدريب');
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      _showErrorMessage('يرجى كتابة رسالة للمتدرب');
      return;
    }

    // Send request
    final provider = context.read<PartnerSearchProvider>();
    provider.sendTrainingRequest(
      receiverId: widget.trainee.id,
      receiverName: widget.trainee.name,
      receiverImageUrl: widget.trainee.imageUrl,
      trainingType: _selectedTrainingType!,
      trainingTime: _selectedTime!,
      message: _messageController.text.trim(),
    );

    // Show success message
    _showSuccessMessage();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: PartnerSearchStyles.error,
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إرسال الطلب إلى ${widget.trainee.name} بنجاح',
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: PartnerSearchStyles.success,
      ),
    );

    // Close the screen after sending the request
    Navigator.pop(context);
  }
}
