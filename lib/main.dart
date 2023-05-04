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

  //recursion, but it has a bug

  // void addNewTile() {
  //   var row = Random().nextInt(4);
  //   var col = Random().nextInt(4);
  //   if (board[row][col] == 0) {
  //     setState(() {
  //       var board2 = board;
  //       board2[row][col] = (Random().nextInt(2) + 1) * 2;
  //       board = board2;
  //     });
  //     //print("add new tile in row $row, col $col");
  //   } else {
  //     addNewTile();
  //   }
  // }

  void addNewTile() {
    var emptyTiles = [];
    for (var row = 0; row < board.length; row++) {
      for (var col = 0; col < board[0].length; col++) {
        if (board[row][col] == 0) {
          emptyTiles.add([row, col]);
        }
      }
    }
    if (emptyTiles.isNotEmpty) {
      var randomTile = emptyTiles[Random().nextInt(emptyTiles.length)];
      var row = randomTile[0];
      var col = randomTile[1];
      board[row][col] = (Random().nextInt(2) + 1) * 2;
    }
  }

  void gameUpdate() {
    if (!gameWin()) {
      addNewTile();
      if (gameOver()) {
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
    for (var row = 0; row < board.length; row++) {
      for (var col = 0; col < board[0].length; col++) {
        if (board[row][col] == 0) {
          return false;
        }
        // Check the tile to the right
        if (col < board[0].length - 1 &&
            board[row][col] == board[row][col + 1]) {
          return false;
        }
        // Check the tile below
        if (row < board.length - 1 && board[row][col] == board[row + 1][col]) {
          return false;
        }
      }
    }
    return true;
  }

  void swipeRight() {
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
            padding: const EdgeInsets.all(80),
            child: Container(
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
                onPressed: () => setState(() {
                  board = newBoard();
                }),
              ),
            )),
        SwipeDetector(
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
                        return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Tile(value));
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
