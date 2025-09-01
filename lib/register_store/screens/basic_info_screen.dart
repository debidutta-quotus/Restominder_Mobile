import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resto_minder/common/theme/app_colors.dart';

import 'contact_info_screen.dart';

class BasicInformationPage extends StatefulWidget {
  // ignore: use_super_parameters
  const BasicInformationPage({Key? key}) : super(key: key);

  @override
  State<BasicInformationPage> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformationPage> {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController brandNameController = TextEditingController();
  String selectedBusinessType = 'Restaurant';
  String selectedCuisineType = 'Italian';

  final List<String> businessTypes = [
    'Restaurant',
    'Cafe',
    'Fast Food',
    'Food Truck',
    'Bakery',
    'Bar',
  ];

  final List<String> cuisineTypes = [
    'Italian',
    'Chinese',
    'Indian',
    'Mexican',
    'American',
    'Japanese',
    'Thai',
    'French',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Register Your Store',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic\nInformation',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Store details and business type',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Color(0xFF718096),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Store Name Field
                    Text(
                      'Store Name',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: storeNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFF3182CE)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Brand Name Field
                    Text(
                      'Brand Name',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: brandNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFF3182CE)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Business Type Dropdown
                    Text(
                      'Business Type',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      value: selectedBusinessType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBusinessType = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFF3182CE)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                      ),
                      items: businessTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10.h),

                    // Cuisine Type Dropdown
                    Text(
                      'Cuisine Type',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      value: selectedCuisineType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCuisineType = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Color(0xFF3182CE)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                      ),
                      items: cuisineTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 30.h), // Added some spacing at bottom
                  ],
                ),
              ),
            ),

            // Next Button - Outside of scroll view
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to contact information page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactInformationPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    storeNameController.dispose();
    brandNameController.dispose();
    super.dispose();
  }
}