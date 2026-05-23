import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {

  List<Map<String, dynamic>> notifications = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // LOAD NOTIFICATIONS
    loadNotifications();
  }

  Future<void> loadNotifications() async {

    final data =
        await ApiService.getNotifications();

    if (!mounted) return;

    setState(() {
      notifications = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notifications"),
      ),

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : notifications.isEmpty

              ? const Center(
                  child: Text(
                    "No notifications",
                  ),
                )

              : ListView.builder(

                  itemCount: notifications.length,

                  itemBuilder: (context, index) {

                    final item =
                        notifications[index];

                    return Container(

                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(

                        color:

                            item["is_read"] == true ||
                                    item["is_read"] == 1

                                ? Colors.white

                                : Colors.blue.shade50,

                        borderRadius:
                            BorderRadius.circular(16),

                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 1.2,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.blue.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Material(

                        color: Colors.transparent,

                        child: ListTile(

                          onTap: () async {

                            await ApiService
                                .markNotificationAsRead(
                              item["id"].toString(),
                            );

                            loadNotifications();
                          },

                          leading: CircleAvatar(

                            backgroundColor:

                                item["type"] ==
                                        "CHALLAN_APPROVED"

                                    ? Colors.green.shade100

                                    : Colors.red.shade100,

                            child: Icon(

                              item["type"] ==
                                      "CHALLAN_APPROVED"

                                  ? Icons.check

                                  : Icons.close,

                              color:
                                  item["type"] ==
                                          "CHALLAN_APPROVED"

                                      ? Colors.green

                                      : Colors.red,
                            ),
                          ),

                          title: Text(

                            item["title"] ?? "",

                            style: TextStyle(

                              fontWeight:

                                  item["is_read"] == true ||
                                          item["is_read"] == 1

                                      ? FontWeight.normal

                                      : FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            item["message"] ?? "",
                          ),

                          trailing: Column(

                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            crossAxisAlignment:
                                CrossAxisAlignment.end,

                            children: [

                              Text(

                                item["created_on"]
                                        ?.toString()
                                        .split("T")
                                        .first ??

                                    "",

                                style: const TextStyle(
                                  fontSize: 11,
                                ),
                              ),

                              const SizedBox(height: 4),

                              if (
                                  item["is_read"] != true &&
                                  item["is_read"] != 1
                              )

                                Container(

                                  width: 8,
                                  height: 8,

                                  decoration:
                                      const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}