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

  void handleTileTap(ColorTile tappedTile) {
    // Kiểm tra nếu không có mục tiêu
    if (targetSequence.currentTarget.isEmpty) return;

    Set<Color> availableColors = gameBoard.tiles
        .expand((row) =>
            row) // Chuyển từ List<List<ColorTile>> thành List<ColorTile>
        .map((tile) => tile.color) // Lấy danh sách màu từ từng tile
        .toSet(); // Chuyển thành Set để loại bỏ màu trùng nhau
    bool isValidTarget = targetSequence.currentTarget
        .every((tile) => availableColors.contains(tile.color));

    // Nếu không có màu hợp lệ, reset target
    if (!isValidTarget) {
      print("Màu trong target không có trên board, reset target!");
      targetSequence.refreshSequence();
      tappedTiles.clear();
      return;
    }

    // Xác định tile mong đợi
    final expectedTile = targetSequence.currentTarget[tappedTiles.length];

    // So sánh tile được nhấn với tile mong đợi
    if (tappedTile.color == expectedTile.color) {
      tappedTiles.add(tappedTile);
      tappedTile.selectTile();
      print('Tile tapped: ${tappedTile.isSelected}');
      print('Expected: ${expectedTile.isSelected}');
      // Kiểm tra hoàn thành mục tiêu
      if (tappedTiles.length == targetSequence.currentTarget.length) {
        player.increaseScore(100); // Cộng điểm

        // Làm mới các ô đã nhấn và danh sách mục tiêu
        gameBoard.refreshSelectedTiles();
        targetSequence.refreshSequence();
        for (var tile in tappedTiles) {
          tile.resetTile();
        }
        tappedTiles.clear();
      }
    } else {
      // Nhấn sai, chỉ reset danh sách đã nhấn
      print('wrong Tile tapped: ${tappedTile.isSelected}');
      print('wrong Expected: ${expectedTile.isSelected}');
      for (var tile in tappedTiles) {
        tile.resetTile();
      }
      tappedTiles.clear();
    }
  }
}
