// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/services/profile_service.dart';

class BankDetailsSection extends StatelessWidget {
  final List<BankDetailsEntity> bankDetails;
  final int selectedBankIndex;
  final Function(int) onBankSelected;
  final VoidCallback? onAddBank;
  final VoidCallback? onEditBank;

  const BankDetailsSection({
    super.key,
    required this.bankDetails,
    required this.selectedBankIndex,
    required this.onBankSelected,
    this.onAddBank,
    this.onEditBank,
  });

  @override
  Widget build(BuildContext context) {
    if (bankDetails.isEmpty) {
      return _buildEmptyBankState();
    }

    final currentBank = bankDetails[selectedBankIndex];
    
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
            // Header with title, primary badge, and action buttons
            Row(
              children: [
                const Text(
                  'Bank Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                if (currentBank.isPrimary)
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
                if (onAddBank != null)
                  GestureDetector(
                    onTap: onAddBank,
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
                if (onEditBank != null)
                  GestureDetector(
                    onTap: onEditBank,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black54,
                      size: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Bank selection dropdown (if more than 1 bank)
            if (bankDetails.length > 1) ...[
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
                    items: bankDetails.asMap().entries.map((entry) {
                      int index = entry.key;
                      BankDetailsEntity bank = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Row(
                          children: [
                            Text(
                              bank.bankName,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            if (bank.isPrimary)
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
                        onBankSelected(value);
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
                  child: _buildDetailItem('Bank Name', currentBank.bankName),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem('Account Holder', currentBank.accountHolder),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Account Number', 
                    ProfileService.maskAccountNumber(currentBank.accountNumber)
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem('IFSC Code', currentBank.ifscCode),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('SWIFT Code', currentBank.swiftCode),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem(
                    'IBAN Code', 
                    ProfileService.maskIban(currentBank.iban)
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
                if (onAddBank != null)
                  GestureDetector(
                    onTap: onAddBank,
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
                  if (onAddBank != null)
                    TextButton.icon(
                      onPressed: onAddBank,
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
}