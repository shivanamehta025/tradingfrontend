import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import 'all_users_screen.dart';
import 'chat_screen.dart';


class ChatUsersScreen extends StatefulWidget {
  const ChatUsersScreen({super.key});

  @override
  State<ChatUsersScreen> createState() =>
      _ChatUsersScreenState();
}

class _ChatUsersScreenState
    extends State<ChatUsersScreen> {

  List users = [];
  List filteredUsers = [];

  bool loading = true;

  final TextEditingController
      searchController =
          TextEditingController();

  @override
  void initState() {
    super.initState();

    loadUsers();

    searchController.addListener(() {
      searchUsers();
    });
  }

Future<void> loadUsers() async {
  users = await ApiService.getChatUsers(
    databaseName: AppConfig.databaseName,
    userId: AppConfig.userId,
  );

  filteredUsers = users;

  setState(() {
    loading = false;
  });
}

  void searchUsers() {

    final text =
        searchController.text
            .toLowerCase();

    setState(() {

      filteredUsers = users.where((u) {

        return u["USERNAME"]
                .toString()
                .toLowerCase()
                .contains(text) ||
            u["USERID"]
                .toString()
                .toLowerCase()
                .contains(text);

      }).toList();
    });
  }

  Color avatarColor(int index) {

    List<Color> colors = [

      Colors.blue,

      Colors.green,

      Colors.orange,

      Colors.purple,

      Colors.teal,

      Colors.red,
    ];

    return colors[
        index %
            colors.length];
  }

@override
Widget build(BuildContext context) {

  return Scaffold(

    backgroundColor: Colors.white,

    appBar: AppBar(

      backgroundColor: Colors.white,

      elevation: 0,

      centerTitle: false,

      title: const Text(

        "Chats",

        style: TextStyle(

          color: Colors.black,

          fontWeight: FontWeight.bold,

          fontSize: 28,
        ),
      ),

      actions: [

        IconButton(

          onPressed: () {},

          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),

        PopupMenuButton(

          icon: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),

          itemBuilder: (context) => [

            const PopupMenuItem(
              value: 1,
              child: Text("Refresh"),
            ),

            const PopupMenuItem(
              value: 2,
              child: Text("Settings"),
            ),
          ],
        ),
      ],
    ),

    floatingActionButton: FloatingActionButton(

      backgroundColor: const Color(0xff25D366),

      child: const Icon(
        Icons.chat,
        color: Colors.white,
      ),

      onPressed: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const AllUsersScreen(),
          ),
        );
      },
    ),

    body: loading

        ? const Center(
            child: CircularProgressIndicator(),
          )

        : ListView.separated(

            itemCount: filteredUsers.length,

            separatorBuilder: (_, __) => Divider(

              indent: 78,

              endIndent: 15,

              color: Colors.grey.shade300,

              height: 1,
            ),

            itemBuilder: (context, index) {

              final user = filteredUsers[index];

              return InkWell(

                onTap: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => ChatScreen(

                        databaseName:
                            AppConfig.databaseName,

                        targetUser:
                            user["USERID"],

                        targetName:
                            user["USERNAME"],
                      ),
                    ),
                  );
                },

                child: Padding(

                  padding: const EdgeInsets.symmetric(

                    horizontal: 15,

                    vertical: 12,
                  ),

                  child: Row(

                    children: [

                      Stack(

                        children: [

                          CircleAvatar(

                            radius: 28,

                            backgroundColor:
                                avatarColor(index),

                            child: Text(

                              user["USERNAME"]
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),

                              style: const TextStyle(

                                color: Colors.white,

                                fontWeight: FontWeight.bold,

                                fontSize: 20,
                              ),
                            ),
                          ),

                          Positioned(

                            bottom: 2,

                            right: 2,

                            child: Container(

                              width: 12,

                              height: 12,

                              decoration: BoxDecoration(

                                color: Colors.green,

                                border: Border.all(

                                  color: Colors.white,

                                  width: 2,
                                ),

                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 15),

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Row(

                              children: [

                                Expanded(

                                  child: Text(

                                    user["USERNAME"],

                                    style: const TextStyle(

                                      fontWeight:
                                          FontWeight.w600,

                                      fontSize: 17,
                                    ),
                                  ),
                                ),

                                Text(

                                  user["TIME"] ?? "",

                                  style: TextStyle(

                                    color: Colors.grey.shade600,

                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            Row(

                              children: [

                                Expanded(

                                  child: Text(

                                    user["LASTMESSAGE"] ??
                                        "Tap to chat",

                                    maxLines: 1,

                                    overflow:
                                        TextOverflow.ellipsis,

                                    style: TextStyle(

                                      color:
                                          Colors.grey.shade600,

                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                if ((user["UNREADCOUNT"] ?? 0) > 0)

                                  Container(

                                    padding:
                                        const EdgeInsets.all(6),

                                    decoration:
                                        const BoxDecoration(

                                      color: Color(0xff25D366),

                                      shape: BoxShape.circle,
                                    ),

                                    child: Text(

                                      user["UNREADCOUNT"]
                                          .toString(),

                                      style: const TextStyle(

                                        color: Colors.white,

                                        fontSize: 11,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}
}