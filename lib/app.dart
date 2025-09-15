import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'common/theme/app_theme.dart';
import 'features/menu/controller/menu_controller.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/profile/data/api/profile_api.dart';
import 'features/profile/data/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_store_profile.dart';
import 'features/profile/domain/usecases/update_store_profile.dart';
import 'features/profile/domain/usecases/manage_bank_details.dart';
import 'common/api_manager/dio_client.dart'; // For navigatorKey

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Your Figma design base size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MenuControllers()),
            ChangeNotifierProvider(
              create: (_) {
                final profileApi = ProfileApi();
                final profileRepository = ProfileRepositoryImpl(profileApi);
                return ProfileProvider(
                  GetStoreProfile(profileRepository),
                  UpdateStoreProfile(profileRepository),
                  ManageBankDetails(profileRepository),
                );
              },
            ),
            // Add other providers as needed
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey, // For global navigation
            title: 'RestoMinder',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            builder: (context, widget) {
              return MediaQuery(
                // ignore: deprecated_member_use
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
          ),
        );
      },
    );
  }
}
