import 'package:flutter/material.dart';
import 'package:tic_tac_toe/pages/tictactoe.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> names = ["Alex", "Bellamy", "Charlie", "Dakota"];
  String dropdownValue = "Alex";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Account sign in",
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.account_circle),
                  iconSize: 24,
                  isExpanded: true,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue ?? "";
                    });
                  },
                  items: names.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "IndieFlower",
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 42.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                child: const Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(
                    "Let's play",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: _onLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicTacToePage(
          player: dropdownValue,
        ),
      ),
    );
  }
}
