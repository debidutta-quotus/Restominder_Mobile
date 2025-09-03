import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'common/theme/app_theme.dart';
import 'features/menu/controller/menu_controller.dart';
import 'common/api_manager/dio_client.dart'; // For navigatorKey

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

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
            // Add other providers as needed
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey, // For global navigation
            title: 'RestoMinder',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: initialRoute,
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
