import 'package:cloud_firestore/cloud_firestore.dart';

class Credit {
  final int amount;
  final String discription;
  final String id;
  final bool isCredit;
  final Timestamp timestamp;

  Credit({
    this.amount,
    this.discription,
    this.id,
    this.isCredit,
    this.timestamp,
  });
}
