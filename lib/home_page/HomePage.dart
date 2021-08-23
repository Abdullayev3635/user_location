import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_location/datamodals/user_location.dart';
import 'package:battery/battery.dart';

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
    getBattery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Location: Lat:${userLocation.latitude}, Long: ${userLocation.longitude}'),
            SizedBox(
              height: 50,
            ),
            Text('Power: $battery'),
          ],
        ),
      ),
    );
  }

  getBattery() async {
    battery = (await _battery.batteryLevel).toString();
  }
}
