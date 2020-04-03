import 'package:flutter/material.dart';
import 'package:tic_tac_toe/tictactoe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tic Tac Toe",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "IndieFlower",
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
  List<String> names = ["Alex", "Bellamy", "Charlie", "Dakota"];
  String dropdownValue = "Alex";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign in",
        ),
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
              SizedBox(
                height: 12.0,
              ),
              Text(
                "Everything is simplified for demo purposes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
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
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
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
              SizedBox(
                height: 42.0,
              ),
              RaisedButton(
                onPressed: () {
                  _onLogin();
                },
                child: Text(
                  "Let's play",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).primaryColor,
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
      MaterialPageRoute(builder: (context) => TicTacToePage(player: dropdownValue,)),
    );
  }
}
