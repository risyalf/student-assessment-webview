import 'package:flutter/material.dart';
import 'package:student_assessment_fe/app/router/app_router.dart';
import 'package:student_assessment_fe/services/kiosk_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      KioskService.preventScreenshot();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Student Assessment',
      theme: ThemeData(useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}
