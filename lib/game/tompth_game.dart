import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'player.dart';
import 'map/tile.dart';
import 'components/obstacle.dart';
import 'components/collectible.dart';
import 'components/npc.dart';

class TompthGame extends FlameGame {
  late final Player player;
  late final JoystickComponent joystick;
  late final TextComponent scoreText;
  int score = 0;
  String? npcDialog;

  final int rows = 10;
  final int cols = 13;
  final double tileSize = 60;
  final Vector2 worldSize = Vector2(800, 600);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Add background
    add(RectangleComponent(
      size: worldSize,
      paint: Paint()..color = const Color(0xFFB2FF59),
      priority: -1,
    ));
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

    joystick = JoystickComponent(
      knob: CircleComponent(
          radius: 20, paint: Paint()..color = const Color(0xFF00FF00)),
      background: CircleComponent(
          radius: 50, paint: Paint()..color = const Color(0x7700FF00)),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);

    player = Player(joystick: joystick, worldSize: worldSize);
    add(player);

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
      priority: 100,
    );
    add(scoreText);
  }

  void incrementScore(int value) {
    score += value;
    scoreText.text = 'Score: $score';
  }

  void showNpcDialog(String message) {
    npcDialog = message;
    overlays.add('NpcDialog');
  }

  void hideNpcDialog() {
    npcDialog = null;
    overlays.remove('NpcDialog');
  }

  @override
  void update(double dt) {
    super.update(dt);
    final cameraSize = size;
    final worldSize = this.worldSize;
    final playerCenter = player.position + player.size / 2;
    Vector2 cameraTarget = playerCenter - cameraSize / 2;
    // Only clamp if the world is larger than the screen
    double maxX = (worldSize.x - cameraSize.x).clamp(0, double.infinity);
    double maxY = (worldSize.y - cameraSize.y).clamp(0, double.infinity);
    cameraTarget.x = cameraTarget.x.clamp(0, maxX);
    cameraTarget.y = cameraTarget.y.clamp(0, maxY);
    camera.moveTo(cameraTarget);
  }
}
