import 'package:flutter/material.dart';
import 'package:business_manager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/classes/customer.dart';
import 'package:business_manager/pages/subWidgets/newCustomer/newCustomer.dart';

class NewTranCustomer extends StatefulWidget {
  @override
  _NewTranCustomerState createState() => _NewTranCustomerState();
}

class _NewTranCustomerState extends State<NewTranCustomer> {
  String uid = AuthService().getUid();

  @override
  Widget build(BuildContext context) {
    CollectionReference _customerCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Customer');
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Customer'),
      ),
      body: StreamBuilder(
        stream: _customerCollection.snapshots(),
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
          return ListView.separated(
            itemCount: snapshot.data.docs.length,
            separatorBuilder: (context, index) => Divider(height: 1.0),
            itemBuilder: (context, index) {
              var customers = snapshot.data.docs[index];
              MyCustomer myCustomer = MyCustomer(
                creditAmount: customers['creditAmount'],
                id: customers['id'],
                name: customers['name'],
                phoneNum: customers['phoneNum'],
                time: customers['time'],
              );
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5.0,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myCustomer.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      myCustomer.phoneNum,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  '${myCustomer.creditAmount} ₹',
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context, myCustomer);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => NewCustomer(),
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.person_add_alt),
      ),
    );
  }
}
