import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget CircleProfile(
  double size,
  dynamic backgroundColor,
  String emoji, {
  bool animation = true,
  bool ifShadowBig = true,
}) {
  Color color;
  if (backgroundColor is String) {
    color = Color(int.parse('0xFF$backgroundColor'));
  } else {
    color = backgroundColor;
  }
  return SizedBox(
    width: size,
    height: size,
    child: Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.9), color, color.withOpacity(0.8)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              // Main shadow
              BoxShadow(
                color: color.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              // Inner shadow
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                spreadRadius: -2,
                blurRadius: 4,
                offset: const Offset(-2, -2),
              ),
              // Outer glow
              BoxShadow(
                color: color.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child:
                  animation
                      ? TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.elasticOut,
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return ifShadowBig
                              ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background glow
                                  Transform.scale(
                                    scale: 1.2 + (value * 0.3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            color.withOpacity(0.3 * value),
                                            color.withOpacity(0.0),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: color.withOpacity(
                                              0.5 * value,
                                            ),
                                            blurRadius: 20 * value,
                                            spreadRadius: 5 * value,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Main content
                                  Transform(
                                    transform:
                                        Matrix4.identity()
                                          ..scale(0.5 + (value * 0.5))
                                          ..rotateZ(value * 4 * 3.14159)
                                          ..translate(0.0, -20.0 * (1 - value)),
                                    alignment: Alignment.center,
                                    child: Opacity(
                                      opacity: value.clamp(0.0, 1.0),
                                      child: child,
                                    ),
                                  ),
                                ],
                              )
                              : Transform(
                                transform:
                                    Matrix4.identity()
                                      ..scale(0.5 + (value * 0.5))
                                      ..rotateZ(value * 4 * 3.14159)
                                      ..translate(0.0, -20.0 * (1 - value)),
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity: value.clamp(0.0, 1.0),
                                  child: child,
                                ),
                              );
                        },
                        child: Text(
                          emoji,
                          style: TextStyle(
                            fontSize: size * 0.5,
                            height: 1.0,
                            fontFamily: 'iphone',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 2),
                                blurRadius: 3,
                              ),
                              Shadow(
                                color: Colors.white.withOpacity(0.5),
                                offset: const Offset(0, -1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : Text(
                        emoji,
                        style: TextStyle(
                          fontSize: size * 0.5,
                          height: 1.0,
                          fontFamily: 'iphone',
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 3,
                            ),
                            Shadow(
                              color: Colors.white.withOpacity(0.5),
                              offset: const Offset(0, -1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
            ),
          ),
        ),
      ],
    ),
  );
}

// padding: EdgeInsets.only(top: size * 0.15),
