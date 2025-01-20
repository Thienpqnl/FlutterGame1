import 'package:quocthien_app_pr/ColorTile.dart';

class GameBoard {
  final int rows;
  final int columns;
  List<List<ColorTile>> tiles; // Ma trận các ô trên bảng

  GameBoard({required this.rows, required this.columns})
      : tiles = List.generate(
            rows,
            (_) => List.generate(
                  columns,
                  (_) => ColorTile.generateRandomTile(),
                ));

  // Hàm để làm mới tất cả ô trên bảng (tạo lại các ô ngẫu nhiên)
  void refreshBoard() {
    tiles = List.generate(
        rows,
        (_) => List.generate(
              columns,
              (_) => ColorTile.generateRandomTile(),
            ));
  }

  void refreshSelectedTiles() {
    for (var tile in tiles) {
      for (var ti in tile) {
        if (ti.isSelected) {
          ti.color = ColorTile.generateRandomTile().color; // Đổi màu ngẫu nhiên
          ti.isSelected = false; // Bỏ chọn sau khi làm mới
        }
      }
    }
  }

  // Hàm lấy ô tại vị trí cụ thể
  ColorTile getTile(int row, int column) {
    return tiles[row][column];
  }

  // Hàm cập nhật trạng thái của một ô
  void updateTile(int row, int column, bool isSelected) {
    tiles[row][column].isSelected = isSelected;
  }

  // Hàm kiểm tra bảng chơi (để mở rộng, ví dụ: kiểm tra trạng thái thắng)
  bool isBoardValid() {
    return tiles.every(
        (row) => row.every((tile) => !tile.isSelected)); // Mọi ô chưa được chọn
  }
}
