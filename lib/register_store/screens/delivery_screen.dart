import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bank_details_screen.dart';

class DeliveryPartnersPage extends StatefulWidget {
  // ignore: use_super_parameters
  const DeliveryPartnersPage({Key? key}) : super(key: key);

  @override
  State<DeliveryPartnersPage> createState() => _DeliveryPartnersPageState();
}

class _DeliveryPartnersPageState extends State<DeliveryPartnersPage> {
  Set<String> selectedPartners = {'swiggy', 'uber_eats'};

  final List<DeliveryPartner> partners = [
    DeliveryPartner(
      id: 'swiggy',
      imagePath: 'assets/icons/swiggy.png',
    ),
    DeliveryPartner(
      id: 'zomato',
      imagePath: 'assets/icons/zomato.png',
    ),
    DeliveryPartner(
      id: 'uber_eats',
      imagePath: 'assets/icons/uberEats.png',
    ),
    DeliveryPartner(
      id: 'eat_club',
      imagePath: 'assets/icons/eatClub.png',
    ),
    DeliveryPartner(
      id: 'bolt_food',
      imagePath: 'assets/icons/boltFood.png',
    ),
  ];

  void togglePartner(String partnerId) {
    setState(() {
      if (selectedPartners.contains(partnerId)) {
        selectedPartners.remove(partnerId);
      } else {
        selectedPartners.add(partnerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery\nPartners',
              style: GoogleFonts.dmSans(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
                height: 1.2.h,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Select your preferred delivery\npartners',
              style: GoogleFonts.dmSans(
                fontSize: 15.sp,
                color: Colors.grey,
                height: 1.4.h,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                '${selectedPartners.length} Selected',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(0, 16.h, 16.w, 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  final partner = partners[index];
                  final isSelected = selectedPartners.contains(partner.id);

                  return GestureDetector(
                    onTap: () => togglePartner(partner.id),
                    child: Stack(
                      clipBehavior: Clip.none, // Allow tick to overflow
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.r), // Clip to match container border
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                child: Image.asset(
                                  partner.imagePath,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover, // Fill the entire container
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 40.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: -8.h, // Float outside the border
                            right: -8.w, // Float outside the border
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2196F3),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Previous',
                      style: GoogleFonts.dmSans(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to bank details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BankDetailsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
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
    );
  }
}

class DeliveryPartner {
  final String id;
  final String imagePath;

  DeliveryPartner({
    required this.id,
    required this.imagePath,
  });
}