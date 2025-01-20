import 'package:quocthien_app_pr/ColorTile.dart';
import 'package:quocthien_app_pr/TargetSequence.dart';
import 'package:quocthien_app_pr/GameBoard.dart';
import 'Player.dart';

class GameManager {
  final Player player;
  final TargetSequence targetSequence;
  final GameBoard gameBoard;

  GameManager(this.player, this.targetSequence, this.gameBoard);

  // Xử lý logic khi người chơi nhấn vào ô
  void handleTileTap(ColorTile tappedTile) {
    // Kiểm tra nếu ô được nhấn trùng với ô mục tiêu đầu tiên
    if (tappedTile.color == targetSequence.tiles[0][0].color) {
      // Người chơi nhấn đúng
      player.increaseScore(100); // Cộng điểm
      targetSequence.refreshSequence(); // Làm mới dãy mục tiêu
      gameBoard.refreshSelectedTiles(); // Làm mới bảng
    } else {
      // Người chơi nhấn sai
      targetSequence.refreshSequence(); // Làm mới dãy mục tiêu
    }
  }
}
