import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_toe/profile.dart';
import 'dart:convert';

class LeaderBoardDialog extends StatefulWidget {
  LeaderBoardDialog({Key key}) : super(key: key);

  @override
  _LeaderBoardDialogState createState() => _LeaderBoardDialogState();
}

class _LeaderBoardDialogState extends State<LeaderBoardDialog> {
  bool _isLoading = true;
  List<Profile> _profiles = List();

  @override
  void initState() {
    super.initState();
    _getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _getDialogContent(context),
        ),
      ),
    );
  }

  List<Widget> _getLeaderboardRowItems() {
    List<Widget> list = List();

    for (var i = 0; i < _profiles.length; i++) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "${i + 1}",
                style: TextStyle(
                  fontSize: 32,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                  backgroundImage: Image.asset("assets/user${i + 1}.png").image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "${_profiles[i].username}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "${_profiles[i].wins}W - ${_profiles[i].losses}L - ${_profiles[i].draws}D",
              ),
            ],
          ),
        ],
      ));
      list.add(Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Divider(
          color: Colors.grey,
        ),
      ));
    }

    return list;
  }

  List<Widget> _getDialogContent(BuildContext context) {
    List<Widget> list = List();
    list.add(Text(
      "Leaderboard",
      style: TextStyle(
        inherit: true,
        fontSize: 42.0,
        fontStyle: FontStyle.italic,
        color: Colors.pink,
        shadows: [
          Shadow(
            // bottomLeft
            offset: Offset(-1.5, -1.5),
            color: Theme.of(context).primaryColor,
          ),
          Shadow(
            // bottomRight
            offset: Offset(1.5, -1.5),
            color: Theme.of(context).primaryColor,
          ),
          Shadow(
            // topRight
            offset: Offset(1.5, 1.5),
            color: Theme.of(context).primaryColor,
          ),
          Shadow(
            // topLeft
            offset: Offset(-1.5, 1.5),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    ));
    list.add(SizedBox(
      height: 22,
    ));

    if (_isLoading) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Loading data..."),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CircularProgressIndicator(
              value: null,
            ),
          )
        ],
      ));
    } else {
      list.add(Column(
        children: _getLeaderboardRowItems(),
      ));
    }

    list.add(SizedBox(
      height: 32,
    ));
    list.add(RaisedButton(
      child: Text(
        "Close",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      onPressed: () {
        Navigator.pop(context, null);
      },
    ));

    return list;
  }

  void _getProfiles() async {
    final response =
        // await http.get('http://192.168.10.38:3000/tic-tac-toe/all');
        await http.get('https://tic-tac-toe-be.herokuapp.com/tic-tac-toe/all');
    if (response.statusCode == 200) {
      var profiles = List<Profile>.from(
          json.decode(response.body).map((x) => Profile.fromJson(x)));
      profiles
          .sort((profile1, profile2) => profile2.wins.compareTo(profile1.wins));
      setState(() {
        _isLoading = false;
        _profiles = profiles;
      });
    }
  }
}
