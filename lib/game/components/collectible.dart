import 'package:flame/components.dart';
import 'dart:ui';

enum CollectibleType { coin, gem }

class Collectible extends CircleComponent {
  final CollectibleType type;
  bool collected = false;

  Collectible(
      {required this.type, required Vector2 position, double radius = 20})
      : super(
          position: position,
          radius: radius,
          paint: Paint()..color = _getColor(type),
        );

  static Color _getColor(CollectibleType type) {
    switch (type) {
      case CollectibleType.coin:
        return const Color(0xFFFFD600);
      case CollectibleType.gem:
        return const Color(0xFF00B8D4);
    }
  }

  void collect() {
    collected = true;
    removeFromParent();
  }
}
