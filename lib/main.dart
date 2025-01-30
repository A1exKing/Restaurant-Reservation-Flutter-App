import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rest_reservation/pages/auth/login_screen.dart';
import 'package:rest_reservation/pages/home_page/home_page.dart';
import 'package:rest_reservation/pages/main_page.dart';
import 'package:rest_reservation/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rest_reservation/services/auth.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(365, 770), // Розмір екрана для дизайну
      minTextAdapt: true, // Адаптація тексту
      builder: (context, child) {
        return GetMaterialApp(
           
          title: 'Flutter Demo',
          theme: ThemeData(
            
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: AuthService().currentUser != null ? MainPage() : LoginPage(),
        );
      }
    );
  }
}
