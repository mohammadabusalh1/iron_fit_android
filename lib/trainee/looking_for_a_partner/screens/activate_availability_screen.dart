import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/painting.dart' as flutter_ui show TextDirection;
import '../models/partner_search_models.dart';
import '../providers/partner_search_provider.dart';
import '../utils/partner_search_widgets.dart';

class ActivateAvailabilityScreen extends StatefulWidget {
  const ActivateAvailabilityScreen({super.key});

  @override
  State<ActivateAvailabilityScreen> createState() =>
      _ActivateAvailabilityScreenState();
}

class _ActivateAvailabilityScreenState
    extends State<ActivateAvailabilityScreen> {
  final List<TrainingType> _allTrainingTypes = [
    TrainingType.strength,
    TrainingType.fitness,
    TrainingType.cardio,
    TrainingType.yoga,
  ];

  final List<TimeOfDay> _commonTimes = [
    const TimeOfDay(hour: 6, minute: 0),
    const TimeOfDay(hour: 7, minute: 0),
    const TimeOfDay(hour: 8, minute: 0),
    const TimeOfDay(hour: 17, minute: 0),
    const TimeOfDay(hour: 18, minute: 0),
    const TimeOfDay(hour: 19, minute: 0),
    const TimeOfDay(hour: 20, minute: 0),
  ];

  List<TrainingType> _selectedTrainingTypes = [];
  List<TimeOfDay> _selectedTimes = [];
  final TextEditingController _notesController = TextEditingController();
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: flutter_ui.TextDirection.rtl, // Support for Arabic
      child: Scaffold(
        backgroundColor: PartnerSearchStyles.primaryBackground,
        appBar: AppBar(
          title: Text(
            'تفعيل التوفر',
            style: PartnerSearchStyles.h1,
          ),
          backgroundColor: PartnerSearchStyles.secondaryBackground,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: PartnerSearchStyles.primaryText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Availability toggle
              _buildAvailabilityToggle(),

              const SizedBox(height: 24),

              // Training types section
              _buildTrainingTypesSection(),

              const SizedBox(height: 24),

              // Available times section
              _buildAvailableTimesSection(),

              const SizedBox(height: 24),

              // Additional notes section
              _buildAdditionalNotesSection(),

              const SizedBox(height: 32),

              // Save button
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: PartnerSearchStyles.primaryButtonStyle,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    child: Text('حفظ التفضيلات'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailabilityToggle() {
    return Container(
      decoration: PartnerSearchStyles.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'متاح للتدريب',
                style: PartnerSearchStyles.h3,
              ),
              const SizedBox(height: 4),
              Text(
                'الظهور للمتدربين الآخرين',
                style: PartnerSearchStyles.smallText,
              ),
            ],
          ),
          Switch(
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value;
              });
            },
            activeColor: PartnerSearchStyles.primary,
            inactiveTrackColor: PartnerSearchStyles.alternate,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفضيلات التدريب',
          style: PartnerSearchStyles.h3,
        ),
        const SizedBox(height: 8),
        Text(
          'اختر أنواع التدريب التي تفضلها',
          style: PartnerSearchStyles.smallText,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allTrainingTypes.map((type) {
            final isSelected = _selectedTrainingTypes.contains(type);
            return TrainingTypeChip(
              type: type,
              isSelected: isSelected,
              onTap: () => _toggleTrainingType(type),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailableTimesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأوقات المتاحة',
          style: PartnerSearchStyles.h3,
        ),
        const SizedBox(height: 8),
        Text(
          'اختر الأوقات التي تكون متاحاً فيها للتدريب',
          style: PartnerSearchStyles.smallText,
        ),
        const SizedBox(height: 16),
        // Common times chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonTimes.map((time) {
            final isSelected = _isTimeSelected(time);
            return GestureDetector(
              onTap: () => _toggleTime(time),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? PartnerSearchStyles.accent1
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
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
        // Custom time button
        Center(
          child: TextButton.icon(
            onPressed: _showTimePicker,
            icon: const Icon(
              Icons.add_circle_outline,
              size: 16,
              color: PartnerSearchStyles.primary,
            ),
            label: Text(
              'إضافة وقت مخصص',
              style: PartnerSearchStyles.smallText.copyWith(
                color: PartnerSearchStyles.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: PartnerSearchStyles.textButtonStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملاحظات إضافية',
          style: PartnerSearchStyles.h3,
        ),
        const SizedBox(height: 8),
        Text(
          'أضف أي ملاحظات ترغب في مشاركتها مع شركاء التدريب المحتملين',
          style: PartnerSearchStyles.smallText,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          style: PartnerSearchStyles.bodyText,
          maxLines: 4,
          decoration: PartnerSearchStyles.textInputDecoration(
            hintText: 'اكتب ملاحظاتك هنا...',
          ),
        ),
      ],
    );
  }

  void _toggleTrainingType(TrainingType type) {
    setState(() {
      if (_selectedTrainingTypes.contains(type)) {
        _selectedTrainingTypes.remove(type);
      } else {
        _selectedTrainingTypes.add(type);
      }
    });
  }

  bool _isTimeSelected(TimeOfDay time) {
    return _selectedTimes
        .any((t) => t.hour == time.hour && t.minute == time.minute);
  }

  void _toggleTime(TimeOfDay time) {
    setState(() {
      if (_isTimeSelected(time)) {
        _selectedTimes
            .removeWhere((t) => t.hour == time.hour && t.minute == time.minute);
      } else {
        _selectedTimes.add(time);
      }
    });
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: PartnerSearchStyles.primary,
              onPrimary: PartnerSearchStyles.secondaryBackground,
              surface: PartnerSearchStyles.primaryBackground,
              onSurface: PartnerSearchStyles.primaryText,
            ),
            dialogBackgroundColor: PartnerSearchStyles.primaryBackground,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && !_isTimeSelected(picked)) {
      setState(() {
        _selectedTimes.add(picked);
      });
    }
  }

  void _saveSettings() {
    if (_isAvailable && _selectedTrainingTypes.isEmpty) {
      // Show validation error for training types
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى اختيار نوع تدريب واحد على الأقل',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: PartnerSearchStyles.error,
        ),
      );
      return;
    }

    if (_isAvailable && _selectedTimes.isEmpty) {
      // Show validation error for times
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى اختيار وقت متاح واحد على الأقل',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: PartnerSearchStyles.error,
        ),
      );
      return;
    }

    // Save settings to provider
    final provider = context.read<PartnerSearchProvider>();
    provider.updateAvailability(_isAvailable);
    provider.updatePreferredTrainingTypes(_selectedTrainingTypes);
    provider.updateAvailableTimes(_selectedTimes);
    provider.updateAdditionalNotes(_notesController.text);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم حفظ تفضيلاتك بنجاح',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: PartnerSearchStyles.success,
      ),
    );

    // Go back to previous screen
    Navigator.pop(context);
  }
}
