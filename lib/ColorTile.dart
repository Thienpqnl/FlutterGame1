import 'dart:math';
import 'package:flutter/material.dart';

class ColorTile {
  Color color;
  bool isSelected; //trang thai da duoc chon hay chua

  ColorTile({required this.color, this.isSelected = false});

  static ColorTile generateRandomTile() {
    List<Color> availableColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];
    return ColorTile(
      color: availableColors[Random().nextInt(availableColors.length)],
    );
  }

  // Đánh dấu ô đã được chọn
  void selectTile() {
    isSelected = true;
  }

  // Bỏ chọn ô
  void resetTile() {
    isSelected = false;
  }
}
