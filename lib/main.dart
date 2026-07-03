import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/app_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/chat/chat_screen.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

RemoteMessage? initialMessage;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLoggedIn = false;

  try {
    // FIREBASE INIT
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey:
              "AIzaSyBSVRo_2IG8viufIbrs30N4y0GDmqQfYrY",
          appId:
              "1:63531580729:android:a676d6a63e63fec3cc3ce8",
          messagingSenderId:
              "63531580729",
          projectId:
              "trading-313cc",
          storageBucket:
              "trading-313cc.firebasestorage.app",
          authDomain:
              "trading-313cc.firebasestorage.app",
        ),
      );
    } else {
      await Firebase.initializeApp();
      FirebaseMessaging
    .onMessageOpenedApp
    .listen(

  (RemoteMessage message) {

    handleNotificationClick(
      message,
    );
  },
);
    }

    // READ SAVED LOGIN SESSION
    final prefs =
        await SharedPreferences.getInstance();

    isLoggedIn =
        prefs.getBool("isLoggedIn") ?? false;

    if (isLoggedIn) {
      AppConfig.userId =
          prefs.getString("userId") ?? "";

      AppConfig.userName =
          prefs.getString("userName") ?? "";

      AppConfig.allowedDatabases =
          prefs.getString(
                "allowedDatabases",
              ) ??
              "";
    }

    print("FIREBASE INITIALIZED");
  } catch (e) {
    print("FIREBASE INIT ERROR:");
    print(e);
  }

 initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();


  runApp(
    MyApp(
      isLoggedIn: isLoggedIn,
    ),
  );
}

void handleNotificationClick(RemoteMessage message) {
/* final context = navigatorKey.currentState?.overlay?.context;

if (context != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message.data.toString()),
    ),
  );
} */

  final data = message.data;

  if (data["type"] == "CHAT") {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          databaseName: data["databaseName"] ?? "",
          targetUser: data["fromUser"] ?? "",
          targetName: data["fromName"] ?? "",
        ),
      ),
    );
  }
}
class MyApp extends StatefulWidget {

  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  State<MyApp> createState() =>
      _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool openedFromNotification = false;

  @override
  Widget build(BuildContext context) {

    if (!openedFromNotification && initialMessage != null) {

      openedFromNotification = true;

      Future.microtask(() {
        
        handleNotificationClick(initialMessage!);
        initialMessage = null;
      });
    }

    return MaterialApp(
  navigatorKey: navigatorKey,

  debugShowCheckedModeBanner: false,

  title: "QSoftware",

  theme: ThemeData(
    useMaterial3: true,
  ),

  home: widget.isLoggedIn
      ? HomeScreen(
          userName: AppConfig.userName,
          userEmail: "",
        )
      : const SplashScreen(),
);
  }
}