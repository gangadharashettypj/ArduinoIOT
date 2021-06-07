/*
 * @Author GS
 */
import 'dart:async';

import 'package:arduinoiot/resources/nestbees_resources.dart';
import 'package:arduinoiot/service/manager/device_manager.dart';
import 'package:chat_list/chat_list.dart';
import 'package:chat_list/models/owner_type_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<MessageModel> _messageList = [
    MessageModel("Hi, welcome to iOT Chat?", OwnerType.SENDER,
        ownerName: "System"),
  ];
  StreamController<MessageModel> streamController = StreamController();
  @override
  void initState() {
    super.initState();
    startListening();
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: StreamBuilder<MessageModel>(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) _messageList.add(snapshot.data);
                  return ChatList(
                    messageList: _messageList,
                  );
                },
              ),
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter your message...',
                  border: InputBorder.none,
                  alignLabelWithHint: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: R.color.primary,
                    ),
                    onPressed: () {
                      print(controller.text);
                      DeviceManager().sendData(
                        R.api.chat,
                        params: {
                          'msg': controller.text,
                        },
                      );
                      streamController.add(
                        MessageModel(
                          controller.text,
                          OwnerType.SENDER,
                          ownerName: 'You',
                        ),
                      );
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => controller.clear());
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startListening() async {
    DeviceManager().listenForData(R.api.chat, (Map<String, String> response) {
      streamController.add(
        MessageModel(
          response['msg'],
          OwnerType.RECEIVER,
          ownerName: response['name'],
        ),
      );
    });
  }
}
