import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_location/datamodals/user_location.dart';
import 'package:battery/battery.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _battery = Battery();
  String battery = "";

  // BatteryState? _batteryState;
  // late StreamSubscription<BatteryState> _batteryStateSubscription;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterBackgroundService.initialize(onStart);
    getBattery();
    super.initState();
  }

  void onStart() {
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();
    service.onDataReceived.listen((event) {
      if (event!["action"] == "setAsForeground") {
        service.setForegroundMode(true);
        return;
      }

      if (event["action"] == "setAsBackground") {
        service.setForegroundMode(false);
      }

      if (event["action"] == "stopService") {
        service.stopBackgroundService();
      }
    });

    // bring to foreground
    service.setForegroundMode(true);
    Timer.periodic(Duration(seconds: 2), (timer) async {
      if (!(await service.isServiceRunning())){
        timer.cancel();
        service.setNotificationInfo(
          title: "My App Service",
          content: "Updated at ${DateTime.now()}",
        );

        service.sendData(
          {"current_date": DateTime.now().toIso8601String()},
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    String text = "Stop Service";
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().onDataReceived,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data!;
                DateTime? date = DateTime.tryParse(data["current_date"]);
                return Text(date.toString());
              },
            ),
            ElevatedButton(
              child: Text("Foreground Mode"),
              onPressed: () {
                FlutterBackgroundService()
                    .sendData({"action": "setAsForeground"});
              },
            ),
            ElevatedButton(
              child: Text("Background Mode"),
              onPressed: () {
                FlutterBackgroundService()
                    .sendData({"action": "setAsBackground"});
              },
            ),
            ElevatedButton(
              child: Text(text),
              onPressed: () async {
                var isRunning =
                await FlutterBackgroundService().isServiceRunning();
                if (isRunning) {
                  FlutterBackgroundService().sendData(
                    {"action": "stopService"},
                  );
                } else {
                  FlutterBackgroundService.initialize(onStart);
                }
                if (!isRunning) {
                  text = 'Stop Service';
                } else {
                  text = 'Start Service';
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FlutterBackgroundService().sendData({
            "hello": "world",
          });
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  getBattery() async {
    battery = (await _battery.batteryLevel).toString();
  }
}
