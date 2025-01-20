import 'dart:math';

import 'package:quocthien_app_pr/ColorTile.dart';

class TargetSequence {
  List<List<ColorTile>> tiles; // Ma trận các ô trên bảng

  TargetSequence()
      : tiles = List.generate(
            1,
            (_) => List.generate(Random().nextInt(4) + 1,
                (_) => ColorTile.generateRandomTile()));

  // Hàm để làm mới tất cả ô trong dãy
  void refreshSequence() {
    tiles = List.generate(
        1,
        (_) => List.generate(
              Random().nextInt(4) + 1,
              (_) => ColorTile.generateRandomTile(),
            ));
  }
}
