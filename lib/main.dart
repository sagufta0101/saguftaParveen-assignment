import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vivatech/login.dart';
import 'package:vivatech/splash.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "High_Importance_channel",
  "Notification",
  playSound: true,
  importance: Importance.high,
  showBadge: true,
);

final AndroidFlutterLocalNotificationsPlugin notificationsPlugin =
    AndroidFlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // AssetImage? assetImage;

  @override
  void initState() {
    // initPlatformState();
    super.initState();
  }

  // Future<void> initPlatformState() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();

  //   String? deviceId;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     deviceId = await PlatformDeviceId.getDeviceId;
  //     pref.setString('device_id', deviceId!);
  //   } on PlatformException {
  //     deviceId = 'Failed to get deviceId.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Assignment',
        home: SplashScreen()
        // Home(),
        // MyHomePage(),
        );
  }
}
