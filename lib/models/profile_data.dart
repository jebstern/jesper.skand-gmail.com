import 'dart:convert';

class ProfileData {
  List<Profile> profiles = [];

  ProfileData.fromList(List<dynamic>? json) {
    if (json != null) {
      profiles = [];
      for (var v in json) {
        profiles.add(Profile.fromJson(v));
      }
    }
  }
}

class Profile {
  String username = "";
  int wins = 0;
  int losses = 0;
  int draws = 0;

  Profile({
    required this.username,
    required this.wins,
    required this.losses,
    required this.draws,
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
