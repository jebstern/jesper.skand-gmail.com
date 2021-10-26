import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/controller/controller.dart';
import 'package:tic_tac_toe/pages/home.dart';
import 'package:tic_tac_toe/service/api_service.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ApiService apiService = Get.put(ApiService(), permanent: true);
  final Controller controller = Get.put(Controller(), permanent: true);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: "Tic Tac Toe",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "IndieFlower",
      ),
      home: HomePage(),
    );
  }
}
