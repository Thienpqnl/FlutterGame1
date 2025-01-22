import 'dart:math';

import 'package:quocthien_app_pr/ColorTile.dart';

class TargetSequence {
  List<ColorTile> currentTarget;

  TargetSequence()
      : currentTarget = List.generate(
          Random().nextInt(4) + 1,
          (_) => ColorTile.generateRandomTile(),
        );

  // Làm mới danh sách mục tiêu
  void refreshSequence() {
    currentTarget = List.generate(
      Random().nextInt(4) + 1,
      (_) => ColorTile.generateRandomTile(),
    );
  }
}