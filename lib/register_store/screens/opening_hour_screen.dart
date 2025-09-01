import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import 'package:resto_minder/common/theme/app_colors.dart';

import 'delivery_screen.dart';

class OpeningHoursPage extends StatefulWidget {
  // ignore: use_super_parameters
  const OpeningHoursPage({Key? key}) : super(key: key);


  @override
  State<OpeningHoursPage> createState() => _OpeningHoursPageState();
}

class _OpeningHoursPageState extends State<OpeningHoursPage> {
  final TextEditingController openingTimeController = TextEditingController();
  final TextEditingController closingTimeController = TextEditingController();

  // Days of the week selection
  Map<String, bool> selectedDays = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': false,
    'Sunday': false,
  };

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF2D3748),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // ignore: use_build_context_synchronously
      final formattedTime = picked.format(context);
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

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
          style: GoogleFonts.dmSans(
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
                      'Opening\nHours',
                      style: GoogleFonts.dmSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Working hours and days',
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        color: Color(0xFF718096),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Opening Time Field
                    Text(
                      'Opening Time',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: openingTimeController,
                      readOnly: true,
                      onTap: () => _selectTime(context, openingTimeController),
                      decoration: InputDecoration(
                        hintText: '--',
                        hintStyle: GoogleFonts.dmSans(
                          color: Color(0xFFA0AEC0),
                          fontSize: 16.sp,
                        ),
                        suffixIcon: Icon(
                          Icons.access_time,
                          color: Color(0xFFA0AEC0),
                          size: 20.sp,
                        ),
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
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Closing Time Field
                    Text(
                      'Closing Time',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: closingTimeController,
                      readOnly: true,
                      onTap: () => _selectTime(context, closingTimeController),
                      decoration: InputDecoration(
                        hintText: '--',
                        hintStyle: GoogleFonts.dmSans(
                          color: Color(0xFFA0AEC0),
                          fontSize: 16.sp,
                        ),
                        suffixIcon: Icon(
                          Icons.access_time,
                          color: Color(0xFFA0AEC0),
                          size: 20.sp,
                        ),
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
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Working Days Section
                    _buildWorkingDaysSection(),
                    SizedBox(height: 30.h),                  ],
                ),
              ),
            ),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeliveryPartnersPage(),
                          ),
                        );


                        // // Handle form submission or navigate to next screen
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text('Store registration completed!'),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2D3748),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    openingTimeController.dispose();
    closingTimeController.dispose();
    super.dispose();
  }

  Widget _buildWorkingDaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Days',
          style: GoogleFonts.dmSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 16.h),

        // Days Checkboxes - First Row
        Row(
          children: [
            Expanded(
              child: _buildDayCheckbox('Monday'),
            ),
            Expanded(
              child: _buildDayCheckbox('Tuesday'),
            ),
            Expanded(
              child: _buildDayCheckbox('Wednesday'),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Days Checkboxes - Second Row
        Row(
          children: [
            Expanded(
              child: _buildDayCheckbox('Thursday'),
            ),
            Expanded(
              child: _buildDayCheckbox('Friday'),
            ),
            Expanded(
              child: _buildDayCheckbox('Saturday'),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Days Checkboxes - Third Row (Sunday)
        Row(
          children: [
            Expanded(
              child: _buildDayCheckbox('Sunday'),
            ),
            Expanded(child: Container()),
            Expanded(child: Container()),
          ],
        ),
        SizedBox(height: 30.h),
      ],
    );
  }

  Widget _buildDayCheckbox(String day) {
    return Padding(
      padding: EdgeInsets.only(right: 0.w,left: 10.w), // adjust spacing between checkboxes
      child: Row(
        mainAxisSize: MainAxisSize.min, // shrink the row to its contents
        children: [
          Transform.scale(
            scale: 1.0, // Smaller checkbox
            child: Checkbox(
              value: selectedDays[day],
              onChanged: (bool? value) {
                setState(() {
                  selectedDays[day] = value!;
                });
              },
              activeColor: Color(0xFF3182CE),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Text(
            day,
            style: GoogleFonts.dmSans(
              fontSize: 13.sp,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

}