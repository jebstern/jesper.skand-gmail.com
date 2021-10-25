import 'dart:async';
import 'package:get/get_connect/connect.dart';
import 'package:tic_tac_toe/models/profile_data.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = "https://five06yr99.execute-api.eu-north-1.amazonaws.com/dev/";
  }

  Future<ProfileData> getProfiles() async {
    Response<dynamic> response = await get("all");
    return ProfileData.fromList(response.body);
  }

  Future<bool> updateProfile(Map data) async {
    Response<dynamic> response = await put("all", data);
    return response.status.code == 200;
  }
}
