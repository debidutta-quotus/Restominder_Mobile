// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../common/widgets/app_bar.dart';
import '../../../common/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Image Card
            _buildStoreImageCard(),
            const SizedBox(height: 24),
            
            // Basic Information Section
            _buildBasicInformation(),
            const SizedBox(height: 24),
            
            // Bank Details Section
            _buildBankDetails(),
            const SizedBox(height: 24),
            
            // Opening Hours Section
            _buildOpeningHours(),
            const SizedBox(height: 24),
            
            // Contact Information Section
            _buildContactInformation(),
            const SizedBox(height: 24),
            
            // Description Section
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreImageCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Store shelves image
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
            // Gradient overlay
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
            // Action buttons
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "edit",
                    mini: true,
                    backgroundColor: Colors.blue,
                    onPressed: () {},
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: "delete",
                    mini: true,
                    backgroundColor: Colors.red,
                    onPressed: () {},
                    child: const Icon(Icons.delete, color: Colors.white, size: 18),
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
        _buildInfoRow(
          icon: Icons.store,
          title: 'Brand Name',
          value: 'Daily average: 115',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          icon: Icons.business,
          title: 'Business Type',
          value: 'Daily average: 115',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          icon: Icons.person,
          title: 'Contact Person',
          value: 'Daily average: 115',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          icon: Icons.restaurant,
          title: 'Cuisine Type',
          value: 'Daily average: 115',
        ),
      ],
    );
  }

  Widget _buildBankDetails() {
    return _buildSection(
      title: 'Bank Details',
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem('Bank Name', 'Azure Financial'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailItem('Account Holder', 'John Doe'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem('Account Number', '1234567890'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailItem('IFSC Code', 'HDFC0000001'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem('SWIFT Code', 'HDFC0000001'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailItem('ISAN Code', 'HDFC0000001'),
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
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            '1:21 AM - 2:24 PM',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildDayChip('Monday', true),
            _buildDayChip('Tuesday', true),
            _buildDayChip('Wednesday', true),
            _buildDayChip('Thursday', true),
            _buildDayChip('Friday', true),
            _buildDayChip('Saturday', false),
            _buildDayChip('Sunday', false),
          ],
        ),
      ],
    );
  }

  Widget _buildContactInformation() {
    return _buildSection(
      title: 'Contact Information',
      children: [
        _buildContactRow(Icons.phone, '+00 1234 5678'),
        const SizedBox(height: 12),
        _buildContactRow(Icons.email, 'johndoe@gmail.com'),
        const SizedBox(height: 12),
        _buildContactRow(Icons.web, 'www.restrominder.com'),
        const SizedBox(height: 12),
        _buildContactRow(Icons.location_on, '154 Warstone Ln Birmingham, West Midlands'),
      ],
    );
  }

  Widget _buildDescription() {
    return _buildSection(
      title: 'Description',
      children: [
        const Text(
          'No description available',
          style: TextStyle(
            color: Colors.black54,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: Colors.black54,
                  size: 20,
                ),
              ],
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
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
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
            fontSize: 14,
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
        ),
      ],
    );
  }

  Widget _buildDayChip(String day, bool isOpen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: isOpen ? Colors.green : Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: isOpen ? Colors.green : Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 18),
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