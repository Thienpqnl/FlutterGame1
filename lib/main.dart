import 'package:flutter/material.dart';
import 'package:quocthien_app_pr/ColorTile.dart';
import 'package:quocthien_app_pr/GameBoard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Game Board',
      home: GameBoardScreen(),
    );
  }
}

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameBoardScreenState createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  late GameBoard gameBoard; // Bảng chơi

  @override
  void initState() {
    super.initState();
    gameBoard = GameBoard(rows: 4, columns: 4); // Tạo bảng 4x4
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Board')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gameBoard.columns,
                ),
                itemCount: gameBoard.rows * gameBoard.columns,
                itemBuilder: (context, index) {
                  int row = index ~/ gameBoard.columns;
                  int column = index % gameBoard.columns;

                  // Lấy ô tại vị trí (row, column)
                  ColorTile tile = gameBoard.getTile(row, column);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tile.selectTile(); // Đánh dấu ô được chọn
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      color: tile.isSelected ? Colors.grey : tile.color,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  gameBoard.refreshBoard(); // Làm mới bảng
                });
              },
              child: const Text('Refresh Board'),
            ),
          ],
        ),
      ),
    );
  }
}
