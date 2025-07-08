import 'dart:math';
import 'package:flutter/material.dart';

class DrawerThemeBackground extends StatefulWidget {
  const DrawerThemeBackground({super.key});

  @override
  State<DrawerThemeBackground> createState() => _DrawerThemeBackgroundState();
}

class _DrawerThemeBackgroundState extends State<DrawerThemeBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  // Parçacıklar
  late List<_Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final count = isDark ? 30 : 25;

    particles = List.generate(count, (index) {
      final dx = _random.nextDouble() * size.width;
      final dy = _random.nextDouble() * size.height;
      final speed = isDark
          ? _random.nextDouble() * 0.2
          : 0.4 + _random.nextDouble() * 0.3;
      final sizeVal = isDark
          ? _random.nextDouble() * 6 + 4
          : _random.nextDouble() * 12 + 8;

      return _Particle(
        offset: Offset(dx, dy),
        speed: speed,
        size: sizeVal,
        isDark: isDark,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      ignoring: true,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          for (var p in particles) {
            p.offset = Offset(
              p.offset.dx,
              p.offset.dy + p.speed * 10,
            );

            if (p.offset.dy > size.height) {
              p.offset = Offset(
                _random.nextDouble() * size.width,
                -10,
              );
            }
          }

          return Stack(
            children: particles.map((p) {
              return Positioned(
                left: p.offset.dx,
                top: p.offset.dy,
                child: Opacity(
                  opacity: 0.5 + 0.5 * sin(_controller.value * 2 * pi),
                  child: p.isDark
                      ? Icon(
                          Icons.star,
                          size: p.size,
                          color: Colors.amber.withOpacity(0.8),
                        )
                      : Icon(
                          Icons.ac_unit,
                          size: p.size,
                          color: Colors.lightBlueAccent.withOpacity(0.8),
                        ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _Particle {
  Offset offset;
  final double speed;
  final double size;
  final bool isDark;

  _Particle({
    required this.offset,
    required this.speed,
    required this.size,
    required this.isDark,
  });
}