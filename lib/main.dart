import 'dart:async';
import 'package:flutter/material.dart';
import 'ColorTile.dart';
import 'GameBoard.dart';
import 'Player.dart';
import 'TargetSequence.dart';
import 'GameManager.dart';

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
  late final GameManager _gameManager;
  late Timer timer;
  int timeRemaining = 60;

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager(
      player: Player(),
      gameBoard: GameBoard(rows: 4, columns: 4),
      targetSequence: TargetSequence(),
    );
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
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
          content: Text('Your score: ${_gameManager.player.score}'),
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
      timeRemaining = 60;
      _gameManager.player.score = 0;
      _gameManager.gameBoard.refreshBoard();
      _gameManager.targetSequence.refreshSequence();
      _gameManager.tappedTiles.clear();
      startTimer();
    });
  }

  void onTilePressed(ColorTile tile) {
    setState(() {
      _gameManager.handleTileTap(tile);
    });
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
            children: _gameManager.targetSequence.currentTarget
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
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: _gameManager.gameBoard.tiles.length *
                  _gameManager.gameBoard.tiles[0].length,
              itemBuilder: (context, index) {
                final row = index ~/ _gameManager.gameBoard.tiles[0].length;
                final col = index % _gameManager.gameBoard.tiles[0].length;
                final tile = _gameManager.gameBoard.tiles[row][col];

                return GestureDetector(
                  onTap: () => onTilePressed(tile),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tile.color,
                      border: Border.all(
                          color: tile.isSelected ? Colors.white : Colors.black,
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
            'Score: ${_gameManager.player.score}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
