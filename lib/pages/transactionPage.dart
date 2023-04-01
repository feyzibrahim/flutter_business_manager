import 'package:business_manager/services/commen.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/services/database.dart';
import 'package:business_manager/classes/transaction.dart';
import 'package:business_manager/classes/transactionsPerDay.dart';
import 'package:business_manager/pages/subWidgets/initial&Final.dart';

class TransactionPage extends StatefulWidget {
  final Transactions transactions;
  TransactionPage({
    this.transactions,
  });

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String uid = AuthService().getUid();

  @override
  Widget build(BuildContext context) {
    Query mySubtransactionCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Trans')
        .where('date', isEqualTo: '${widget.transactions.date}')
        .orderBy('time', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'Delete') {
                showWarning(context);
              } else {}
            },
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: mySubtransactionCollection.snapshots(),
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

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: InitailFinal(transactions: widget.transactions),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Text('Todays Transaction'),
                ),
                Divider(
                  height: 1,
                  thickness: 2.0,
                ),
                ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  separatorBuilder: (context, _) => Divider(height: 1.0),
                  itemBuilder: (context, index) {
                    var trans = snapshot.data.docs[index];
                    MyTransaction myTransaction = MyTransaction(
                      amount: trans['amount'],
                      date: trans['date'],
                      discription: trans['discription'],
                      id: trans['id'],
                      time: trans['time'],
                      type: trans['type'],
                      customerId: trans['customerId'],
                    );
                    return ListTile(
                      title: Text(
                        myTransaction.discription,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${myTransaction.amount} ₹',
                            style: TextStyle(
                              color: CommenService()
                                  .chooseTypeColor(myTransaction),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          CommenService()
                              .formatedTime(myTransaction.time.toDate()),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  showWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to delete the entire transaction?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                DatabaseService()
                    .deleteTransaction(widget.transactions.id, 'Transaction')
                    .then((_) => {
                          Navigator.popUntil(context, (route) => route.isFirst)
                        });
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
