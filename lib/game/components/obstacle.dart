import 'package:flame/components.dart';
import 'dart:ui';

class Obstacle extends RectangleComponent {
  Obstacle({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          paint: Paint()..color = const Color(0xFF757575),
        );
}
