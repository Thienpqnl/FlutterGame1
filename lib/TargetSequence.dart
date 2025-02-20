import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quocthien_app_pr/ColorTile.dart';
import 'package:quocthien_app_pr/GameBoard.dart';

class TargetSequence {
  List<ColorTile> currentTarget;

  TargetSequence()
      : currentTarget = List.generate(
          Random().nextInt(4) + 1,
          (_) => ColorTile.generateRandomTile(),
        );
  // Làm mới danh sách mục tiêu
  void refreshSequence(GameBoard gameBoard) {
    do {
      currentTarget = List.generate(
        Random().nextInt(4) + 1,
        (_) => ColorTile.generateRandomTile(),
      );
      Set<Color> availableColors = gameBoard.tiles
          .expand((row) => row)
          .map((tile) => tile.color)
          .toSet();
      // Kiểm tra xem tất cả ô trong target có màu hợp lệ không
      bool isValidTarget0 =
          currentTarget.every((tile) => availableColors.contains(tile.color));

      // Đếm số lượng mỗi màu trong gameBoard
      Map<Color, int> boardColorCount = {};
      for (var row in gameBoard.tiles) {
        for (var tile in row) {
          boardColorCount[tile.color] = (boardColorCount[tile.color] ?? 0) + 1;
        }
      }

      // Đếm số lượng mỗi màu trong target
      Map<Color, int> targetColorCount = {};
      for (var tile in currentTarget) {
        targetColorCount[tile.color] = (targetColorCount[tile.color] ?? 0) + 1;
      }

      // Kiểm tra xem số lượng mỗi màu trong target có hợp lệ không
      bool isValidTargetMin = targetColorCount.entries.every((entry) {
        Color color = entry.key;
        int countInTarget = entry.value;
        int countInBoard = boardColorCount[color] ?? 0;
        return countInTarget <=
            countInBoard; // Target không vượt quá số lượng trong board
      });

      // Nếu target hợp lệ, thoát vòng lặp
      if (isValidTarget0 && isValidTargetMin) break;
    } while (true); // Lặp lại cho đến khi có target hợp lệ
  }
}
