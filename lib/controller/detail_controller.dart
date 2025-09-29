import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailController extends GetxController with GetTickerProviderStateMixin {
  final Map<String, dynamic> newsDetail;

  late AnimationController fadeAnimationController;
  late AnimationController slideAnimationController;
  late AnimationController scaleAnimationController;
  
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;

  DetailController({required this.newsDetail});

  @override
  void onInit() {
    super.onInit();
    
    fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: scaleAnimationController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    fadeAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    slideAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    scaleAnimationController.forward();
  }

  @override
  void onClose() {
    fadeAnimationController.dispose();
    slideAnimationController.dispose();
    scaleAnimationController.dispose();
    super.onClose();
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }
}