import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:jeminiborma/screen/authentication/registration.dart';
import 'package:jeminiborma/screen/home_page.dart';
import 'package:jeminiborma/screen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

bool isLoggedIn = false;
bool isRegistered = false;
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  isLoggedIn = await checkLogin();
  isRegistered = await checkRegistration();
  requestPermission();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
      // ChangeNotifierProvider(create: (_) => RegistrationController()),
    ],
    child: const MyApp(),
  ));
  // FlutterNativeSplash.remove();
}

checkRegistration() async {
  bool isAuthenticated = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString("st_uname", "anu");
  // prefs.setString("st_pwd", "anu");
  final cid = prefs.getString("cid");
  if (cid != null) {
    isAuthenticated = true;
  } else {
    isAuthenticated = false;
  }
  return isAuthenticated;
}

checkLogin() async {
  bool isAuthenticated = false;
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final stUname = prefs.getString("st_uname");
  final stPwd = prefs.getString("st_pwd");

  if (stUname != null && stPwd != null) {
    isAuthenticated = true;
  } else {
    isAuthenticated = false;
  }
  return isAuthenticated;
}

void requestPermission() async {
  var sta = await Permission.storage.request();
  var status = Platform.isIOS
      ? await Permission.photos.request()
      : await Permission.manageExternalStorage.request();
  if (status.isGranted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isDenied) {
    await Permission.manageExternalStorage.request();
  } else if (status.isRestricted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Color.fromARGB(255, 102, 76, 175),
            secondaryHeaderColor: Color.fromARGB(255, 219, 218, 218)),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
