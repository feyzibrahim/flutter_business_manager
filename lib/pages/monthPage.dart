import 'package:business_manager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPage extends StatefulWidget {
  @override
  _MonthPageState createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  String uid = AuthService().getUid();

  @override
  Widget build(BuildContext context) {
    Query monthly = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Month')
        .orderBy('timestamp', descending: true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Month'),
        ),
        body: StreamBuilder(
          stream: monthly.snapshots(),
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

            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No transaction is added today.'),
                    Text('Click the below Button to add Transaction'),
                    SizedBox(height: 20.0),
                    Icon(Icons.arrow_downward)
                  ],
                ),
              );
            }
            return ListView.separated(
              itemCount: snapshot.data.docs.length,
              separatorBuilder: (context, index) => Divider(
                height: 0.0,
                thickness: 1.0,
              ),
              itemBuilder: (context, index) {
                var month = snapshot.data.docs[index];
                Timestamp timestamp = month['timestamp'];
                return ExpansionTile(
                  initiallyExpanded: index == 0 ? true : false,
                  title: Text(DateFormat('MMMM yyyy')
                      .format(timestamp.toDate())
                      .toString()),
                  children: [
                    ListTile(
                      title: Text('Sale'),
                      trailing: Text('${month['sales']} ₹'),
                      leading: Icon(Icons.insights),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Expense'),
                      trailing: Text('${month['expense']} ₹'),
                      leading: Icon(Icons.insights),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Balance'),
                      trailing: Text('${month['total']} ₹'),
                      leading: Icon(Icons.insights),
                    ),
                    ListTile(
                      title: Text('Credit'),
                      trailing: Text('${month['credit']} ₹'),
                      leading: Icon(Icons.insights),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
