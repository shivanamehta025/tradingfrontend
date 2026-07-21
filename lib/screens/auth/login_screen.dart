import 'dart:ui';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../home/home_screen.dart';
import '../../utils/app_config.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userIdCtrl =
      TextEditingController();

  final TextEditingController passwordCtrl =
      TextEditingController();

  bool obscure = true;
  bool isLoading = false;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
  final result = await ApiService.login(
  databaseName: "CMPY_Q",
  userId: userIdCtrl.text.trim(),
  password: passwordCtrl.text.trim(),
);

      if (!mounted) return;

    

      if (result != null &&
          result['success'] == true) {

            
             AppConfig.allowedDatabases =
      result['user']['SM63_14'] ?? '';

      AppConfig.userName =
    result['user']['sm63_6']
        ?.toString() ?? '';

      AppConfig.userId =
      result['user']['sm63_5']
          ?.toString() ?? '';

              AppConfig.designation =
      result['user']['sm61_6']
          ?.toString() ?? '';
      print("userid: ${AppConfig.userId}");
      print("username: ${AppConfig.userName}");
      print("designation: ${AppConfig.designation}");

      final token =
    await FirebaseMessaging.instance
        .getToken();

print("FCM TOKEN = $token");

if (token != null) {
print("SAVE TOKEN USERID = ${AppConfig.userId}");
print("SAVE TOKEN TOKEN = $token");
  await ApiService.saveDeviceToken(

    userId:AppConfig.userId,
    userName: AppConfig.userName,
    token: token,
    designation:AppConfig.designation,
  );
}

  print(
      "Allowed Databases: ${AppConfig.allowedDatabases}");
       // Save login session
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.setBool(
    "isLoggedIn",
    true,
  );

  await prefs.setString(
    "userId",
    AppConfig.userId,
  );

  await prefs.setString(
    "userName",
    AppConfig.userName,
  );

  await prefs.setString(
    "allowedDatabases",
    AppConfig.allowedDatabases,
  );

   await prefs.setString(
    "designation",
    AppConfig.designation,
  );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              userName:
                  result['userName'] ??
                  userIdCtrl.text.trim(),
              userEmail: '',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid User ID or Password',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Login Failed: $e',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    userIdCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF081B29),
              Color(0xFF0A2647),
              Color(0xFF144272),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 380,
                  margin:
                      const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15,
                        sigmaY: 15,
                      ),
                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          35,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withOpacity(
                            0.10,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            30,
                          ),
                          border: Border.all(
                            color: Colors.white
                                .withOpacity(
                              0.20,
                            ),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/logo.png",
                                height: 180,
                              ),

                              const SizedBox(
                                height: 40,
                              ),

                              TextFormField(
                                controller:
                                    userIdCtrl,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors
                                          .white,
                                ),
                                validator:
                                    (value) {
                                  if (value ==
                                          null ||
                                      value
                                          .trim()
                                          .isEmpty) {
                                    return 'Enter User ID';
                                  }
                                  return null;
                                },
                                decoration:
                                    inputDecoration(
                                  hint:
                                      "User ID",
                                  icon: Icons
                                      .person_outline,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              TextFormField(
                                controller:
                                    passwordCtrl,
                                obscureText:
                                    obscure,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors
                                          .white,
                                ),
                                validator:
                                    (value) {
                                  if (value ==
                                          null ||
                                      value
                                          .trim()
                                          .isEmpty) {
                                    return 'Enter Password';
                                  }
                                  return null;
                                },
                                decoration:
                                    inputDecoration(
                                  hint:
                                      "Password",
                                  icon: Icons
                                      .lock_outline,
                                  suffixIcon:
                                      IconButton(
                                    icon: Icon(
                                      obscure
                                          ? Icons
                                              .visibility_off
                                          : Icons
                                              .visibility,
                                      color: Colors
                                          .white70,
                                    ),
                                    onPressed:
                                        () {
                                      setState(
                                        () {
                                          obscure =
                                              !obscure;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 30,
                              ),

                              SizedBox(
                                width: double
                                    .infinity,
                                height: 55,
                                child:
                                    ElevatedButton(
                                  onPressed:
                                      isLoading
                                          ? null
                                          : login,
                                  style:
                                      ElevatedButton
                                          .styleFrom(
                                    backgroundColor:
                                        const Color(
                                      0xFF2196F3,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        16,
                                      ),
                                    ),
                                  ),
                                  child:
                                      isLoading
                                          ? const SizedBox(
                                              width:
                                                  22,
                                              height:
                                                  22,
                                              child:
                                                  CircularProgressIndicator(
                                                color:
                                                    Colors.white,
                                                strokeWidth:
                                                    2,
                                              ),
                                            )
                                          : const Text(
                                              "LOGIN",
                                              style:
                                                  TextStyle(
                                                fontSize:
                                                    16,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                ),
                              ),

                              const SizedBox(
                                height: 25,
                              ),

                              Text(
                                "© 2026 All Rights Reserved",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.7,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              const Text(
                                "GULJAG INFOTECH",
                                style:
                                    TextStyle(
                                  color:
                                      Colors
                                          .white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color:
            Colors.white.withOpacity(0.7),
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor:
          Colors.white.withOpacity(0.10),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class BackgroundPainter
    extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;

    for (double i = -size.height;
        i < size.width;
        i += 45) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(
          i + size.height,
          size.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      CustomPainter oldDelegate) {
    return false;
  }
}