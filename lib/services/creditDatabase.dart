import 'package:business_manager/classes/customer.dart';
import 'package:business_manager/services/commen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_manager/services/auth.dart';

class CreditDatabase {
  final MyCustomer myCustomer;
  CreditDatabase({
    this.myCustomer,
  });

  final String uid = AuthService().getUid();

  Future addCreditToDatabase(int amount, String disc, bool isCredit) async {
    final CollectionReference myCreditCollection = FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Customer')
        .doc(myCustomer.id)
        .collection('Credit');
    final docUid = myCreditCollection.doc().id;
    final Timestamp timestamp = Timestamp.now();
    return await myCreditCollection.doc(docUid).set({
      'amount': amount,
      'discription': disc,
      'id': docUid,
      'isCredit': isCredit,
      'time': timestamp,
    });
  }

  void updateTotalCustomerCredit(int amount) {
    var id = myCustomer.id;
    int newAmount = myCustomer.creditAmount + amount;
    FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Customer')
        .doc(id)
        .update({
      'creditAmount': newAmount,
    });
  }

  Future addTransactionToFirestore(
    int amount,
    String disc,
    String type,
  ) async {
    final CollectionReference mytransactionCollection = FirebaseFirestore
        .instance
        .collection('User')
        .doc(uid)
        .collection('Trans');
    final docUid = mytransactionCollection.doc().id;
    final Timestamp timestamp = Timestamp.now();
    return await mytransactionCollection.doc(docUid).set(
      {
        'amount': amount,
        'discription': disc,
        'id': docUid,
        'time': timestamp,
        'type': type,
        'date': CommenService().getDate(),
        'customerId': myCustomer.id,
      },
    );
  }

  Future deleteCredit(String id) {
    return FirebaseFirestore.instance
        .collection('User')
        .doc(uid)
        .collection('Customer')
        .doc(myCustomer.id)
        .collection('Credit')
        .doc(id)
        .delete();
  }
}
