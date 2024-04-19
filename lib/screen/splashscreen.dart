import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:jeminiborma/screen/authentication/login.dart';
import 'package:jeminiborma/screen/authentication/registration.dart';
import 'package:jeminiborma/screen/db_selection.dart';
import 'package:jeminiborma/screen/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  bool isRegistered = false;

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

  navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? m_db = prefs.getString("multi_db");
    await Future.delayed(const Duration(seconds: 3), () async {
      isLoggedIn = await checkLogin();
      isRegistered = await checkRegistration();
      Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false, // set to false
              pageBuilder: (_, __, ___) {
                if (isRegistered) {
                  // return DBSelection();
                  if (m_db != "1") {
                    Provider.of<Controller>(context, listen: false)
                        .initDb(context, "");
                    return const LoginPage();
                  } else {
                    return const DBSelection();
                  }
                } else {
                  return const Registration();
                }
              }));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
            child: Column(
          children: [
            Expanded(
              child: Container(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    "assets/logo_black_bg.png",
                  )),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 8.0, bottom: 12),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         "VEGA BUSINESS SOFTWARE",
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 10,
            //             fontWeight: FontWeight.bold),
            //       )
            //       // Container(
            //       //     height: 50,
            //       //     // width: 150,
            //       //     child: Image.asset(
            //       //       "assets/logo_black_bg.png",
            //       //     )),
            //     ],
            //   ),
            // )
          ],
        )),
      ),
    );
  }
}

Color parseColor(String color) {
  print("Colorrrrr...$color");
  String hex = color.replaceAll("#", "");
  if (hex.isEmpty) hex = "ffffff";
  if (hex.length == 3) {
    hex =
        '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
  }
  Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
  return col;
}
