import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_manager/pages/newTransaction.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/services/database.dart';
import 'package:business_manager/classes/transaction.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = AuthService().getUid();
  var date = DateTime.now();
  var spc = '${CommenService().getSDate()}T00:00:00.000+00:00';

  @override
  Widget build(BuildContext context) {
    var aaa = DateTime.parse(spc);
    var timest = Timestamp.fromDate(aaa);

    Query trans = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Trans')
        .orderBy('time', descending: true)
        .where('time', isGreaterThan: timest);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTransaction(),
            ),
          );
        },
      ),
      body: StreamBuilder(
        stream: trans.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    Text('Click the add button to add transaction'),
                  ],
                ),
              );
            }
          }

          return ListView.separated(
            separatorBuilder: (context, _) => Divider(height: 0.0),
            itemCount: snapshot.data.docs.length,
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
                subtitle:
                    CommenService().formatedTime(myTransaction.time.toDate()),
                trailing: Text(
                  '${myTransaction.amount} ₹',
                  style: TextStyle(
                    color: CommenService().chooseTypeColor(myTransaction),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  showBottomSheet(
                    backgroundColor: Colors.grey[800],
                    context: context,
                    builder: (context) => bottomSheetContainer(myTransaction),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget bottomSheetContainer(MyTransaction myTransaction) {
    return Container(
      padding: EdgeInsets.all(30.0),
      height: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${myTransaction.amount} ₹',
                style: TextStyle(
                  color: CommenService().chooseTypeColor(myTransaction),
                  fontSize: 30.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                myTransaction.type,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Text(
            myTransaction.discription,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 5.0),
          Text(
            CommenService().formatedTimeAndDate(myTransaction.time.toDate()),
            style: TextStyle(color: Colors.white),
          ),
          Expanded(child: Container()),
          Container(
            color: AdaptiveTheme.of(context).mode.isDark
                ? Colors.grey[900]
                : Colors.white,
            child: FlatButton.icon(
              icon: Icon(Icons.delete),
              padding: EdgeInsets.all(15.0),
              label: Text('Delete'),
              onPressed: () {
                if (myTransaction.customerId == null) {
                  deleteOnlyTransaction(myTransaction);
                } else {
                  showWarning(context, myTransaction);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  showWarning(BuildContext context, MyTransaction myTransaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attention'),
          content: Text(
              'This will not be deleted from Credit Section. Do you want to delete?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                deleteOnlyTransaction(myTransaction);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void deleteOnlyTransaction(MyTransaction myTransaction) {
    DatabaseService()
        .deleteTransaction(myTransaction.id, 'Trans')
        .then((value) {
      DatabaseService()
          .checkTodays(-myTransaction.amount, myTransaction.type, true);
      Navigator.pop(context);
    });
  }
}
