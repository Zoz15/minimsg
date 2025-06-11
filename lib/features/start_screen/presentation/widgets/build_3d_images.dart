import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Animated3DImages extends StatefulWidget {
  const Animated3DImages({super.key});

  @override
  State<Animated3DImages> createState() => _Animated3DImagesState();
}

class _Animated3DImagesState extends State<Animated3DImages>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    // First image animation - slower vertical movement
    _controller1 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween<double>(
      begin: -15,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeInOut));

    // Second image animation - faster horizontal movement
    _controller2 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation2 = Tween<double>(
      begin: -20,
      end: 20,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInOut));

    // Third image animation - medium speed diagonal movement
    _controller3 = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation3 = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(parent: _controller3, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: Get.width,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // First image - vertical movement
            AnimatedBuilder(
              animation: _animation1,
              builder: (context, child) {
                return Positioned(
                  top: -50 + _animation1.value,
                  left: Get.width - 200,
                  child: build_image('assets/images/3d image 1.png', 300),
                );
              },
            ),
            // Second image - horizontal movement
            AnimatedBuilder(
              animation: _animation2,
              builder: (context, child) {
                return Positioned(
                  top: 40,
                  left: -140 + _animation2.value,
                  child: build_image('assets/images/3d image 2.png', 400),
                );
              },
            ),
            // Third image - diagonal movement
            AnimatedBuilder(
              animation: _animation3,
              builder: (context, child) {
                return Positioned(
                  top: 200 + _animation3.value,
                  left: Get.width - 200 + (_animation3.value * 0.5).round(),
                  child: build_image('assets/images/3d image 3.png', 300),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget build_image(String image_path, double size) {
  return SizedBox(width: size, height: size, child: Image.asset(image_path));
}
