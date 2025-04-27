import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/partner_search_models.dart';
import '../providers/partner_search_provider.dart';
import '../utils/partner_search_widgets.dart';
import 'trainee_profile_screen.dart';

class PartnerSearchScreen extends StatefulWidget {
  const PartnerSearchScreen({super.key});

  @override
  State<PartnerSearchScreen> createState() => _PartnerSearchScreenState();
}

class _PartnerSearchScreenState extends State<PartnerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize with current search query if any
    final provider = context.read<PartnerSearchProvider>();
    _searchController.text = provider.searchQuery;

    // Add listener to update search query in provider
    _searchController.addListener(() {
      provider.updateSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Support for Arabic
      child: Scaffold(
        backgroundColor: PartnerSearchStyles.primaryBackground,
        appBar: AppBar(
          title: Text(
            'البحث عن شركاء',
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
        body: Column(
          children: [
            // Search and filter bar
            _buildSearchBar(),

            // Filter chips
            _buildFilterChips(),

            // Results count
            _buildResultsCount(),

            // Results list
            _buildResultsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: PartnerSearchStyles.secondaryBackground,
      child: TextField(
        controller: _searchController,
        decoration: PartnerSearchStyles.searchInputDecoration(
          hintText: 'ابحث عن متدربين...',
        ),
        style: PartnerSearchStyles.bodyText,
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<TrainingType> allTypes = [
      TrainingType.strength,
      TrainingType.fitness,
      TrainingType.cardio,
      TrainingType.yoga,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: PartnerSearchStyles.secondaryBackground,
      child: Row(
        children: [
          Text(
            'تصفية حسب:',
            style: PartnerSearchStyles.smallText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: allTypes.map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Consumer<PartnerSearchProvider>(
                      builder: (context, provider, _) {
                        final isSelected =
                            provider.selectedTrainingTypes.contains(type);
                        return TrainingTypeChip(
                          type: type,
                          isSelected: isSelected,
                          onTap: () => provider.toggleTrainingTypeFilter(type),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCount() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerRight,
      child: Consumer<PartnerSearchProvider>(
        builder: (context, provider, _) {
          final resultsCount = provider.filteredTrainees.length;
          return Text(
            'تم العثور على $resultsCount متدرب',
            style: PartnerSearchStyles.smallText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList() {
    return Expanded(
      child: Consumer<PartnerSearchProvider>(
        builder: (context, provider, _) {
          final trainees = provider.filteredTrainees;

          if (trainees.isEmpty) {
            return const EmptyStateWidget(
              message: 'لم يتم العثور على متدربين مطابقين للبحث',
              icon: Icons.search_off,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trainees.length,
            itemBuilder: (context, index) {
              return TraineeCard(
                trainee: trainees[index],
                onTap: () => _navigateToTraineeProfile(trainees[index]),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToTraineeProfile(AvailableTrainee trainee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TraineeProfileScreen(trainee: trainee),
      ),
    );
  }
}
