import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleAnimation extends StatefulWidget {
  final Color color;
  final VoidCallback? onAnimationComplete;
  final String? imagePath;
  final Duration duration;

  const CircleAnimation({
    super.key,
    required this.color,
    this.onAnimationComplete,
    this.imagePath,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  CircleAnimationState createState() => CircleAnimationState();
}

class CircleAnimationState extends State<CircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    // Calculate scale needed to cover the entire screen
    final screenSize = Get.size;
    final maxDimension =
        screenSize.width > screenSize.height
            ? screenSize.width
            : screenSize.height;
    final scaleNeeded =
        maxDimension * 2; // Multiply by 2 to ensure full coverage

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: scaleNeeded,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    if (!_isAnimating) {
      setState(() {
        _isAnimating = true;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isAnimating)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 1, // Start with minimal size
                    height: 1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                    ),
                    child:
                        widget.imagePath != null
                            ? ClipOval(
                              child: Image.asset(
                                widget.imagePath!,
                                fit: BoxFit.cover,
                              ),
                            )
                            : null,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
