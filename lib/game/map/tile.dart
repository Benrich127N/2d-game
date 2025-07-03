import 'package:flame/components.dart';
import 'dart:ui';

enum TileType { grass, dirt, water }

class Tile extends RectangleComponent {
  final TileType type;

  Tile(
      {required this.type,
      required Vector2 position,
      required Vector2 size,
      Paint? paint})
      : super(
          position: position,
          size: size,
          paint: paint ?? Paint()
            ..color = _getColor(type),
        );

  static Color _getColor(TileType type) {
    switch (type) {
      case TileType.grass:
        return const Color(0xFFB2FF59);
      case TileType.dirt:
        return const Color(0xFF8D6E63);
      case TileType.water:
        return const Color(0xFF40C4FF);
    }
  }
}
