import 'package:flame/components.dart';
import 'dart:ui';
import 'map/tile.dart';
import 'components/obstacle.dart';
import 'components/collectible.dart';
import 'components/npc.dart';

class GameWorld extends World {
  final int rows = 10;
  final int cols = 13;
  final double tileSize = 60;
  final Vector2 worldSize;

  GameWorld({required this.worldSize});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Add background
    // add(RectangleComponent(
    //   size: worldSize,
    //   paint: Paint()..color = const Color(0xFFB2FF59),
    //   priority: -1,
    // ));
    // Add tiles
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final type =
            (row == 0 || col == 0 || row == rows - 1 || col == cols - 1)
                ? TileType.water
                : (row % 2 == 0 && col % 2 == 0)
                    ? TileType.dirt
                    : TileType.grass;
        add(Tile(
          type: type,
          position: Vector2(col * tileSize, row * tileSize),
          size: Vector2(tileSize, tileSize),
        ));
      }
    }
    // Add debug tile at (0,0)
    add(Tile(
      type: TileType.grass,
      position: Vector2.zero(),
      size: Vector2(tileSize, tileSize),
      paint: Paint()..color = const Color(0xFFFF0000),
    ));
    // Add high-priority debug rectangle at (0,0)
    add(RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(40, 40),
      paint: Paint()..color = const Color(0xFF00FFFF),
      priority: 100,
    ));
    // Add obstacles
    add(Obstacle(
        position: Vector2(180, 180), size: Vector2(tileSize, tileSize)));
    add(Obstacle(
        position: Vector2(420, 300), size: Vector2(tileSize, tileSize)));
    // Add collectibles
    add(Collectible(type: CollectibleType.coin, position: Vector2(120, 120)));
    add(Collectible(type: CollectibleType.gem, position: Vector2(600, 400)));
    // Add NPCs
    add(NPC(
        name: 'Bob',
        position: Vector2(300, 120),
        size: Vector2(tileSize, tileSize)));
    add(NPC(
        name: 'Alice',
        position: Vector2(600, 240),
        size: Vector2(tileSize, tileSize)));
  }

  List<Obstacle> getObstacles() {
    return children.whereType<Obstacle>().toList();
  }

  bool isCollidingWithObstacle(Vector2 position, Vector2 playerSize) {
    final playerRect =
        Rect.fromLTWH(position.x, position.y, playerSize.x, playerSize.y);
    for (final obstacle in getObstacles()) {
      final obstacleRect = Rect.fromLTWH(
        obstacle.position.x,
        obstacle.position.y,
        obstacle.size.x,
        obstacle.size.y,
      );
      if (playerRect.overlaps(obstacleRect)) {
        return true;
      }
    }
    return false;
  }

  bool isWithinBounds(Vector2 position, Vector2 playerSize) {
    return position.x >= 0 &&
        position.y >= 0 &&
        position.x + playerSize.x <= worldSize.x &&
        position.y + playerSize.y <= worldSize.y;
  }
}
