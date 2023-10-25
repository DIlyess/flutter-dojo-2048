import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dojo_2048/tile.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: Scaffold(backgroundColor: Colors.orange, body: Board()),
    );
  }
}

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var board = <List<int>>[];
  @override
  void initState() {
    super.initState();
    board = newBoard();
  }

  List<List<int>> newBoard() {
    var randomBoard = [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
    ];

    var j = Random().nextInt(4);
    var i = Random().nextInt(4);

    randomBoard[i][j] = 2;
    return randomBoard;
  }

  void addnewTile() {
    var empty = List<List<int>>.empty(growable: true);
    // check if there is any empty cell and add it to empty list
    for (var i = 0; i < board.length; i++) {
      for (var j = 0; j < board.length; j++) {
        if (board[i][j] == 0) {
          empty.add([i, j]);
        }
      }
    }
    // pick a random empty cell in the list
    var randomIdx = Random().nextInt(empty.length);
    var i = empty[randomIdx][0];
    var j = empty[randomIdx][1];
    // add a new tile to the board
    board[i][j] = Random().nextInt(4) >= 1 ? 4 : 2;
  }

  void swipeUp() {
    for (var i = board.length - 1; i > 0; i--) {
      for (var j = 0; j < board.length; j++) {
        if (board[i][j] == board[i - 1][j]) {
          board[i - 1][j] += board[i - 1][j];
          board[i][j] = 0;
        } else if (board[i - 1][j] == 0) {
          board[i - 1][j] = board[i][j];
          board[i][j] = 0;
        }
      }
    }
  }

  void swipeDown() {
    for (var i = 0; i < board.length - 1; i++) {
      for (var j = 0; j < board.length; j++) {
        if (board[i][j] == board[i + 1][j]) {
          board[i + 1][j] += board[i + 1][j];
          board[i][j] = 0;
        } else if (board[i + 1][j] == 0) {
          board[i + 1][j] = board[i][j];
          board[i][j] = 0;
        }
      }
    }
  }

  void swipeLeft() {
    for (var i = 0; i < board.length; i++) {
      for (var j = board.length - 1; j > 0; j--) {
        if (board[i][j] == board[i][j - 1]) {
          board[i][j - 1] += board[i][j - 1];
          board[i][j] = 0;
        } else if (board[i][j - 1] == 0) {
          board[i][j - 1] = board[i][j];
          board[i][j] = 0;
        }
      }
    }
  }

  void swipeRight() {
    for (var i = 0; i < board.length; i++) {
      for (var j = 0; j < board.length - 1; j++) {
        if (board[i][j] == board[i][j + 1]) {
          board[i][j + 1] += board[i][j + 1];
          board[i][j] = 0;
        } else if (board[i][j + 1] == 0) {
          board[i][j + 1] = board[i][j];
          board[i][j] = 0;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SwipeDetector(
      onSwipeUp: (Offset position) {
        setState(() {
          swipeUp();
          addnewTile();
        });
      },
      onSwipeDown: (Offset position) {
        setState(() {
          swipeDown();
          addnewTile();
        });
      },
      onSwipeLeft: (Offset position) {
        setState(() {
          swipeLeft();
          addnewTile();
        });
      },
      onSwipeRight: (Offset position) {
        setState(() {
          swipeRight();
          addnewTile();
        });
      },
      child: Stack(
        children: [
          Center(
            child: Container(
              height: screenWidth / 2,
              width: screenWidth / 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: TableGrid(board, screenWidth),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 5, color: Colors.white)),
              child: MaterialButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Text("restart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    setState(() {
                      board = newBoard();
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class TableGrid extends StatelessWidget {
  const TableGrid(this.board, this.screenWidth, {super.key});
  final double screenWidth;
  final List<List<int>> board;

  @override
  Widget build(BuildContext context) {
    return Table(
        columnWidths: const <int, TableColumnWidth>{},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          for (var row in board)
            TableRow(
              children: <Widget>[
                for (var cell in row)
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Tile(cell),
                    ),
                  ),
              ],
            ),
        ]);
  }
}
