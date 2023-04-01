import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_manager/pages/subWidgets/newCustomer/newCustomer.dart';
import 'package:business_manager/services/commen.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/pages/creditPage.dart';
import 'package:business_manager/classes/customer.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  String uid = AuthService().getUid();
  String searchResult = '';

  @override
  Widget build(BuildContext context) {
    var customers = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Customer');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        child: const Icon(Icons.person_add_alt),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => NewCustomer(),
            isScrollControlled: true,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: AdaptiveTheme.of(context).mode.isDark
                    ? CommenService().roundedCornerNoShadow(Colors.grey[900])
                    : CommenService().roundedCorner(Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    border: InputBorder.none,
                    hintText: 'Search',
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchResult = value;
                    });
                  },
                ),
              ),
            ),
            StreamBuilder(
              stream: customers.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 70.0),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {
                  if (snapshot.data.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text('Click the add button to create customer'),
                      ),
                    );
                  }
                }
                if (searchResult.isEmpty) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, _) => Divider(height: 0.0),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var customer = snapshot.data.docs[index];
                      MyCustomer myCustomer = MyCustomer(
                        creditAmount: customer['creditAmount'],
                        id: customer['id'],
                        name: customer['name'],
                        phoneNum: customer['phoneNum'],
                        time: customer['time'],
                      );
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          myCustomer.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(myCustomer.phoneNum),
                        trailing: Text(
                          '${myCustomer.creditAmount} ₹',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreditPage(
                                myCustomer: myCustomer,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, _) => Divider(height: 0.0),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var customer = snapshot.data.docs[index];
                      MyCustomer myCustomer = MyCustomer(
                        creditAmount: customer['creditAmount'],
                        id: customer['id'],
                        name: customer['name'],
                        phoneNum: customer['phoneNum'],
                        time: customer['time'],
                      );
                      if (myCustomer.name
                          .toLowerCase()
                          .contains(searchResult.toLowerCase())) {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 0.0,
                          ),
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            myCustomer.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(myCustomer.phoneNum),
                          trailing: Text(
                            '${myCustomer.creditAmount} ₹',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreditPage(
                                  myCustomer: myCustomer,
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
