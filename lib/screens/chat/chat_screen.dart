import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_config.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  final String databaseName;
  final String targetUser;
  final String targetName;

  const ChatScreen({
    super.key,
    required this.databaseName,
    required this.targetUser,
    required this.targetName,
  });

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {
      late stt.SpeechToText _speech;

      bool _isListening = false;

  List<dynamic> messages = [];

  bool loading = true;

  Timer? refreshTimer;

  final TextEditingController
      messageController =
          TextEditingController();

  /// Unique chat id between two users
  String get referenceId {

    final users = [

      AppConfig.userId,
      widget.targetUser,

    ]..sort();

    return users.join("_");
  }

  @override
void initState() {
  super.initState();

  _speech = stt.SpeechToText();

  loadMessages();
  markAsRead();

  refreshTimer = Timer.periodic(
    const Duration(seconds: 3),
    (_) => loadMessages(),
  );
}

  @override
  void dispose() {

    refreshTimer?.cancel();

    messageController.dispose();

    super.dispose();
  }

  Future<void> loadMessages() async {

    try {

      final data =
          await ApiService.getChatMessages(

        databaseName:
            widget.databaseName,

        referenceId:
            referenceId,
      );

      if (mounted) {

        setState(() {

          messages = data;

          loading = false;
        });
      }

    } catch (e) {

      debugPrint(
        "Chat Load Error: $e",
      );
    }
  }

  Future<void> sendMessage() async {

    if (messageController.text
        .trim()
        .isEmpty) {
      return;
    }

    try {

      await ApiService.sendChatMessage(

        databaseName:
            widget.databaseName,

        referenceId:
            referenceId,

        fromUser:
            AppConfig.userId,

        toUser:
            widget.targetUser,

        message:
            messageController.text.trim(),
      );

      messageController.clear();

      await loadMessages();

    } catch (e) {

      debugPrint(
        "Send Message Error: $e",
      );
    }
  }

  Future<void> _listen() async {

  if (!_isListening) {

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "done") {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (error) {
        setState(() {
          _isListening = false;
        });
      },
    );

    if (available) {

      setState(() {
        _isListening = true;
      });

      _speech.listen(
        onResult: (result) {

          setState(() {

            messageController.text =
                result.recognizedWords;

            messageController.selection =
                TextSelection.fromPosition(
              TextPosition(
                offset: messageController.text.length,
              ),
            );
          });
        },
      );
    }

  } else {

    setState(() {
      _isListening = false;
    });

    _speech.stop();
  }
}

  Future<void> markAsRead() async {

  try {

    await ApiService.readChat(

      databaseName:
          widget.databaseName,

      currentUser:
          AppConfig.userId,

      targetUser:
          widget.targetUser,
    );

  } catch (e) {

    debugPrint(
      e.toString(),
    );
  }
}

  String formatTime(
      dynamic dateString) {

    try {

      final date =
          DateTime.parse(
        dateString.toString(),
      );

      return
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    } catch (_) {

      return "";
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF5F7FA,
      ),

      appBar: AppBar(

        backgroundColor:
            const Color(
          0xFF1565C0,
        ),

        foregroundColor:
            Colors.white,

        title: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              widget.targetName,
            ),

            Text(

              widget.targetUser,

              style:
                  const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child: loading

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : messages.isEmpty

                    ? const Center(
                        child: Text(
                          "No Messages",
                        ),
                      )

                    : ListView.builder(

                        reverse: true,

                        padding:
                            const EdgeInsets
                                .all(12),

                        itemCount:
                            messages.length,

                        itemBuilder:
                            (
                          context,
                          index,
                        ) {

                          final msg =
                              messages
                                  .reversed
                                  .toList()[index];

                          final isMe =
                              msg["FROMUSER"]
                                          ?.toString()
                                          .toUpperCase() ==
                                      AppConfig
                                          .userId
                                          .toUpperCase();

                          return Align(

                            alignment: isMe

                                ? Alignment
                                    .centerRight

                                : Alignment
                                    .centerLeft,

                            child:
                                Container(

                              margin:
                                  const EdgeInsets
                                      .only(
                                bottom: 10,
                              ),

                              padding:
                                  const EdgeInsets
                                      .all(
                                12,
                              ),

                              constraints:
                                  BoxConstraints(

                                maxWidth:
                                    MediaQuery.of(
                                                context)
                                            .size
                                            .width *
                                        0.75,
                              ),

                              decoration:
                                  BoxDecoration(

                                color: isMe

                                    ? const Color(
                                        0xFFDCF8C6,
                                      )

                                    : Colors
                                        .white,

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),

                                boxShadow: [

                                  BoxShadow(

                                    color:
                                        Colors.grey
                                            .shade300,

                                    blurRadius:
                                        2,
                                  ),
                                ],
                              ),

                              child:
                                  Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(

                                    isMe

                                        ? "You"

                                        : widget
                                            .targetName,

                                    style:
                                        const TextStyle(

                                      fontWeight:
                                          FontWeight
                                              .bold,

                                      fontSize:
                                          12,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(

                                    msg["MESSAGE"]
                                            ?.toString() ??
                                        "",
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  Align(

                                    alignment:
                                        Alignment
                                            .bottomRight,

                                    child: Text(

                                      formatTime(
                                        msg[
                                            "CREATEDON"],
                                      ),

                                      style:
                                          const TextStyle(

                                        fontSize:
                                            10,

                                        color:
                                            Colors
                                                .grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          Container(

            padding:
                const EdgeInsets
                    .all(10),

            color: Colors.white,

            child:Row(
  children: [

    CircleAvatar(
      radius: 24,
      backgroundColor:
          _isListening ? Colors.red : Colors.grey.shade200,
      child: IconButton(
        icon: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          color:
              _isListening ? Colors.white : Colors.black87,
        ),
        onPressed: _listen,
      ),
    ),

    const SizedBox(width: 8),

    Expanded(
      child: TextField(
        controller: messageController,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Type a message",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),

    const SizedBox(width: 8),

    CircleAvatar(
      radius: 24,
      backgroundColor: const Color(0xFF1565C0),
      child: IconButton(
        onPressed: sendMessage,
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    ),
  ],
),
          ),
        ],
      ),
    );
  }
}