import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_manager/services/auth.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/services/creditDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:business_manager/classes/credit.dart';
import 'package:business_manager/classes/customer.dart';
import 'package:business_manager/services/database.dart';

class CreditPage extends StatefulWidget {
  final MyCustomer myCustomer;
  CreditPage({
    this.myCustomer,
  });

  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  String uid = AuthService().getUid();
  var date = DateTime.now();
  int sum = 0;

  showWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to delete the Contact?'),
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
                    .deleteTransaction(widget.myCustomer.id, 'Customer')
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

  @override
  Widget build(BuildContext context) {
    var format = CommenService().formatedDate(date);
    String cid = widget.myCustomer.id;
    var creditRef = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Customer')
        .doc(cid)
        .collection('Credit')
        .orderBy('time');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.myCustomer.name),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              showWarning(context);
            },
            itemBuilder: (BuildContext context) {
              return {'Delete Contact'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: creditRef.snapshots(),
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
                            Text('No Credit is added'),
                            Text('Goto main menu to add Credit'),
                          ],
                        ),
                      );
                    }
                  }

                  return GroupedListView(
                    elements: snapshot.data.docs,
                    separator: Divider(
                      height: 1,
                    ),
                    groupBy: (element) {
                      Timestamp time = element['time'];
                      var timeIn = time.toDate();
                      return CommenService().formatedDate(timeIn);
                    },
                    order: GroupedListOrder.DESC,
                    reverse: true,
                    groupSeparatorBuilder: (String value) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: AdaptiveTheme.of(context).mode.isDark
                                ? CommenService()
                                    .roundedCornerNoShadow(Colors.grey[900])
                                : CommenService().roundedCorner(Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              child:
                                  format == value ? Text('Today') : Text(value),
                            ),
                          ),
                        ),
                      );
                    },
                    indexedItemBuilder: (context, credits, index) {
                      Credit credit = Credit(
                        amount: credits['amount'],
                        discription: credits['discription'],
                        id: credits['id'],
                        isCredit: credits['isCredit'],
                        timestamp: credits['time'],
                      );
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        title: Text(credit.discription),
                        subtitle: CommenService()
                            .formatedTime(credit.timestamp.toDate()),
                        trailing: Text(
                          '${credit.amount} ₹',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onLongPress: () => {showSWarning(context, credit)},
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Divider(
                  thickness: 1.5,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: AdaptiveTheme.of(context).mode.isDark
                            ? CommenService().roundedCornerForDark(Colors.black)
                            : CommenService().roundedCorner(Colors.white),
                        child: FlatButton.icon(
                          padding: EdgeInsets.all(12.0),
                          onPressed: () {
                            String number = widget.myCustomer.phoneNum;
                            launch("tel://$number");
                          },
                          icon: Icon(Icons.call),
                          label: Text('Call Now?'),
                        ),
                      ),
                      Text(
                        '${widget.myCustomer.creditAmount}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  showSWarning(BuildContext context, Credit credit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Do you want to delete the Credit?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                CreditDatabase(myCustomer: widget.myCustomer)
                    .deleteCredit(credit.id)
                    .then((value) =>
                        CreditDatabase(myCustomer: widget.myCustomer)
                            .updateTotalCustomerCredit(-credit.amount));
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
