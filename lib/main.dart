import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic tac toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tiles = ["", "", "", "", "", "", "", "", ""];
  String turn = "X";
  int playerWins = 0;
  int computerWins = 0;
  int draws = 0;
  Random random = new Random();
  AppBar appBar = AppBar(
    title: Text("Tic Tac Toe"),
  );
  double viewHeight = 0;

  @override
  Widget build(BuildContext context) {
    executeAfterBuild();
    return Scaffold(
      appBar: appBar,
      body: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = appBar.preferredSize.height;
    viewHeight =
        MediaQuery.of(context).size.height - statusBarHeight - appBarHeight;

    return Column(
      children: <Widget>[
        Container(
          height: viewHeight * 0.75,
          child: Column(
            children: _getTiles(),
          ),
        ),
        Container(
          height: viewHeight * 0.25,
          color: Colors.redAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Turn: " + (turn == "X" ? "Player" : "Computer"),
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      "Player wins: " + playerWins.toString(),
                    ),
                    Text(
                      "Computer wins: " + computerWins.toString(),
                    ),
                    Text(
                      "Draws: " + draws.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> executeAfterBuild() async {
    if (turn == "O") {
      Future.delayed(const Duration(milliseconds: 1000), () {
        int randomNumber = _getBestTileSelection();
        _setTileValue(randomNumber);
      });
    }
  }

  List<Widget> _getTiles() {
    return [
      Expanded(
        child: Row(
          children: <Widget>[
            _getTile(0),
            _getTile(1),
            _getTile(2),
          ],
        ),
      ),
      Expanded(
        child: Row(
          children: <Widget>[
            _getTile(3),
            _getTile(4),
            _getTile(5),
          ],
        ),
      ),
      Expanded(
        child: Row(
          children: <Widget>[
            _getTile(6),
            _getTile(7),
            _getTile(8),
          ],
        ),
      ),
    ];
  }

  Widget _getTile(int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _setTileValue(index);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              color: tiles[index] == ""
                  ? Colors.blueAccent
                  : (tiles[index] == "X"
                      ? Colors.redAccent
                      : Colors.greenAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    tiles[index],
                    style: TextStyle(
                      fontSize: (viewHeight * 0.75 / 3 - 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setTileValue(int index) {
    print("_setTileValue: " + index.toString());
    if (tiles[index] == "") {
      tiles[index] = turn;
      bool gameOver = _isGameOver();
      List<String> tilesCopy = List.from(tiles);
      tilesCopy.removeWhere((val) => val == "");
      print("Game over:" + gameOver.toString());
      if (gameOver) {
        _showGameOverDialog(turn == "X" ? "Player won!" : "Computer won!");
        _addWin();
      } else if (tilesCopy.length == 9) {
        _showGameOverDialog("It's a draw! How exciting...");
        _addDraw();
      } else {
        setState(() {
          turn = turn == "X" ? "O" : "X";
        });
      }
    }
  }

  bool _isGameOver() {
    // Horizontal
    if (tiles[0] == tiles[1] && tiles[0] == tiles[2] && tiles[0] != "") {
      return true;
    }
    if (tiles[3] == tiles[4] && tiles[3] == tiles[5] && tiles[3] != "") {
      return true;
    }
    if (tiles[6] == tiles[7] && tiles[6] == tiles[8] && tiles[6] != "") {
      return true;
    }

    // Vertical
    if (tiles[0] == tiles[3] && tiles[0] == tiles[6] && tiles[0] != "") {
      return true;
    }
    if (tiles[1] == tiles[4] && tiles[1] == tiles[7] && tiles[1] != "") {
      return true;
    }
    if (tiles[2] == tiles[5] && tiles[2] == tiles[8] && tiles[2] != "") {
      return true;
    }

    // Diagonal
    if (tiles[0] == tiles[4] && tiles[0] == tiles[8] && tiles[0] != "") {
      return true;
    }
    if (tiles[2] == tiles[4] && tiles[2] == tiles[6] && tiles[2] != "") {
      return true;
    }

    return false;
  }

  int _getBestTileSelection() {
    // Winning moves / Win game
    if (tiles[0] == tiles[3] && tiles[0] == "O" && tiles[6] == "") {
      return 6;
    }
    if (tiles[0] == tiles[4] && tiles[0] == "O" && tiles[8] == "") {
      return 8;
    }
    if (tiles[0] == tiles[1] && tiles[0] == "O" && tiles[2] == "") {
      return 2;
    }
    if (tiles[1] == tiles[4] && tiles[1] == "O" && tiles[7] == "") {
      return 7;
    }
    if (tiles[1] == tiles[2] && tiles[1] == "O" && tiles[0] == "") {
      return 0;
    }
    if (tiles[2] == tiles[4] && tiles[2] == "O" && tiles[6] == "") {
      return 6;
    }
    if (tiles[2] == tiles[5] && tiles[2] == "O" && tiles[8] == "") {
      return 8;
    }
    if (tiles[3] == tiles[4] && tiles[3] == "O" && tiles[5] == "") {
      return 5;
    }
    if (tiles[3] == tiles[6] && tiles[3] == "O" && tiles[0] == "") {
      return 0;
    }
    if (tiles[4] == tiles[5] && tiles[4] == "O" && tiles[3] == "") {
      return 3;
    }
    if (tiles[4] == tiles[6] && tiles[4] == "O" && tiles[2] == "") {
      return 2;
    }
    if (tiles[4] == tiles[7] && tiles[4] == "O" && tiles[1] == "") {
      return 1;
    }
    if (tiles[5] == tiles[8] && tiles[5] == "O" && tiles[2] == "") {
      return 2;
    }
    if (tiles[6] == tiles[7] && tiles[6] == "O" && tiles[8] == "") {
      return 8;
    }
    if (tiles[7] == tiles[8] && tiles[7] == "O" && tiles[6] == "") {
      return 6;
    }
    if (tiles[8] == tiles[4] && tiles[8] == "O" && tiles[0] == "") {
      return 0;
    }

    // Blocking moves / Don't let player win
    if (tiles[0] == tiles[3] && tiles[0] == "X" && tiles[6] == "") {
      return 6;
    }
    if (tiles[0] == tiles[4] && tiles[0] == "X" && tiles[8] == "") {
      return 8;
    }
    if (tiles[0] == tiles[1] && tiles[0] == "X" && tiles[2] == "") {
      return 2;
    }
    if (tiles[1] == tiles[4] && tiles[1] == "X" && tiles[7] == "") {
      return 7;
    }
    if (tiles[1] == tiles[2] && tiles[1] == "X" && tiles[0] == "") {
      return 0;
    }
    if (tiles[2] == tiles[4] && tiles[2] == "X" && tiles[6] == "") {
      return 6;
    }
    if (tiles[2] == tiles[5] && tiles[2] == "X" && tiles[8] == "") {
      return 8;
    }
    if (tiles[3] == tiles[4] && tiles[3] == "X" && tiles[5] == "") {
      return 5;
    }
    if (tiles[3] == tiles[6] && tiles[3] == "X" && tiles[0] == "") {
      return 0;
    }
    if (tiles[4] == tiles[5] && tiles[4] == "X" && tiles[3] == "") {
      return 3;
    }
    if (tiles[4] == tiles[6] && tiles[4] == "X" && tiles[2] == "") {
      return 2;
    }
    if (tiles[4] == tiles[7] && tiles[4] == "X" && tiles[1] == "") {
      return 1;
    }
    if (tiles[5] == tiles[8] && tiles[5] == "X" && tiles[2] == "") {
      return 2;
    }
    if (tiles[6] == tiles[7] && tiles[6] == "X" && tiles[8] == "") {
      return 8;
    }
    if (tiles[7] == tiles[8] && tiles[7] == "X" && tiles[6] == "") {
      return 6;
    }
    if (tiles[8] == tiles[4] && tiles[8] == "X" && tiles[0] == "") {
      return 0;
    }
    int randomNumber = random.nextInt(8);
    while (tiles[randomNumber] != "") {
      randomNumber = random.nextInt(8);
    }
    return randomNumber;
  }

  Future<void> _showGameOverDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game over'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  text,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  tiles = ["", "", "", "", "", "", "", "", ""];
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addWin() {
    setState(() {
      if (turn == "X") {
        playerWins++;
      } else {
        computerWins++;
      }
      turn = "X";
    });
  }

  void _addDraw() {
    setState(() {
      draws++;
      turn = "X";
    });
  }
}
