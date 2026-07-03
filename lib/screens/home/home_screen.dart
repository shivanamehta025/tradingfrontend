import 'package:flutter/material.dart';

import '../../utils/app_config.dart';
import '../auth/login_screen.dart';
import '../branch/branch_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification/notification_screen.dart';
import '../../services/api_service.dart';
import '../dashboard/sales_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notificationCount = 0;
  bool get canShowTrading =>
      AppConfig.allowedDatabases
          .toUpperCase()
          .contains("TRADING");

  bool get canShowNationalTrader =>
      AppConfig.allowedDatabases
          .toUpperCase()
          .contains("NT");

  Future<void> selectTrading() async {

  AppConfig.selectedCompany = "Trading";
  AppConfig.databaseName = "Testing";

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const SalesDashboardScreen(),
    ),
  );
}

 Future<void> selectNationalTraders() async {

  AppConfig.selectedCompany =
      "National Traders";

  AppConfig.databaseName =
      "ac25";

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const SalesDashboardScreen(),
    ),
  );
}

Future<void> logout() async {
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.clear();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const LoginScreen(),
    ),
    (route) => false,
  );
}

@override
void initState() {
  super.initState();

  loadNotificationCount();
}

Future<void> loadNotificationCount() async {

  try {

    final count =
        await ApiService.getNotificationCount(

      userId: AppConfig.userId,

      allowedDatabases:
          AppConfig.allowedDatabases,
    );

    setState(() {
      notificationCount = count;
    });

  } catch (e) {

    debugPrint(
      "Notification Count Error: $e",
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF1F5F9),

      body: Column(
        children: [
          /// HEADER
          Container(
            decoration:
                const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF42A5F5),
                ],
              ),
            ),

            child: SafeArea(
              bottom: false,

              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  14,
                  20,
                  20,
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [
                    Row(
                      children: [
                        Container(
  width: 52,
  height: 52,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  padding: const EdgeInsets.all(6),
  child: Image.asset(
    'assets/logo.png',
    fit: BoxFit.contain,
  ),
),

                        const SizedBox(
                            width: 12),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                           const Text(
  "Q SOFTWARE",
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  ),
),
                           Text(
  "Smart Business Platform",
  style: TextStyle(
    color: Colors.white.withOpacity(0.85),
    fontSize: 12,
  ),
),
                          ],
                        ),
                      ],
                    ),

                   Row(
  children: [

    /// NOTIFICATION BELL
    GestureDetector(
      onTap: () async {

  await Navigator.push(

    context,

    MaterialPageRoute(
      builder: (_) =>
          const NotificationScreen(),
    ),
  );

  loadNotificationCount();
},

      child: Stack(
        children: [

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(0.20),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
          ),

         if (notificationCount > 0)

Positioned(
  right: 0,
  top: 0,

  child: Container(
    width: 18,
    height: 18,

    decoration:
        const BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
    ),

    child: Center(
      child: Text(

        notificationCount > 99
            ? "99+"
            : notificationCount.toString(),

        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    ),
  ),
),
             
        ],
      ),
    ),

    const SizedBox(width: 10),

    /// LOGOUT
    GestureDetector(
      onTap: logout,

      child: Container(
        width: 42,
        height: 42,

        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(
            0.20,
          ),

          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),

        child: const Icon(
          Icons.logout_rounded,
          color: Colors.white,
        ),
      ),
    ),
  ],
),
                  ],
                ),
              ),
            ),
          ),

          /// BODY
          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  /// Welcome
                  Row(
                    children: [
                      const Text(
                        "👋 ",
                        style:
                            TextStyle(
                          fontSize:
                              24,
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          style:
                              const TextStyle(
                            fontSize:
                                22,
                            color: Color(
                                0xFF1E293B),
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  "Welcome, ",
                            ),
                            TextSpan(
                              text: AppConfig
                                  .userName,
                              style:
                                  const TextStyle(
                                color: Color(
                                    0xFF1565C0),
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    "Select your company to continue",
                    style: TextStyle(
                      color:
                          Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  /// COMPANY CARDS
                  if (canShowTrading)
                    companyCard(
                      title: "Trading",
                      subtitle:
                          "Accounting Management",
                      icon: Icons
                          .trending_up_rounded,
                      onTap:
                          selectTrading,
                    ),

                  if (canShowNationalTrader)
                    companyCard(
                      title:
                          "National Traders",
                      subtitle:
                          "Trading Division",
                      icon: Icons
                          .business_center_rounded,
                      onTap:
                          selectNationalTraders,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget companyCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final gradient =
        title == "Trading"
            ? const [
                Color(0xFF0A3D8F),
                Color(0xFF1565C0),
                Color(0xFF1E88E5),
              ]
            : const [
                Color(0xFF0A5C2E),
                Color(0xFF1A7A40),
                Color(0xFF2EAA5C),
              ];

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 18,
        ),

        padding:
            const EdgeInsets.all(
          20,
        ),

        decoration:
            BoxDecoration(
          gradient:
              LinearGradient(
            colors: gradient,
            begin:
                Alignment.topLeft,
            end: Alignment
                .bottomRight,
          ),

          borderRadius:
              BorderRadius.circular(
            24,
          ),

          boxShadow: [
            BoxShadow(
              color: gradient.first
                  .withOpacity(
                0.35,
              ),
              blurRadius: 18,
              offset:
                  const Offset(
                0,
                8,
              ),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,

              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withOpacity(
                  0.18,
                ),

                borderRadius:
                    BorderRadius
                        .circular(
                  16,
                ),
              ),

              child: Icon(
                icon,
                color:
                    Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize:
                          22,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle,
                    style:
                        TextStyle(
                      color: Colors
                          .white
                          .withOpacity(
                        0.85,
                      ),
                      fontSize:
                          13,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Container(
                    width: 70,
                    height: 3,

                    decoration:
                        BoxDecoration(
                      color: Colors
                          .white
                          .withOpacity(
                        0.45,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 34,
              height: 34,

              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withOpacity(
                  0.18,
                ),

                borderRadius:
                    BorderRadius
                        .circular(
                  10,
                ),
              ),

              child: const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                size: 15,
                color:
                    Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}