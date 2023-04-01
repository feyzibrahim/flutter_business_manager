import 'package:business_manager/classes/customer.dart';
import 'package:business_manager/classes/user.dart';
import 'package:business_manager/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/services/commen.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid = AuthService().getUid();

  //Transaction

  Future addTransactionToFirestore(int amount, String disc, String type) async {
    final CollectionReference mytransactionCollection = FirebaseFirestore
        .instance
        .collection('User')
        .doc(uid)
        .collection('Trans');
    final docUid = mytransactionCollection.doc().id;
    return await mytransactionCollection.doc(docUid).set(
      {
        'amount': amount,
        'discription': disc,
        'id': docUid,
        'time': Timestamp.now(),
        'type': type,
        'date': CommenService().getDate(),
        'customerId': null,
      },
    );
  }

  void updateFinalBal(String id, int amount) {
    FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Transaction')
        .doc(id)
        .update({
      'finalBal': amount,
    });
  }

  //Monthly

  void checkMonths(int finalBal, int amount, String type) {
    Future<QuerySnapshot> doc = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Month')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    doc.then((value) {
      if (value.docs.length > 0) {
        Timestamp timestamp = value.docs[0].data()['timestamp'];
        int sales = value.docs[0].data()['sales'];
        int expense = value.docs[0].data()['expense'];
        int credit = value.docs[0].data()['credit'];
        var thisMonth = DateFormat('yyyy-MM').format(DateTime.now()).toString();
        var date = DateFormat('yyyy-MM').format(timestamp.toDate()).toString();
        if (date == thisMonth) {
          var ref = FirebaseFirestore.instance
              .collection('User')
              .doc(uid)
              .collection('Month')
              .doc(value.docs[0].id);
          if (type == 'sale') {
            sales += amount;
            ref.update({
              'sales': sales,
              'total': finalBal + amount,
            });
          } else if (type == 'expense') {
            expense -= amount;
            ref.update({
              'expense': expense,
              'total': finalBal + amount,
            });
          } else if (type == 'creditReturn') {
            sales += amount;
            credit -= amount;
            ref.update({
              'sales': sales,
              'credit': credit,
              'total': finalBal + amount,
            });
          } else {
            credit += amount;
            ref.update({
              'credit': credit,
            });
          }
        } else {
          addMonthData(finalBal, amount, type);
        }
      } else {
        addMonthData(finalBal, amount, type);
      }
    });
  }

  void addMonthData(int finalBal, int amount, String type) {
    int sales = 0;
    int expense = 0;
    int credit = 0;
    if (type == 'sale') {
      sales += amount;
    } else if (type == 'expense') {
      expense -= amount;
    } else {
      credit = amount;
    }
    FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Month')
        .add({
      'credit': credit,
      'expense': expense,
      'sales': sales,
      'timestamp': Timestamp.now(),
      'total': finalBal + amount,
    });
  }

  //Transactions

  void checkTodays(var amount, String type, bool isToAddinFire) {
    Future<QuerySnapshot> doc = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Transaction')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    doc.then((value) {
      if (value.docs.length > 0) {
        var dateFromFire = value.docs[0].data()['date'];
        var finalBal = value.docs[0].data()['finalBal'];
        var id = value.docs[0].data()['id'];
        var date = CommenService().getDate();
        if (isToAddinFire) {
          if (date != dateFromFire) {
            createTodaysTransactions(finalBal + amount, finalBal);
            checkMonths(finalBal, amount, type);
          } else {
            if (type != 'credit') {
              updateFinalBal(id, finalBal + amount);
            }
            checkMonths(finalBal, amount, type);
          }
        } else {
          checkMonths(finalBal, amount, type);
        }
      } else {
        createTodaysTransactions(amount, amount);
        checkMonths(0, amount, type);
      }
    });
  }

  Future createTodaysTransactions(var finalBal, var initial) async {
    final transactionCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Transaction');
    final docId = transactionCollection.doc().id;
    final timestamp = Timestamp.now();
    return await transactionCollection.doc(docId).set({
      'initialBal': initial,
      'finalBal': finalBal,
      'date': CommenService().getDate(),
      'id': docId,
      'timestamp': timestamp,
    });
  }

  //Customer

  Future createCustomer(String name, var number) async {
    final CollectionReference customerCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Customer');
    final id = customerCollection.doc().id;
    final timestamp = Timestamp.now();

    return await customerCollection.doc(id).set({
      'creditAmount': 0,
      'id': id,
      'name': name,
      'phoneNum': number,
      'time': timestamp,
    });
  }

  //User Registration

  Future createUserinFireStore(Users users) async {
    final userCollection =
        FirebaseFirestore.instance.collection('User').doc(users.uid);
    return await userCollection.set({
      'uid': users.uid,
      'email': users.email,
      'name': users.name,
    });
  }

  // Deleting Data

  Future deleteTransaction(String id, String colName) async {
    final transactionsCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection(colName);
    return await transactionsCollection.doc(id).delete();
  }

  //updating profile Details

  Future updateProfileDetails(
      String phoneNumber, String loc, String about) async {
    final userCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(AuthService().getUid());
    return await userCollection.update({
      'phone': phoneNumber,
      'location': loc,
      'about': about,
    });
  }

  Future getCustomerData() async {
    List result = [];
    var data = await FirebaseFirestore.instance
        .collection('User')
        .doc(AuthService().getUid())
        .collection('Customer')
        .get();
    for (var customer in data.docs) {
      var subCust = MyCustomer.fromSnapshot(customer);
      result.add(subCust);
    }
    return result;
  }
}
