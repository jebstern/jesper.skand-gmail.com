import 'package:get/get.dart';
import 'package:tic_tac_toe/models/profile_data.dart';
import 'package:tic_tac_toe/service/api_service.dart';

class Controller extends GetxController {
  static Controller get to => Get.find();
  final ApiService _httpService = Get.find();
  ProfileData? profileData;

  Future<void> getProfiles() async {
    profileData = await _httpService.getProfiles();
    profileData!.profiles.sort((profile1, profile2) => profile2.wins.compareTo(profile1.wins));
    update();
  }

  Future<bool> updateProfile(Map data) async => await _httpService.updateProfile(data);
}
