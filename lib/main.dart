import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_location/home_page/HomePage.dart';
import 'package:user_location/services/location_service.dart';

import 'datamodals/user_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  UserLocation getL(){
    return UserLocation(latitude: 40.5256456445, longitude: 71.56465465445);
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: HomePage(),
      ),
      initialData: getL(),
    );
  }
}
