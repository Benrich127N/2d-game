import 'package:flame/components.dart';
import 'dart:ui';

class NPC extends RectangleComponent {
  final String name;

  NPC({required this.name, required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          paint: Paint()..color = const Color(0xFF8E24AA),
        );

  void interact() {
    // Placeholder for interaction logic
    print('Hello, I am $name!');
  }
}
