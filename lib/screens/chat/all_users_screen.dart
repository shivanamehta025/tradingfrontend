import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import 'chat_screen.dart';

class AllUsersScreen extends StatefulWidget {

  const AllUsersScreen({
    super.key,
  });

  @override
  State<AllUsersScreen> createState() =>
      _AllUsersScreenState();
}

class _AllUsersScreenState
    extends State<AllUsersScreen> {

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
  }

Future<void> loadUsers() async {

  users =
      await ApiService.getAllUsers(

    databaseName:
        AppConfig.databaseName,
  );

  users.removeWhere(

    (x) =>
        x["USERID"]
            .toString()
            .toUpperCase() ==
        AppConfig.userId
            .toUpperCase(),
  );

  filteredUsers =
      List.from(users);

  setState(() {

    loading = false;
  });
}

  void searchUsers(
      String value) {

    setState(() {

      filteredUsers =
          users.where((user) {

        return user["USERNAME"]
                .toString()
                .toLowerCase()
                .contains(
                  value.toLowerCase(),
                ) ||

            user["USERID"]
                .toString()
                .toLowerCase()
                .contains(
                  value.toLowerCase(),
                );

      }).toList();
    });
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "New Chat",
        ),
      ),

      body: Column(

        children: [

          Padding(

            padding:
                const EdgeInsets.all(
              10,
            ),

            child: TextField(

              controller:
                  searchController,

              onChanged:
                  searchUsers,

              decoration:
                  InputDecoration(

                hintText:
                    "Search user...",

                prefixIcon:
                    const Icon(
                  Icons.search,
                ),

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ),

          Expanded(

            child: loading

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : filteredUsers
                        .isEmpty

                    ? const Center(
                        child: Text(
                          "No Users Found",
                        ),
                      )

                    : ListView.builder(

                        itemCount:
                            filteredUsers
                                .length,

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {

                          final user =
                              filteredUsers[
                                  index];

                          return ListTile(

                            leading:
                                CircleAvatar(

                              backgroundColor:
                                  Colors
                                      .blue,

                              child:
                                  Text(

                                user["USERNAME"]
                                    .toString()
                                    .substring(
                                        0,
                                        1)
                                    .toUpperCase(),

                                style:
                                    const TextStyle(

                                  color:
                                      Colors
                                          .white,
                                ),
                              ),
                            ),

                            title: Text(
                              user[
                                  "USERNAME"],
                            ),

                            subtitle:
                                Text(
                              user[
                                  "USERID"],
                            ),

                            onTap: () {

                              Navigator.push(

                                context,

                                MaterialPageRoute(

                                  builder:
                                      (_) =>
                                          ChatScreen(

                                    databaseName:
                                        AppConfig
                                            .databaseName,

                                    targetUser:
                                        user[
                                            "USERID"],

                                    targetName:
                                        user[
                                            "USERNAME"],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}