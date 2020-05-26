import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersmsapp/core/messageMethods.dart';
import 'package:fluttersmsapp/widgets/animatedOverlay.dart';
import 'package:sms/sms.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:vibration/vibration.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();

    getMessageData().then((List<MessageModel> res) {
      setState(() {
        messages = res;
      });
    });

    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage sms) async {
      List<MessageModel> tempMsgs = new List<MessageModel>.from(messages);
      MessageModel msg = await convertSmsToMessage(sms);

      tempMsgs.insert(0, msg);
      setState(() {
        messages = tempMsgs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      onRefresh: () async {
        List<MessageModel> res = await getMessageData();

        setState(() {
          messages = res;
        });
      },
      child: messages.length > 0
          ? new ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, i) => new Dismissible(
                    key: new Key(messages[i].id.toString()),
                    background: new Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20.0),
                      color: Colors.red,
                      child: new Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: new Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: new Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: new Column(
                      children: <Widget>[
                        new Divider(height: 10.0),
                        new ListTile(
                          leading: new CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: new Text(
                              messages[i].name[0],
                              style: new TextStyle(color: Colors.black),
                            ),
                          ),
                          title: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                messages[i].name,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),
                              new Text(
                                messages[i].time,
                                style: new TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          subtitle: new Container(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: new Text(
                              messages[i].message,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).overlay.insert(
                                  new AnimatedOverlay(
                                    title: new Text(
                                      messages[i].name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    content: new SingleChildScrollView(
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            messages[i].message,
                                            textAlign: TextAlign.left,
                                            style:
                                                new TextStyle(fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("Copy"),
                                        onPressed: () async {
                                          await ClipboardManager
                                              .copyToClipBoard(
                                            messages[i].message,
                                          );

                                          bool canVibrate =
                                              await Vibration.hasVibrator();

                                          if (canVibrate) {
                                            Vibration.vibrate(duration: 100);
                                          }
                                        },
                                      ),
                                    ],
                                  )(),
                                );
                          },
                        ),
                      ],
                    ),
                    onDismissed: (DismissDirection direction) {
                      MethodChannel methodChannel = const MethodChannel(
                        "channels.limitedeternity.com/main",
                      );

                      methodChannel.invokeMethod(
                        "deleteSMS",
                        <String, int>{"smsId": messages[i].id},
                      );

                      List<MessageModel> tempMsgs =
                          new List<MessageModel>.from(messages);

                      tempMsgs.removeAt(i);
                      setState(() {
                        messages = tempMsgs;
                      });
                    },
                  ),
            )
          : new ListView.builder(
              itemCount: 1,
              itemBuilder: (context, i) => new Column(
                    children: <Widget>[
                      new Divider(height: 10.0),
                      new ListTile(
                        title: new Align(
                          alignment: Alignment.topCenter,
                          child: new Container(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: new Text(
                              "No messages",
                              style: new TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
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
}
