import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'tile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '2048',
      home: Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: Board(),
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<int>> board = newBoard();

  static List<List<int>> newBoard() {
    var list = List.generate(
      4,
      (row) => List.generate(
        4,
        (col) => 0,
      ),
    );
    var row = Random().nextInt(4);
    var col = Random().nextInt(4);
    list[row][col] = 2;
    return list;
  }

  void addNewTile() {
    var row = Random().nextInt(4);
    var col = Random().nextInt(4);
    if (board[row][col] == 0) {
      setState(() {
        var board2 = board;
        board2[row][col] = Random().nextInt(2) * 2;
        board = board2;
      });
      //print("add new tile in row $row, col $col");
    } else {
      addNewTile();
    }
  }

  void gameUpdate() {
    if (!gameWin()) {
      if (!gameOver()) {
        addNewTile();
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Game Over"),
                  content: const Text("You Lose"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            board = newBoard();
                          });
                        },
                        child: const Text("Play Again")),
                  ],
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Game Over"),
                content: const Text("You Win!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          board = newBoard();
                        });
                      },
                      child: const Text("Play Again")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Continue Playing")),
                ],
              ));
    }
  }

  bool gameWin() {
    for (var row in board) {
      for (var value in row) {
        if (value == 2048) {
          return true;
        }
      }
    }
    return false;
  }

  bool gameOver() {
    for (var row in board) {
      for (var value in row) {
        if (value == 0) {
          return false;
        }
      }
    }
    return false;
  }

  void swipeRight() {
    print("swipe right");
    setState(() {
      for (var row = 0; row < board.length; row++) {
        for (var col = board[row].length - 1; col > 0; col--) {
          for (var i = col - 1; i >= 0; i--) {
            if (board[row][i] == 0) {
              continue;
            }
            if (board[row][col] == 0) {
              board[row][col] = board[row][i];
              board[row][i] = 0;
            } else if (board[row][col] == board[row][i]) {
              board[row][col] *= 2;
              board[row][i] = 0;
            } else {
              break;
            }
          }
        }
      }
    });
    gameUpdate();
  }

  void swipeLeft() {
    print("swipe left");
    setState(() {
      for (var row = 0; row < board.length; row++) {
        for (var col = 0; col < board[row].length - 1; col++) {
          for (var i = col + 1; i < board[row].length; i++) {
            if (board[row][i] == 0) {
              continue;
            }
            if (board[row][col] == 0) {
              board[row][col] = board[row][i];
              board[row][i] = 0;
            } else if (board[row][col] == board[row][i]) {
              board[row][col] *= 2;
              board[row][i] = 0;
            } else {
              break;
            }
          }
        }
      }
    });
    gameUpdate();
  }

  void swipeUp() {
    print("swipe up");
    setState(() {
      for (var col = 0; col < board[0].length; col++) {
        for (var row = 0; row < board.length - 1; row++) {
          for (var i = row + 1; i < board.length; i++) {
            if (board[i][col] == 0) {
              continue;
            }
            if (board[row][col] == 0) {
              board[row][col] = board[i][col];
              board[i][col] = 0;
            } else if (board[row][col] == board[i][col]) {
              board[row][col] *= 2;
              board[i][col] = 0;
            } else {
              break;
            }
          }
        }
      }
    });
    gameUpdate();
  }

  void swipeDown() {
    print("swipe down");
    setState(() {
      for (var col = 0; col < board[0].length; col++) {
        for (var row = board.length - 1; row > 0; row--) {
          for (var i = row - 1; i >= 0; i--) {
            if (board[i][col] == 0) {
              continue;
            }
            if (board[row][col] == 0) {
              board[row][col] = board[i][col];
              board[i][col] = 0;
            } else if (board[row][col] == board[i][col]) {
              board[row][col] *= 2;
              board[i][col] = 0;
            } else {
              break;
            }
          }
        }
      }
    });
    gameUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SwipeDetector(
      onSwipeRight: (_) => swipeRight(),
      onSwipeLeft: (_) => swipeLeft(),
      onSwipeUp: (_) => swipeUp(),
      onSwipeDown: (_) => swipeDown(),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: screenWidth - 30,
            height: screenWidth - 30,
            child: Table(
              children: board.map((row) {
                return TableRow(
                  children: row.map((value) {
                    return Tile(value);
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
