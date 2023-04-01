import 'package:business_manager/classes/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommenService {
  BoxDecoration roundedCorner(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  BoxDecoration roundedCornerForDark(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 2,
          blurRadius: 3,
          offset: Offset(0, 0),
        ),
      ],
    );
  }

  BoxDecoration roundedCornerNoShadow(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      color: color,
    );
  }

  Widget loading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String getDate() {
    var date = DateTime.now();
    String newTime = DateFormat('dd/MM/yyyy').format(date).toString();
    return newTime;
  }

  String getSDate() {
    var date = DateTime.now();
    String newTime = DateFormat('yyyy-MM-dd').format(date).toString();
    return newTime;
  }

  String formatedDate(date) {
    String newTime = DateFormat('dd-MM-yyyy').format(date).toString();
    return newTime;
  }

  void showSnack(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Text formatedTime(var time) {
    var timeNew = DateFormat('hh:mm a').format(time);
    return Text('$timeNew');
  }

  String formatedTimeAndDate(var time) {
    var timeNew = DateFormat('hh:mm a · dd/MM/yyyy').format(time);
    return timeNew;
  }

  Color chooseTypeColor(MyTransaction transaction) {
    if (transaction.type == 'sale' || transaction.type == 'creditReturn') {
      return Colors.green;
    } else if (transaction.type == 'expense') {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}
