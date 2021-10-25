import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/controller/controller.dart';

class LeaderBoardDialog extends StatelessWidget {
  const LeaderBoardDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (controller) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _getDialogContent(controller, context),
          ),
        ),
      ),
    );
  }

  List<Widget> _getDialogContent(Controller controller, BuildContext buildContext) {
    List<Widget> list = [];
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
            color: Theme.of(buildContext).primaryColor,
          ),
          Shadow(
            // bottomRight
            offset: Offset(1.5, -1.5),
            color: Theme.of(buildContext).primaryColor,
          ),
          Shadow(
            // topRight
            offset: Offset(1.5, 1.5),
            color: Theme.of(buildContext).primaryColor,
          ),
          Shadow(
            // topLeft
            offset: Offset(-1.5, 1.5),
            color: Theme.of(buildContext).primaryColor,
          ),
        ],
      ),
    ));
    list.add(SizedBox(
      height: 22,
    ));

    if (controller.profileData == null) {
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
        children: _getLeaderboardRowItems(controller),
      ));
    }

    list.add(SizedBox(
      height: 32,
    ));

    list.add(ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Text(
          "Close",
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () => Get.back(),
    ));

    return list;
  }

  List<Widget> _getLeaderboardRowItems(Controller controller) {
    List<Widget> list = [];
    for (var i = 0; i < controller.profileData!.profiles.length; i++) {
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
                  "${controller.profileData!.profiles[i].username}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "${controller.profileData!.profiles[i].wins}W - ${controller.profileData!.profiles[i].losses}L - ${controller.profileData!.profiles[i].draws}D",
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
}
