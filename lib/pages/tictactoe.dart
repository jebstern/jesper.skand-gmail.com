import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/controller/controller.dart';
import 'package:tic_tac_toe/widgets/leaderboard.dart';

class TicTacToePage extends StatefulWidget {
  final String player;

  TicTacToePage({Key? key, required this.player}) : super(key: key);

  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  final Controller controller = Get.find();

  List<String> tiles = ["", "", "", "", "", "", "", "", ""];
  String turn = "X";
  int playerWins = 0;
  int computerWins = 0;
  int draws = 0;
  Random random = new Random();
  late AppBar appBar;
  double viewHeight = 0;
  bool moveAllowed = true;
  List<String> appbarActions = ["Leaderboard", "Upload", "Log out"];

  @override
  Widget build(BuildContext context) {
    appBar = AppBar(
      title: Text("Tic Tac Toe"),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (val) {
            if (val.toLowerCase() == "upload") {
              _uploadResults();
            } else if (val.toLowerCase() == "log out") {
              _logout();
            } else {
              controller.profileData = null;
              controller.getProfiles();
              showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return LeaderBoardDialog();
                  });
            }
          },
          itemBuilder: (BuildContext context) {
            return appbarActions.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ],
      automaticallyImplyLeading: false,
    );

    executeAfterBuild();
    return Scaffold(
      appBar: appBar,
      body: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = appBar.preferredSize.height;
    viewHeight = MediaQuery.of(context).size.height - statusBarHeight - appBarHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          children: List.generate(9, (index) {
            return _getTile(index);
          }),
        ),
        Container(
          color: Colors.redAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Turn: " + (turn == "X" ? widget.player : "Computer"),
                      style: TextStyle(fontSize: 32),
                    ),
                    Text("Player wins: " + playerWins.toString(), style: TextStyle(fontSize: 16)),
                    Text("Computer wins: " + computerWins.toString(), style: TextStyle(fontSize: 16)),
                    Text("Draws: " + draws.toString(), style: TextStyle(fontSize: 16)),
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
      Future.delayed(const Duration(milliseconds: 500), () {
        int randomNumber = _getBestTileSelection();
        _setTileValue(randomNumber);
      });
    }
  }

  Widget _getTile(int index) {
    return GestureDetector(
      onTap: () {
        if (moveAllowed) {
          setState(() {
            _setTileValue(index);
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tiles[index] == "" ? Colors.blueAccent : (tiles[index] == "X" ? Colors.redAccent : Colors.greenAccent)),
            color: tiles[index] == "" ? Colors.blueAccent : (tiles[index] == "X" ? Colors.redAccent : Colors.greenAccent),
          ),
          child: Column(
            children: [
              Expanded(
                child: tiles[index].isEmpty
                    ? Container()
                    : FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(tiles[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setTileValue(int index) {
    if (tiles[index] == "") {
      tiles[index] = turn;
      bool gameOver = _isGameOver();
      List<String> tilesCopy = List.from(tiles);
      tilesCopy.removeWhere((val) => val == "");
      if (gameOver) {
        _showGameOverDialog(turn == "X" ? "${widget.player} won!" : "Computer won!");
        _addWin();
      } else if (tilesCopy.length == 9) {
        _showGameOverDialog("It's a draw! How exciting ...");
        _addDraw();
      } else {
        setState(() {
          if (turn == "X") {
            moveAllowed = false;
            turn = "O";
          } else {
            turn = "X";
            moveAllowed = true;
          }
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
    Get.dialog(
      AlertDialog(
        title: Text("Game over"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                tiles = ["", "", "", "", "", "", "", "", ""];
              });
              Get.back();
            },
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
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
      moveAllowed = true;
    });
  }

  void _addDraw() {
    setState(() {
      draws++;
      turn = "X";
      moveAllowed = true;
    });
  }

  void _showDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Uploading results'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Please wait a few seconds ..."),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: LinearProgressIndicator(
                  value: null,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      barrierDismissible: false,
    );
  }

  void _uploadResults() async {
    _showDialog();
    Future.delayed(const Duration(seconds: 2), () {
      _uploadData();
    });
  }

  void _logout() => Get.back();

  Future<void> _uploadData() async {
    Map<String, dynamic> data = {
      "username": widget.player,
      "wins": playerWins,
      "losses": computerWins,
      "draws": draws,
    };

    bool isUpdated = await controller.updateProfile(data);

    Get.back();

    if (isUpdated) {
      setState(() {
        playerWins = 0;
        computerWins = 0;
        draws = 0;
      });
    }
  }
}
