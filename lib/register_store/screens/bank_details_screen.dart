import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BankDetailsPage extends StatefulWidget {
  // ignore: use_super_parameters
  const BankDetailsPage({Key? key}) : super(key: key);

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _ibanController = TextEditingController();
  final _swiftCodeController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderNameController.dispose();
    _ifscCodeController.dispose();
    _ibanController.dispose();
    _swiftCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          'Register Your Store',
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(20.0.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Bank\nDetails',
                style: GoogleFonts.dmSans(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                  height: 1.2.h,
                ),
              ),
               SizedBox(height: 8.h),
               Text(
                'Payment Information',
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  color: Colors.grey,
                  height: 1.4.h,
                ),
              ),
               SizedBox(height: 10.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInputField(
                        label: 'Bank Name',
                        controller: _bankNameController,
                      ),
                       SizedBox(height: 10.h),
                      _buildInputField(
                        label: 'Account Number',
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                      ),
                       SizedBox(height: 10.h),
                      _buildInputField(
                        label: 'Account Holder Name',
                        controller: _accountHolderNameController,
                      ),
                       SizedBox(height: 10.h),
                      _buildInputField(
                        label: 'IFSC Code',
                        controller: _ifscCodeController,
                      ),
                       SizedBox(height: 10.h),
                      _buildInputField(
                        label: 'IBAN',
                        controller: _ibanController,
                      ),
                       SizedBox(height: 10.h),
                      _buildInputField(
                        label: 'SWIFT Code',
                        controller: _swiftCodeController,
                      ),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding:  EdgeInsets.symmetric(vertical: 14.h),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child:  Text(
                        'Previous',
                        style: GoogleFonts.dmSans(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                   SizedBox(width: 16.w
                   ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process form data
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bank details saved successfully!'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3E50),
                        padding:  EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child:  Text(
                        'Next',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  GoogleFonts.dmSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
         SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF2C3E50)),
            ),
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}