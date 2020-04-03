import 'dart:convert';

class Profile {
  String username;
  int wins;
  int losses;
  int draws;

  Profile({
    this.username,
    this.wins,
    this.losses,
    this.draws,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    wins = json['wins'];
    losses = json['losses'];
    draws = json['draws'];
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'username': this.username,
      'wins': this.wins,
      'losses': this.losses,
      'draws': this.draws,
    });
  }
}
