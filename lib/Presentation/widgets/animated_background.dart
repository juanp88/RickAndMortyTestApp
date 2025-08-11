import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF6BE9F8),
      Color(0xFF4FE0FB),
      Color(0xFF7185F6),
      Color(0xFFC04CED),
    ],
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _controller3 = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
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
    return Stack(
      children: [
        // Animated gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0A0E1A), // Deep dark blue
                Color(0xFF1A1F2E), // Slightly lighter
                Color(0xFF252B3D), // Even lighter
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Floating orbs
        ...List.generate(3, (index) {
          final controller = [_controller1, _controller2, _controller3][index];
          final size = [120.0, 80.0, 100.0][index];
          final color = widget.colors[index % widget.colors.length];

          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Positioned(
                left:
                    MediaQuery.of(context).size.width *
                    (0.1 +
                        0.8 * math.sin(controller.value * 2 * math.pi + index)),
                top:
                    MediaQuery.of(context).size.height *
                    (0.1 +
                        0.8 *
                            math.cos(
                              controller.value * 2 * math.pi + index * 0.5,
                            )),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.1),
                        color.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Content
        widget.child,
      ],
    );
  }
}
