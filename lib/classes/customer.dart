import 'package:cloud_firestore/cloud_firestore.dart';

class MyCustomer {
  final int creditAmount;
  final String id;
  final String name;
  final String phoneNum;
  final Timestamp time;

  MyCustomer({
    this.creditAmount,
    this.id,
    this.name,
    this.phoneNum,
    this.time,
  });

  MyCustomer.fromSnapshot(DocumentSnapshot snapshot)
      : creditAmount = snapshot.data()['creditAmount'],
        id = snapshot.data()['id'],
        name = snapshot.data()['name'],
        phoneNum = snapshot.data()['phoneNum'],
        time = snapshot.data()['time'];
}
