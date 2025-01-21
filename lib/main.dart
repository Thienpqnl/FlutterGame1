import 'dart:async';
import 'package:flutter/material.dart';
import 'ColorTile.dart';
import 'GameBoard.dart';
import 'Player.dart';
import 'TargetSequence.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reaction Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameBoard _gameBoard = GameBoard(rows: 4, columns: 4); // Bảng các ô
  final Player _player = Player(); // Người chơi
  final TargetSequence _targetSequence = TargetSequence(); // Chuỗi mục tiêu
  int timeRemaining = 60; // Thời gian chơi
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer(); // Bắt đầu đếm ngược thời gian
  }

  @override
  void dispose() {
    timer.cancel(); // Hủy bộ đếm thời gian khi thoát
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          timer.cancel();
          showGameOverDialog();
        }
      });
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: ${_player.score}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void restartGame() {
    setState(() {
      _player.score = 0;
      timeRemaining = 60;
      _gameBoard.refreshBoard();
      _targetSequence.refreshSequence();
      startTimer();
    });
  }

  void onTilePressed(ColorTile tile) {
    if (_targetSequence.tiles[0].isNotEmpty &&
        tile.color == _targetSequence.tiles[0][0].color) {
      setState(() {
        _targetSequence.tiles[0].removeAt(0); // Xóa ô đã nhấn đúng khỏi chuỗi
        _player.score += 100; // Cộng điểm
        if (_targetSequence.tiles[0].isEmpty) {
          _targetSequence.refreshSequence(); // Làm mới chuỗi khi hoàn thành
        }
      });
    } else {
      // Nhấn sai
      setState(() {
        _targetSequence.refreshSequence(); // Làm mới chuỗi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Time Remaining: $timeRemaining',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _targetSequence.tiles[0]
                .map(
                  (tile) => Container(
                    margin: const EdgeInsets.all(4),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tile.color,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 ô trên mỗi hàng
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: _gameBoard.tiles.length *
                  _gameBoard.tiles[0].length, // Tổng số ô
              itemBuilder: (context, index) {
                // Chuyển đổi chỉ số 1D sang 2D
                final row =
                    index ~/ _gameBoard.tiles[0].length; // Xác định hàng
                final col = index % _gameBoard.tiles[0].length; // Xác định cột
                final tile =
                    _gameBoard.tiles[row][col]; // Truy cập ô ColorTile cụ thể

                return GestureDetector(
                  onTap: () => onTilePressed(tile),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tile.color,
                      border: Border.all(
                          color: tile.isSelected ? Colors.yellow : Colors.black,
                          width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Score: ${_player.score}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
