import 'package:cyclops/auth/main_page.dart';
import 'package:cyclops/pages/home_page.dart';
import 'package:cyclops/pages/login_page.dart';
import 'package:cyclops/pages/register_page.dart';
import 'package:cyclops/pages/visitors_log_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/admin_page.dart';
import 'pages/visitor_in.dart';
import 'pages/visitor_logs.dart';
import 'pages/visitor_out.dart';


Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      routes: {
        '/main': (context) => MainPage(),
        '/register': (context) => RegisterPage(),
        '/visitor_detail': (context) => VisitorDetailPage(visitorData: {},),
        '/visitor_in': (context) => VistorInPage(),
        '/visitor_out': (context) => visitorOutPage(),
        '/visitor_logs': (context) => visitorLogsPage(),
        '/admin': (context) => AdminPage(),
        '/dashboard': (context) => HomePage(),
      },
    );
  }
}
 