import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade100,
                    Colors.purple.shade100,
                    Colors.pink.shade100,
                  ],
                  stops: [
                    0.0,
                    0.5 + 0.2 * _controller.value,
                    1.0,
                  ],
                ),
              ),
            );
          },
        ),
        
        // Bubbles
        ...List.generate(
          10,
          (index) => Positioned(
            left: MediaQuery.of(context).size.width * (index / 10),
            top: MediaQuery.of(context).size.height * 
                (0.1 + 0.8 * ((index % 3) / 3) + 0.1 * _controller.value),
            child: Opacity(
              opacity: 0.3,
              child: Container(
                width: 50 + (index % 3) * 20,
                height: 50 + (index % 3) * 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index % 2 == 0 ? Colors.white : Colors.purple.shade200,
                ),
              ),
            ),
          ),
        ),
        
        // Content
        widget.child,
      ],
    );
  }
}