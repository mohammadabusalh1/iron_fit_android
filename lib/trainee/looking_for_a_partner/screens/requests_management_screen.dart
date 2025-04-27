import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart' as flutter_ui show TextDirection;
import '../models/partner_search_models.dart';
import '../providers/partner_search_provider.dart';
import '../utils/partner_search_widgets.dart';

class RequestsManagementScreen extends StatefulWidget {
  const RequestsManagementScreen({super.key});

  @override
  State<RequestsManagementScreen> createState() =>
      _RequestsManagementScreenState();
}

class _RequestsManagementScreenState extends State<RequestsManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: flutter_ui.TextDirection.rtl, // Support for Arabic
      child: ChangeNotifierProvider(
        create: (_) => PartnerSearchProvider(),
        child: Scaffold(
          backgroundColor: PartnerSearchStyles.primaryBackground,
          appBar: AppBar(
            title: Text(
              'إدارة الطلبات',
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
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: PartnerSearchStyles.primary,
              labelColor: PartnerSearchStyles.primaryText,
              unselectedLabelColor: PartnerSearchStyles.secondaryText,
              labelStyle: PartnerSearchStyles.bodyText.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: PartnerSearchStyles.bodyText,
              tabs: const [
                Tab(text: 'معلق'),
                Tab(text: 'مقبول'),
                Tab(text: 'مرفوض'),
                Tab(text: 'مكتمل'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildRequestsList(RequestStatus.pending),
              _buildRequestsList(RequestStatus.accepted),
              _buildRequestsList(RequestStatus.rejected),
              _buildRequestsList(RequestStatus.completed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsList(RequestStatus status) {
    return Consumer<PartnerSearchProvider>(
      builder: (context, provider, _) {
        final requests = provider.getRequestsByStatus(status);

        if (requests.isEmpty) {
          return _buildEmptyState(status);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return RequestCard(
              request: requests[index],
              onViewDetails: () => _showRequestDetails(requests[index]),
              onAccept: status == RequestStatus.pending &&
                      requests[index].receiverId == 'current-user-id'
                  ? () => _respondToRequest(
                      requests[index].id, RequestStatus.accepted)
                  : null,
              onReject: status == RequestStatus.pending &&
                      requests[index].receiverId == 'current-user-id'
                  ? () => _respondToRequest(
                      requests[index].id, RequestStatus.rejected)
                  : null,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(RequestStatus status) {
    String message;
    IconData icon;

    switch (status) {
      case RequestStatus.pending:
        message = 'لا توجد طلبات معلقة';
        icon = Icons.hourglass_empty;
        break;
      case RequestStatus.accepted:
        message = 'لا توجد طلبات مقبولة';
        icon = Icons.check_circle_outline;
        break;
      case RequestStatus.rejected:
        message = 'لا توجد طلبات مرفوضة';
        icon = Icons.cancel_outlined;
        break;
      case RequestStatus.completed:
        message = 'لا توجد طلبات مكتملة';
        icon = Icons.done_all;
        break;
    }

    return EmptyStateWidget(
      message: message,
      icon: icon,
    );
  }

  void _respondToRequest(String requestId, RequestStatus newStatus) {
    final provider = context.read<PartnerSearchProvider>();
    provider.respondToRequest(requestId, newStatus);

    // Show success message
    String message = newStatus == RequestStatus.accepted
        ? 'تم قبول الطلب بنجاح'
        : 'تم رفض الطلب بنجاح';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: newStatus == RequestStatus.accepted
            ? PartnerSearchStyles.success
            : PartnerSearchStyles.error,
      ),
    );
  }

  void _showRequestDetails(TrainingRequest request) {
    showModalBottomSheet(
      context: context,
      backgroundColor: PartnerSearchStyles.secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => _buildRequestDetailsSheet(request),
    );
  }

  Widget _buildRequestDetailsSheet(TrainingRequest request) {
    final isSender = request.senderId == 'current-user-id';
    final name = isSender ? request.receiverName : request.senderName;
    final imageUrl =
        isSender ? request.receiverImageUrl : request.senderImageUrl;

    // Format dates
    final dateFormat = DateFormat('d MMMM, y - hh:mm a');
    final requestDate = dateFormat.format(request.requestDate);
    final responseDate = request.responseDate != null
        ? dateFormat.format(request.responseDate!)
        : null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: PartnerSearchStyles.h3,
                    ),
                    const SizedBox(height: 4),
                    StatusIndicator(status: request.status),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Request details
          Text(
            'تفاصيل الطلب',
            style: PartnerSearchStyles.h3,
          ),
          const SizedBox(height: 16),
          // Request date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: PartnerSearchStyles.secondaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تاريخ الطلب: $requestDate',
                  style: PartnerSearchStyles.bodyText,
                ),
              ),
            ],
          ),

          // Response date if available
          if (responseDate != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  request.status == RequestStatus.accepted
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: request.status.color,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تاريخ الرد: $responseDate',
                    style: PartnerSearchStyles.bodyText,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),
          // Training type
          Row(
            children: [
              Icon(
                _getIconForTrainingType(request.trainingType),
                color: request.trainingType.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'نوع التدريب: ${request.trainingType.displayName}',
                style: PartnerSearchStyles.bodyText,
              ),
            ],
          ),

          const SizedBox(height: 8),
          // Training time
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: PartnerSearchStyles.secondaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'وقت التدريب: ${_formatTimeOfDay(request.trainingTime)}',
                style: PartnerSearchStyles.bodyText,
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Message
          Text(
            'الرسالة:',
            style: PartnerSearchStyles.bodyText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
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

          const SizedBox(height: 24),

          // Action buttons if pending and the user is receiver
          if (request.status == RequestStatus.pending &&
              request.receiverId == 'current-user-id') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _respondToRequest(request.id, RequestStatus.rejected);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PartnerSearchStyles.error,
                    ),
                    child: const Text('رفض'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _respondToRequest(request.id, RequestStatus.accepted);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PartnerSearchStyles.success,
                    ),
                    child: const Text('قبول'),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: PartnerSearchStyles.primaryButtonStyle,
                child: const Text('إغلاق'),
              ),
            ),
          ],
        ],
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

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); // 6:00 AM
    return format.format(dt);
  }
}
