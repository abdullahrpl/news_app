import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/screens/home/home_screen.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController logoAnimationController;
  late AnimationController textAnimationController;
  late AnimationController fadeAnimationController;
  
  late Animation<double> logoScaleAnimation;
  late Animation<double> logoRotationAnimation;
  late Animation<double> textSlideAnimation;
  late Animation<double> fadeOutAnimation;

  @override
  void onInit() {
    super.onInit();
    
    logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: logoAnimationController,
      curve: Curves.elasticOut,
    ));

    logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: logoAnimationController,
      curve: Curves.easeInOut,
    ));

    textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: textAnimationController,
      curve: Curves.easeOutBack,
    ));

    fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    logoAnimationController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    textAnimationController.forward();
    
    await Future.delayed(const Duration(milliseconds: 2000));
    fadeAnimationController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    navigateToHome();
  }

  void navigateToHome() {
    Get.offAll(
      () => HomeScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void onClose() {
    logoAnimationController.dispose();
    textAnimationController.dispose();
    fadeAnimationController.dispose();
    super.onClose();
  }
}