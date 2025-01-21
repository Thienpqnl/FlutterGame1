import 'package:flutter/material.dart';
import 'Player.dart';
import 'GameBoard.dart';
import 'TargetSequence.dart';
import 'ColorTile.dart';

class GameManager {
  final Player player;
  final GameBoard gameBoard;
  final TargetSequence targetSequence;
  List<ColorTile> tappedTiles = [];

  GameManager(
      {required this.player,
      required this.gameBoard,
      required this.targetSequence});

  // Xử lý khi người chơi nhấn vào một ô
  void handleTileTap(ColorTile tappedTile) {
    // Kiểm tra ô đã được chọn
    if (targetSequence.currentTarget.isEmpty) return;

    final expectedTile = targetSequence.currentTarget[tappedTiles.length];

    if (tappedTile == expectedTile) {
      tappedTiles.add(tappedTile);

      // Kiểm tra nếu đã nhấn đúng toàn bộ danh sách
      if (tappedTiles.length == targetSequence.currentTarget.length) {
        player.increaseScore(100); // Cộng điểm

        // Đổi mới các ô đã nhấn trong gameBoard
        gameBoard.refreshSelectedTiles();

        // Làm mới danh sách mục tiêu
        targetSequence.refreshSequence();

        // Reset danh sách ô đã nhấn
        tappedTiles.clear();
      }
    } else {
      // Nếu nhấn sai, làm mới mục tiêu và reset danh sách
      targetSequence.refreshSequence();
      tappedTiles.clear();
    }
  }
}
