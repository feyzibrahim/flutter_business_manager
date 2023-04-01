import 'package:business_manager/pages/subWidgets/eachDays.dart';
import 'package:business_manager/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/classes/transactionsPerDay.dart';

class DailyClassification extends StatefulWidget {
  @override
  _DailyClassificationState createState() => _DailyClassificationState();
}

class _DailyClassificationState extends State<DailyClassification> {
  String uid = AuthService().getUid();

  @override
  Widget build(BuildContext context) {
    Query myTransactionsCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Transaction')
        .orderBy('timestamp', descending: true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Daily Transations',
          ),
        ),
        body: StreamBuilder(
          stream: myTransactionsCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text("Loading"),
                  ],
                ),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No transaction is added.'),
                      Text('Go back to home and add Transaction'),
                    ],
                  ),
                );
              }
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var trans = snapshot.data.docs[index];
                Transactions transactions = Transactions(
                  initialBalance: trans['initialBal'],
                  finalBalance: trans['finalBal'],
                  date: trans['date'],
                  id: trans['id'],
                  timestamp: trans['timestamp'],
                );
                return EachDays(transactions: transactions);
              },
            );
          },
        ),
      ),
    );
  }
}
