import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jeminiborma/controller/controller.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double topInsets = MediaQuery.of(context).viewInsets.top;
    Orientation ori = MediaQuery.of(context).orientation;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.yellow,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              right: 18,
            ),
            child: Form(
                key: _formKey,
                child: ori == Orientation.portrait
                    ? Column(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: size.height * 0.14,
                          ),
                          login_img(),
                          SizedBox(
                            height: size.height * 0.054,
                          ),
                          login_form(size, topInsets)
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            height: size.height * 0.14,
                          ),
                          Row(
                            children: [
                              Expanded(child: login_img()),
                              Expanded(
                                  flex: 1, child: login_form(size, topInsets))
                            ],
                          ),
                        ],
                      )),
          ),
        ),
      ),
    );
  }

  Column login_form(Size size, double topInsets) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width * 0.02,
            ),
            Text(
              "Login To Your Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        TextFormField(
          controller: username,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Please Enter Username';
            }
            return null;
          },
          scrollPadding:
              EdgeInsets.only(bottom: topInsets + size.height * 0.18),
          decoration: InputDecoration(
              // border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),

              // fillColor: Color.fromARGB(255, 235, 232, 232),
              // filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 119, 119, 119), width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 119, 119, 119), width: 1),
              ),
              prefixIcon: const Icon(Icons.person, size: 16),
              hintText: 'Username',
              hintStyle: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(
            valueListenable: _isObscure,
            builder: (context, values, child) {
              return TextFormField(
                controller: password,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
                scrollPadding:
                    EdgeInsets.only(bottom: topInsets + size.height * 0.18),
                obscureText: _isObscure.value,
                decoration: InputDecoration(
                    // border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),

                    // filled: true,
                    // fillColor: Color.fromARGB(255, 235, 232, 232),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 119, 119, 119), width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 119, 119, 119), width: 1),
                    ),
                    prefixIcon: const Icon(Icons.password, size: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      onPressed: () {
                        _isObscure.value = !_isObscure.value;
                        // print("_isObscure $_isObscure");
                      },
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(fontSize: 14)),
              );
            }),
        SizedBox(
          height: size.height * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Controller>(
              builder: (context, value, child) => Container(
                width: size.width * 0.44,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(50),
                // ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: StadiumBorder()),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // ignore: use_build_context_synchronously
                        // Provider.of<Controller>(context,
                        //                           listen: false)
                        //                       .initDb(context, "from login");


                        
                        Provider.of<Controller>(context, listen: false)
                            .getLogin(username.text, password.text, context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14.0, bottom: 14),
                      child: value.isLoginLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 16,
                            )
                          : Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white),
                            ),
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }

  Container login_img() {
    return Container(
        child: Image.asset(
      "assets/lo2.png",
      fit: BoxFit.contain,
    ));
  }
}
