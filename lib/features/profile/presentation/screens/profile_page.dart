import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/widgets/app_bar.dart';
import '../../../../common/theme/app_colors.dart';
import '../../domain/services/profile_service.dart';
import '../providers/profile_provider.dart';
import '../widgets/store_image_card.dart';
import '../widgets/bank_details_section.dart';
import '../widgets/profile_section.dart';
import '../widgets/info_row.dart';
import '../widgets/day_chip.dart';
import '../widgets/contact_row.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Initialize with dummy data for now
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().initializeWithDummyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (profileProvider.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${profileProvider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileProvider.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final store = profileProvider.store;
        if (store == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('No store data available')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(
            title: 'Store Details',
            showBackButton: true,
            showProfile: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Image Card
                StoreImageCard(
                  onEdit: _editStoreImage,
                  onDelete: _deleteStoreImage,
                ),
                const SizedBox(height: 16),
                
                // Basic Information Section
                _buildBasicInformation(store),
                const SizedBox(height: 16),
                
                // Bank Details Section
                BankDetailsSection(
                  bankDetails: profileProvider.bankDetails,
                  selectedBankIndex: profileProvider.selectedBankIndex,
                  onBankSelected: profileProvider.selectBank,
                  onAddBank: _addNewBank,
                  onEditBank: _editBankDetails,
                ),
                const SizedBox(height: 16),
                
                // Opening Hours Section
                _buildOpeningHours(store),
                const SizedBox(height: 16),
                
                // Contact Information Section
                _buildContactInformation(store),
                const SizedBox(height: 16),
                
                // Description Section
                _buildDescription(store),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBasicInformation(store) {
    return ProfileSection(
      title: 'Basic Information',
      onEdit: _editBasicInformation,
      children: [
        Row(
          children: [
            Expanded(
              child: InfoRow(
                icon: Icons.store,
                title: 'Brand Name',
                value: store.brandName,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InfoRow(
                icon: Icons.business,
                title: 'Business Type',
                value: store.businessType,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoRow(
                icon: Icons.person,
                title: 'Contact Person',
                value: store.fullName,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InfoRow(
                icon: Icons.restaurant,
                title: 'Cuisine Type',
                value: store.cuisineType,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InfoRow(
                icon: Icons.location_city,
                title: 'Neighbourhood',
                value: store.neighbourhood,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InfoRow(
                icon: Icons.store_mall_directory,
                title: 'Store Name',
                value: store.storeName,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOpeningHours(store) {
    return ProfileSection(
      title: 'Opening Hours',
      onEdit: _editOpeningHours,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            store.operatingHours,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ProfileService.getAllDays().map((day) => 
            DayChip(
              day: day, 
              isOpen: ProfileService.isDayOperating(store.operatingDays, day),
            )
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildContactInformation(store) {
    return ProfileSection(
      title: 'Contact Information',
      onEdit: _editContactInformation,
      children: [
        ContactRow(icon: Icons.phone, text: store.contactNumber),
        const SizedBox(height: 12),
        ContactRow(icon: Icons.email, text: store.email),
        const SizedBox(height: 12),
        ContactRow(icon: Icons.language, text: store.websiteUrl ?? 'Not provided'),
        const SizedBox(height: 12),
        ContactRow(icon: Icons.location_on, text: store.address.fullAddress),
      ],
    );
  }

  Widget _buildDescription(store) {
    return ProfileSection(
      title: 'Description',
      onEdit: _editDescription,
      children: [
        Text(
          store.description ?? 'No description available',
          style: TextStyle(
            color: store.description != null ? Colors.black87 : Colors.black54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Action methods
  void _editStoreImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit store image functionality')),
    );
  }

  void _deleteStoreImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete store image functionality')),
    );
  }

  void _addNewBank() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new bank functionality')),
    );
  }

  void _editBankDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit bank details functionality')),
    );
  }

  void _editBasicInformation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit basic information functionality')),
    );
  }

  void _editOpeningHours() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit opening hours functionality')),
    );
  }

  void _editContactInformation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit contact information functionality')),
    );
  }

  void _editDescription() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit description functionality')),
    );
  }
}