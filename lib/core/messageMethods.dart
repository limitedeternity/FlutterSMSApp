import 'dart:async';
import 'package:fluttersmsapp/core/normalizeDate.dart';
import 'package:sms/sms.dart';
import 'package:sms/contact.dart';

class MessageModel {
  final int id;
  final String name;
  final String message;
  final String time;

  MessageModel({
    this.id,
    this.name,
    this.message,
    this.time,
  });
}

Future<MessageModel> convertSmsToMessage(SmsMessage sms) async {
  String formattedDate = normalizeDate(sms.date);

  String address = sms.address;
  ContactQuery contacts = new ContactQuery();
  Contact contact = await contacts.queryContact(address);
  String messageAddress =
      contact.fullName ?? contact.firstName ?? contact.lastName ?? address;

  return new MessageModel(
    id: sms.id,
    name: messageAddress,
    message: sms.body,
    time: formattedDate,
  );
}

Future<List<MessageModel>> getMessageData() async {
  SmsQuery query = new SmsQuery();
  List<SmsMessage> smsList = await query.querySms();
  List<MessageModel> messageList = [];

  for (SmsMessage sms in smsList) {
    MessageModel msg = await convertSmsToMessage(sms);
    messageList.add(msg);
  }

  return messageList;
}
