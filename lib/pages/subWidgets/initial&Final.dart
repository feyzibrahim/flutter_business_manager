import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/classes/transactionsPerDay.dart';

class InitailFinal extends StatelessWidget {
  final Transactions transactions;

  InitailFinal({this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: AdaptiveTheme.of(context).mode.isDark
          ? CommenService().roundedCornerForDark(Colors.black)
          : CommenService().roundedCorner(Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date: ${transactions.date}"),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Initial Balance'),
              Text('Final Balance'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '${transactions.initialBalance} ₹',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${transactions.finalBalance} ₹',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
