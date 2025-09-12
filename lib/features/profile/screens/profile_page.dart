// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../common/widgets/app_bar.dart';
import '../../../common/theme/app_colors.dart';
import '../constants/dummy_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedBankIndex = 0;
  
  // Get bank details from dummy data
  List<Map<String, dynamic>> get banks {
    return DummyData.bankDetails.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildStoreImageCard(),
            const SizedBox(height: 16),
            
            // Basic Information Section
            _buildBasicInformation(),
            const SizedBox(height: 16),
            
            // Enhanced Bank Details Section
            _buildEnhancedBankDetails(),
            const SizedBox(height: 16),
            
            // Opening Hours Section
            _buildOpeningHours(),
            const SizedBox(height: 16),
            
            // Contact Information Section
            _buildContactInformation(),
            const SizedBox(height: 16),
            
            // Description Section
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedBankDetails() {
    if (banks.isEmpty) {
      return _buildEmptyBankState();
    }

    final currentBank = banks[selectedBankIndex];
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title, primary badge, dropdown, and action buttons
            Row(
              children: [
                // Title
                const Text(
                  'Bank Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                // Primary badge
                if (currentBank['isPrimary'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Primary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Spacer(),
                // Add new bank button
                GestureDetector(
                  onTap: _addNewBank,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Edit button
                GestureDetector(
                  onTap: _editBankDetails,
                  child: Icon(
                    Icons.edit,
                    color: Colors.black54,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Bank selection dropdown (if more than 1 bank)
            if (banks.length > 1) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedBankIndex,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                    items: banks.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> bank = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Row(
                          children: [
                            Text(
                              bank['bankName'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            if (bank['isPrimary'])
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Primary',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          selectedBankIndex = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Divider
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            
            // Bank details content
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Bank Name', currentBank['bankName']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem('Account Holder', currentBank['accountHolder']),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Account Number', 
                    DummyData.maskAccountNumber(currentBank['accountNumber'])
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem('IFSC Code', currentBank['ifscCode']),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('SWIFT Code', currentBank['swiftCode']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem(
                    'IBAN Code', 
                    DummyData.maskIban(currentBank['iban'])
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBankState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bank Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: _addNewBank,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No bank details added',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _addNewBank,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Bank Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addNewBank() {
    // Implement add new bank functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new bank functionality')),
    );
  }

  void _editBankDetails() {
    // Implement edit bank details functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit bank details functionality')),
    );
  }

  Widget _buildStoreImageCard() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInformation() {
    return _buildSection(
      title: 'Basic Information',
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoRow(
                icon: Icons.store,
                title: 'Brand Name',
                value: DummyData.store['brandName'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoRow(
                icon: Icons.business,
                title: 'Business Type',
                value: DummyData.store['businessType'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoRow(
                icon: Icons.person,
                title: 'Contact Person',
                value: DummyData.fullName,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoRow(
                icon: Icons.restaurant,
                title: 'Cuisine Type',
                value: DummyData.store['cuisineType'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoRow(
                icon: Icons.location_city,
                title: 'Neighbourhood',
                value: DummyData.store['neighbourhood'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoRow(
                icon: Icons.store_mall_directory,
                title: 'Store Name',
                value: DummyData.store['storeName'],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOpeningHours() {
    return _buildSection(
      title: 'Opening Hours',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            DummyData.operatingHours,
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
          children: DummyData.allDays.map((day) => 
            _buildDayChip(day, DummyData.isDayOperating(day))
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildContactInformation() {
    return _buildSection(
      title: 'Contact Information',
      children: [
        _buildContactRow(Icons.phone, DummyData.store['contactNumber']),
        const SizedBox(height: 12),
        _buildContactRow(Icons.email, DummyData.store['email']),
        const SizedBox(height: 12),
        _buildContactRow(Icons.language, DummyData.store['websiteUrl']),
        const SizedBox(height: 12),
        _buildContactRow(Icons.location_on, DummyData.fullAddress),
      ],
    );
  }

  Widget _buildDescription() {
    final description = DummyData.store['description'];
    return _buildSection(
      title: 'Description',
      children: [
        Text(
          description ?? 'No description available',
          style: TextStyle(
            color: description != null ? Colors.black87 : Colors.black54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: Colors.black54,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black54, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDayChip(String day, bool isOpen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: isOpen ? Colors.green.shade300 : Colors.red.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isOpen 
        ? Text(
            day,
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Text(
                day,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 1,
                    width: day.length * 6.0,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black54, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}