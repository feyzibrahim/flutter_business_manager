import 'package:cloud_firestore/cloud_firestore.dart';

class MyTransaction {
  final String id;
  final int amount;
  final String discription;
  final String type;
  final Timestamp time;
  final String date;
  final String customerId;

  MyTransaction({
    this.id,
    this.amount,
    this.discription,
    this.type,
    this.time,
    this.date,
    this.customerId,
  });
}
