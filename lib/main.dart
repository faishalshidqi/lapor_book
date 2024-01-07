import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/firebase_options.dart';
import 'package:lapor_book/pages/add_report.dart';
import 'package:lapor_book/pages/dashboard_page.dart';
import 'package:lapor_book/pages/login_page.dart';
import 'package:lapor_book/pages/register_page.dart';
import 'package:lapor_book/pages/report_detail.dart';
import 'package:lapor_book/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lapor Book',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/register': (context) => const RegisterPage(),
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/add': (context) => const AddReportPage(),
          '/detail': (context) => const ReportDetailPage(),
        },);
  }
}
