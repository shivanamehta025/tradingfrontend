import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import '../chat/chat_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {

  List<dynamic> notifications = [];
List<dynamic> filteredNotifications = [];

String selectedFilter = "ALL";

List<Map<String, String>> availableCompanies = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {

  try {

    notifications =
        await ApiService.getNotifications(
      userId: AppConfig.userId,
      allowedDatabases:
          AppConfig.allowedDatabases,
    );

    // ==========================
    // STEP 2 STARTS HERE
    // ==========================

    availableCompanies.clear();

    availableCompanies.add({
      "code": "ALL",
      "name": "All",
    });

    final dbs =
        AppConfig.allowedDatabases.split(",");

    for (var db in dbs) {

      if (db.trim() == "TRADING") {

        availableCompanies.add({
          "code": "Testing",
          "name": "Trading",
        });
      }

      if (db.trim() == "NT") {

        availableCompanies.add({
          "code": "ac25",
          "name": "National Traders",
        });
      }
    }

    filteredNotifications =
        List.from(notifications);

    // ==========================
    // STEP 2 ENDS HERE
    // ==========================

  } catch (e) {

    debugPrint(e.toString());
  }

  setState(() {
    loading = false;
  });
}

void applyFilter(String dbName) {

  setState(() {

    selectedFilter = dbName;

    if (dbName == "ALL") {

      filteredNotifications =
          List.from(notifications);

    } else {

      filteredNotifications =
          notifications.where((x) {

        return x["DATABASENAME"]
            .toString()
            .toLowerCase() ==
            dbName.toLowerCase();

      }).toList();
    }
  });
}

  @override
  Widget build(BuildContext context) {

    final Map<String, String> companyMap = {

  "Testing": "Trading",

  "ac25": "National Traders",
};

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F7FA),

      appBar: AppBar(

        title: const Text(
          "Notifications",
        ),

        centerTitle: true,
      ),

body: loading

    ? const Center(
        child: CircularProgressIndicator(),
      )

    : notifications.isEmpty

        ? const Center(
            child: Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )

        : RefreshIndicator(

            onRefresh: loadNotifications,

            child: Column(

              children: [

                // =========================
                // COMPANY FILTER CHIPS
                // =========================

                SizedBox(

                  height: 55,

                  child: ListView.builder(

                    scrollDirection:
                        Axis.horizontal,

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    itemCount:
                        availableCompanies.length,

                    itemBuilder:
                        (context, index) {

                      final company =
                          availableCompanies[index];

                      return Padding(

                        padding:
                            const EdgeInsets.only(
                          right: 8,
                        ),

                        child: ChoiceChip(

                          label: Text(
                            company["name"]!,
                          ),

                          selected:
                              selectedFilter ==
                                  company["code"],

                          onSelected: (_) {

                            applyFilter(
                              company["code"]!,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                // =========================
                // NOTIFICATION LIST
                // =========================

                Expanded(

                  child: ListView.builder(

                    padding:
                        const EdgeInsets.all(12),

                    itemCount:
                        filteredNotifications.length,

                    itemBuilder:
                        (context, index) {

                      final item =
                          filteredNotifications[index];

                      final isRead =
                          item["ISREAD"] == 1 ||
                          item["ISREAD"] == true ||
                          item["ISREAD"]
                                  ?.toString() ==
                              "1";

                      return Card(

                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),

                        elevation:
                            isRead ? 1 : 3,

                        color: isRead
                            ? Colors.grey.shade100
                            : const Color(
                                0xFFFFF4F4),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),

                        child: ListTile(

                          contentPadding:
                              const EdgeInsets.all(
                            12,
                          ),

                       onTap: () async {

  if (!isRead) {

    await ApiService
        .markNotificationRead(

      id: item["ID"],

      databaseName:
          item["DATABASENAME"],
    );

    setState(() {

      item["ISREAD"] = 1;
    });
  }

  // CHAT NOTIFICATION

  if (item["DOCUMENTTYPE"] ==
      "CHAT") {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => ChatScreen(

          databaseName:
              item["DATABASENAME"],

          targetUser:
              item["FROMUSER"],

          targetName:
              item["TITLE"],
        ),
      ),
    );
  }
},

                          leading:
                              CircleAvatar(

                            radius: 24,

                            backgroundColor:
                                isRead
                                    ? Colors.grey
                                        .shade300
                                    : Colors.blue
                                        .shade100,

                            child: Icon(

                              Icons.notifications,

                              color: isRead
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                          ),

                          title: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              // COMPANY NAME

                              Text(

  companyMap[
      item["DATABASENAME"]] ??
      item["DATABASENAME"],

  style: const TextStyle(

    color: Colors.blue,

    fontSize: 11,

    fontWeight: FontWeight.w600,
  ),
),

                              const SizedBox(
                                height: 3,
                              ),

                              Row(

                                children: [

                                  Expanded(

                                    child: Text(

                                      item["TITLE"] ??
                                          "",

                                      style:
                                          TextStyle(

                                        fontWeight:
                                            isRead
                                                ? FontWeight
                                                    .normal
                                                : FontWeight
                                                    .bold,

                                        color:
                                            isRead
                                                ? Colors
                                                    .grey
                                                : Colors
                                                    .black,
                                      ),
                                    ),
                                  ),

                                  InkWell(

                                    onTap: () {

                                      Navigator.push(

                                        context,

                                        MaterialPageRoute(

                                          builder: (_) =>
                                             ChatScreen(

  databaseName:
      item["DATABASENAME"],

  targetUser:
      item["USERID"],

  targetName:
      item["USERID"],
),
                                        ),
                                      );
                                    },

                                    child:
                                        Container(

                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            8,
                                        vertical: 4,
                                      ),

                                      decoration:
                                          BoxDecoration(

                                        color: Colors
                                            .blue
                                            .shade50,

                                        borderRadius:
                                            BorderRadius.circular(
                                          8,
                                        ),
                                      ),

                                      child:
                                          const Row(

                                        mainAxisSize:
                                            MainAxisSize
                                                .min,

                                        children: [

                                          Icon(
                                            Icons
                                                .chat_bubble_outline,
                                            size: 14,
                                            color:
                                                Colors
                                                    .blue,
                                          ),

                                          SizedBox(
                                              width:
                                                  4),

                                          Text(

                                            "Chat",

                                            style:
                                                TextStyle(

                                              color:
                                                  Colors
                                                      .blue,

                                              fontSize:
                                                  11,

                                              fontWeight:
                                                  FontWeight
                                                      .w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          subtitle: Padding(

                            padding:
                                const EdgeInsets.only(
                              top: 6,
                            ),

                            child: Text(

                              item["MESSAGE"] ??
                                  "",

                              style: TextStyle(

                                color:
                                    isRead
                                        ? Colors.grey
                                        : Colors.black87,
                              ),
                            ),
                          ),

                          trailing: Column(

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      8,
                                  vertical: 4,
                                ),

                                decoration:
                                    BoxDecoration(

                                  color: isRead
                                      ? Colors.grey
                                          .shade300
                                      : Colors.red
                                          .shade100,

                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),

                                child: Text(

                                  isRead
                                      ? "READ"
                                      : "NEW",

                                  style:
                                      TextStyle(

                                    color:
                                        isRead
                                            ? Colors
                                                .black54
                                            : Colors
                                                .red,

                                    fontSize:
                                        10,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Text(

                                item["CREATEDON"]
                                        ?.toString()
                                        .substring(
                                            0, 10) ??
                                    "",

                                style:
                                    const TextStyle(

                                  fontSize: 10,

                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}