import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'dart:ui';
import 'components/collectible.dart';
import 'components/npc.dart';
import 'tompth_game.dart';

class Player extends RectangleComponent with HasGameRef<TompthGame> {
  final JoystickComponent joystick;
  final Vector2 worldSize;

  Player({required this.joystick, required this.worldSize})
      : super(
            size: Vector2.all(64),
            paint: Paint()..color = const Color(0xFF0000FF));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = (worldSize - size) / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick.direction != JoystickDirection.idle) {
      final nextPosition = position + joystick.relativeDelta * 200 * dt;
      if (_isWithinBounds(nextPosition, size)) {
        position.setFrom(nextPosition);
      }
    }
    // Check for collectible collision
    final playerRect = Rect.fromLTWH(position.x, position.y, size.x, size.y);
    for (final collectible in gameRef.children.whereType<Collectible>()) {
      final cRect = Rect.fromCircle(
          center: Offset(collectible.position.x, collectible.position.y),
          radius: collectible.radius);
      if (!collectible.collected && playerRect.overlaps(cRect)) {
        collectible.collect();
        gameRef.incrementScore(1);
      }
    }
    // Check for NPC collision and dialog
    bool isOverlappingNpc = false;
    for (final npc in gameRef.children.whereType<NPC>()) {
      final npcRect =
          Rect.fromLTWH(npc.position.x, npc.position.y, npc.size.x, npc.size.y);
      if (playerRect.overlaps(npcRect)) {
        gameRef.showNpcDialog('Hello, I am ${npc.name}!');
        isOverlappingNpc = true;
        break;
      }
    }
    if (!isOverlappingNpc && gameRef.npcDialog != null) {
      gameRef.hideNpcDialog();
    }
  }

  bool _isWithinBounds(Vector2 position, Vector2 playerSize) {
    return position.x >= 0 &&
        position.y >= 0 &&
        position.x + playerSize.x <= worldSize.x &&
        position.y + playerSize.y <= worldSize.y;
  }
}
