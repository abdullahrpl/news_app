import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          controller.logoAnimationController,
          controller.textAnimationController,
          controller.fadeAnimationController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: controller.fadeOutAnimation,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: controller.logoScaleAnimation.value,
                    child: Transform.rotate(
                      angle: controller.logoRotationAnimation.value * 0.1,
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Transform.translate(
                    offset: Offset(0, controller.textSlideAnimation.value),
                    child: AnimatedOpacity(
                      opacity: controller.textAnimationController.value,
                      duration: const Duration(milliseconds: 500),
                      child: const Text(
                        'Newest',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 36,
                          color: Color(0xFF0F172A),
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}