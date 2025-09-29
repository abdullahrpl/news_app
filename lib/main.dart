import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <--- Import GetX
import 'package:news_app/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // <--- Ubah di sini!
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Kamu mungkin ingin menghapus debug show checked mode banner
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Opsional: menghilangkan banner debug
      home: const SplashScreen(),
    );
  }
}