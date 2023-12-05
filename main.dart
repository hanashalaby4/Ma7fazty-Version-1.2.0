import 'package:firebase_core/firebase_core.dart'; //Import statement to import the firebase_core package that initialized firbase in the app
import 'package:flutter/material.dart'; //import material package (design widgets)
import 'signup.dart';
import 'color.dart';
import 'firebase_options.dart'; //import a dart file that contains the details needed to establish a connection between Ma7fazti and firebase services


void main() async { //entry point of the app
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
    return MaterialApp(
      title: 'Ma7fazti',
      theme: ThemeData(
        textTheme:
        TextTheme(titleMedium: TextStyle(color: softPurple),
        ),
      scaffoldBackgroundColor: const Color(0xff212131),
        primaryColor: const Color(0xffCBCCD5),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignUpPage(), //sets up the initial screen for Ma7fazti
    );
  }
}
