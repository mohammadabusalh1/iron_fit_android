import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/partner_search_models.dart';
import '../providers/partner_search_provider.dart';
import '../utils/partner_search_widgets.dart';
import 'activate_availability_screen.dart';
import 'partner_search_screen.dart';
import 'requests_management_screen.dart';

class PartnerSearchMainScreen extends StatefulWidget {
  const PartnerSearchMainScreen({super.key});

  @override
  State<PartnerSearchMainScreen> createState() =>
      _PartnerSearchMainScreenState();
}

class _PartnerSearchMainScreenState extends State<PartnerSearchMainScreen> {
  @override
  void initState() {
    super.initState();
    // Load mock data for demonstration
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PartnerSearchProvider>().loadMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Support for Arabic
      child: Scaffold(
        backgroundColor: PartnerSearchStyles.primaryBackground,
        appBar: AppBar(
          title: Text(
            'البحث عن شريك تدريب',
            style: PartnerSearchStyles.h1,
          ),
          backgroundColor: PartnerSearchStyles.secondaryBackground,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: PartnerSearchStyles.primaryText,
              ),
              onPressed: () {
                // Handle notifications
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.settings,
              color: PartnerSearchStyles.primaryText,
            ),
            onPressed: () {
              // Handle settings
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Availability Status Card
              _buildAvailabilityCard(),

              const SizedBox(height: 24),

              // Quick Search Section
              _buildQuickSearchSection(),

              const SizedBox(height: 24),

              // Recent Requests Section (Bento Grid)
              _buildRecentRequestsSection(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final provider = context.read<PartnerSearchProvider>();
            if (provider.isAvailable) {
              // Already available, navigate to create request screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: provider,
                    child: const PartnerSearchScreen(),
                  ),
                ),
              );
            } else {
              // Not available, navigate to activate availability screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivateAvailabilityScreen(),
                ),
              );
            }
          },
          backgroundColor: PartnerSearchStyles.primary,
          child: Icon(
            context.watch<PartnerSearchProvider>().isAvailable
                ? Icons.search
                : Icons.add,
            color: PartnerSearchStyles.secondaryBackground,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: PartnerSearchStyles.secondaryBackground,
          selectedItemColor: PartnerSearchStyles.primary,
          unselectedItemColor: PartnerSearchStyles.secondaryText,
          currentIndex: 2, // Partner search tab
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'التدريبات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'شركاء',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    final provider = context.watch<PartnerSearchProvider>();

    return Container(
      decoration: PartnerSearchStyles.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حالة التوفر',
                style: PartnerSearchStyles.h3,
              ),
              Switch(
                value: provider.isAvailable,
                onChanged: (value) {
                  if (value) {
                    // Navigate to activate availability screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ActivateAvailabilityScreen(),
                      ),
                    );
                  } else {
                    // Update availability to false
                    provider.updateAvailability(false);
                  }
                },
                activeColor: PartnerSearchStyles.primary,
                inactiveTrackColor: PartnerSearchStyles.alternate,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            provider.isAvailable ? 'متاح للتدريب' : 'غير متاح',
            style: PartnerSearchStyles.bodyText.copyWith(
              color: provider.isAvailable
                  ? PartnerSearchStyles.success
                  : PartnerSearchStyles.secondaryText,
            ),
          ),
          if (provider.isAvailable) ...[
            const SizedBox(height: 16),

            // Display preferred training types
            if (provider.preferredTrainingTypes.isNotEmpty) ...[
              Text(
                'تفضيلات التدريب:',
                style: PartnerSearchStyles.smallText.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: provider.preferredTrainingTypes
                    .map((type) =>
                        TrainingTypeChip(type: type, isSelected: true))
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Display available times
            if (provider.availableTimes.isNotEmpty) ...[
              Text(
                'الأوقات المتاحة:',
                style: PartnerSearchStyles.smallText.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: provider.availableTimes
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
              const SizedBox(height: 12),
            ],

            // Edit preferences button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ActivateAvailabilityScreen(),
                    ),
                  );
                },
                style: PartnerSearchStyles.textButtonStyle,
                child: Text(
                  'تعديل التفضيلات',
                  style: PartnerSearchStyles.smallText.copyWith(
                    color: PartnerSearchStyles.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البحث عن شريك',
          style: PartnerSearchStyles.h3,
        ),

        const SizedBox(height: 16),

        // Search field
        TextField(
          decoration: PartnerSearchStyles.searchInputDecoration(
            hintText: 'ابحث عن متدربين...',
          ),
          style: PartnerSearchStyles.bodyText,
          onTap: () {
            // Navigate to search screen when tapped
            final provider = context.read<PartnerSearchProvider>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: provider,
                  child: const PartnerSearchScreen(),
                ),
              ),
            );
          },
          readOnly: true, // Make it open the search screen instead
        ),

        const SizedBox(height: 16),

        // Quick filter buttons
        Row(
          children: [
            _buildQuickFilterButton(TrainingType.strength),
            const SizedBox(width: 8),
            _buildQuickFilterButton(TrainingType.fitness),
            const SizedBox(width: 8),
            _buildQuickFilterButton(TrainingType.cardio),
          ],
        ),

        const SizedBox(height: 16),

        // Advanced search button
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              final provider = context.read<PartnerSearchProvider>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: provider,
                    child: const PartnerSearchScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.tune,
              size: 18,
              color: PartnerSearchStyles.primary,
            ),
            label: Text(
              'بحث متقدم',
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

  Widget _buildQuickFilterButton(TrainingType type) {
    return ElevatedButton.icon(
      onPressed: () {
        // Set this type as the only filter and navigate to search
        final provider = context.read<PartnerSearchProvider>();
        provider.updateSelectedTrainingTypes([type]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: provider,
              child: const PartnerSearchScreen(),
            ),
          ),
        );
      },
      icon: Icon(
        _getIconForTrainingType(type),
        size: 18,
      ),
      label: Text(type.displayName),
      style: ElevatedButton.styleFrom(
        backgroundColor: type.color.withOpacity(0.2),
        foregroundColor: type.color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: PartnerSearchStyles.smallText.copyWith(
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    );
  }

  IconData _getIconForTrainingType(TrainingType type) {
    switch (type) {
      case TrainingType.strength:
        return Icons.fitness_center;
      case TrainingType.fitness:
        return Icons.directions_run;
      case TrainingType.cardio:
        return Icons.favorite;
      case TrainingType.yoga:
        return Icons.self_improvement;
    }
  }

  Widget _buildRecentRequestsSection() {
    final provider = context.watch<PartnerSearchProvider>();
    final recentRequests = provider.recentRequests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'طلباتك الحديثة',
              style: PartnerSearchStyles.h3,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestsManagementScreen(),
                  ),
                );
              },
              style: PartnerSearchStyles.textButtonStyle,
              child: Text(
                'عرض الكل',
                style: PartnerSearchStyles.smallText.copyWith(
                  color: PartnerSearchStyles.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentRequests.isEmpty)
          const EmptyStateWidget(
            message: 'لا توجد طلبات حديثة',
            icon: Icons.history,
          )
        else
          // Bento Grid for recent requests
          _buildBentoGrid(recentRequests),
      ],
    );
  }

  Widget _buildBentoGrid(List<TrainingRequest> requests) {
    // For simplicity in this implementation, we'll use a basic layout
    // In a real implementation, we would create a more complex Bento grid layout

    if (requests.length == 1) {
      // Only one request, show full width
      return RequestCard(
        request: requests[0],
        onViewDetails: () => _navigateToRequestDetails(requests[0]),
        onAccept: requests[0].status == RequestStatus.pending &&
                requests[0].receiverId == 'current-user-id'
            ? () => _respondToRequest(requests[0].id, RequestStatus.accepted)
            : null,
        onReject: requests[0].status == RequestStatus.pending &&
                requests[0].receiverId == 'current-user-id'
            ? () => _respondToRequest(requests[0].id, RequestStatus.rejected)
            : null,
      );
    }

    // Multiple requests, create a grid layout
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: requests.length > 4 ? 4 : requests.length,
      itemBuilder: (context, index) {
        return _buildBentoCard(requests[index]);
      },
    );
  }

  Widget _buildBentoCard(TrainingRequest request) {
    final isSender = request.senderId == 'current-user-id';
    final name = isSender ? request.receiverName : request.senderName;
    final imageUrl =
        isSender ? request.receiverImageUrl : request.senderImageUrl;

    return GestureDetector(
      onTap: () => _navigateToRequestDetails(request),
      child: Container(
        decoration: PartnerSearchStyles.bentoContainerDecoration,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            StatusIndicator(status: request.status),

            const SizedBox(height: 12),

            // Person image
            Center(
              child: Container(
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
                    imageUrl,
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
            ),

            const SizedBox(height: 12),

            // Name
            Text(
              name,
              style: PartnerSearchStyles.bodyText.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Training type and time
            Row(
              children: [
                Icon(
                  _getIconForTrainingType(request.trainingType),
                  size: 14,
                  color: request.trainingType.color,
                ),
                const SizedBox(width: 4),
                Text(
                  request.trainingType.displayName,
                  style: PartnerSearchStyles.tinyText.copyWith(
                    color: request.trainingType.color,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Time
            TrainingTimeDisplay(time: request.trainingTime),
          ],
        ),
      ),
    );
  }

  void _navigateToRequestDetails(TrainingRequest request) {
    // Navigate to request details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RequestsManagementScreen(),
      ),
    );
  }

  void _respondToRequest(String requestId, RequestStatus status) {
    final provider = context.read<PartnerSearchProvider>();
    provider.respondToRequest(requestId, status);
  }
}
