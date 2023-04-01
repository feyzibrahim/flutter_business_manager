import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/classes/transactionsPerDay.dart';
import 'package:business_manager/pages/transactionPage.dart';

class EachDays extends StatefulWidget {
  final Transactions transactions;

  EachDays({
    this.transactions,
  });

  @override
  _EachDaysState createState() => _EachDaysState();
}

class _EachDaysState extends State<EachDays> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: Container(
        decoration: AdaptiveTheme.of(context).mode.isDark
            ? CommenService().roundedCornerForDark(_bgColor())
            : CommenService().roundedCorner(_bgColor()),
        height: 90.0,
        child: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => TransactionPage(
                  transactions: widget.transactions,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Starting Balance : ${widget.transactions.initialBalance} ₹'),
                    Text(
                        'Final Balance       : ${widget.transactions.finalBalance} ₹'),
                  ],
                ),
                Text(
                  removeLastChar(widget.transactions.date),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String removeLastChar(String s) {
    if (s == null || s.length == 0) {
      return s;
    }
    return s.substring(0, s.length - 5);
  }

  Color _bgColor() {
    if (widget.transactions.date == '${CommenService().getDate()}') {
      return Colors.green;
    } else {
      if (AdaptiveTheme.of(context).mode.isDark) {
        return Colors.black;
      } else {
        return Colors.white;
      }
    }
  }
}
