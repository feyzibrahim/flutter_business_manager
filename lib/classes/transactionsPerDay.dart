import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  int initialBalance;
  int finalBalance;
  String date;
  String id;
  Timestamp timestamp;

  Transactions({
    @required this.initialBalance,
    @required this.finalBalance,
    @required this.date,
    @required this.id,
    @required this.timestamp,
  });
}
