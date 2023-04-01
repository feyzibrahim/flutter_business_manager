import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/classes/customer.dart';
import 'package:business_manager/services/database.dart';
import 'package:business_manager/services/creditDatabase.dart';
import 'package:business_manager/pages/subWidgets/newCustomer/newTranCustomer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTransaction extends StatefulWidget {
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _creditFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String buttonText = 'Choose A Customer';
  bool isCashInAndOut = false;
  bool isLoading = false;
  MyCustomer myCustomer;
  bool isCredit = false;
  String disc;
  int amount;

  @override
  void initState() {
    loadCashInOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add a Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: isCredit
                    ? Form(
                        child: _creditformUi(context),
                        key: _creditFormKey,
                      )
                    : Form(
                        key: _formKey,
                        child: _formUi(),
                      ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 120.0,
                decoration: AdaptiveTheme.of(context).mode.isDark
                    ? CommenService().roundedCornerForDark(Colors.black)
                    : CommenService().roundedCorner(Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Credit'),
                    Switch(
                      value: isCredit,
                      onChanged: (value) {
                        setState(() {
                          isCredit = !isCredit;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formUi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Text('Amount:'),
              SizedBox(width: 20.0),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: AdaptiveTheme.of(context).mode.isDark
                      ? CommenService().roundedCornerForDark(Colors.black)
                      : CommenService().roundedCorner(Colors.white),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => amount = int.parse(text),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter an amount';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Discription',
          ),
          textCapitalization: TextCapitalization.sentences,
          onChanged: (text) => disc = text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Discription cannot be empty';
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: 10.0),
        isLoading
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: SpinKitThreeBounce(
                  color: Colors.blue,
                  size: 25.0,
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: AdaptiveTheme.of(context).mode.isDark
                          ? CommenService().roundedCornerNoShadow(Colors.green)
                          : CommenService().roundedCorner(Colors.green),
                      child: FlatButton.icon(
                        onPressed: () {
                          var form = _formKey.currentState;
                          if (form.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            _addAndUpdateTran(amount, disc, 'sale');
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text(isCashInAndOut ? 'Cash In' : 'Sale'),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: Container(
                      decoration: AdaptiveTheme.of(context).mode.isDark
                          ? CommenService().roundedCornerNoShadow(Colors.red)
                          : CommenService().roundedCorner(Colors.red),
                      child: FlatButton.icon(
                        onPressed: () {
                          var form = _formKey.currentState;
                          if (form.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            _addAndUpdateTran(-amount, disc, 'expense');
                          }
                        },
                        icon: Icon(Icons.remove),
                        label: Text(isCashInAndOut ? 'Cash Out' : 'Expense'),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _creditformUi(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: [
              Text('Amount:'),
              SizedBox(width: 20.0),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: AdaptiveTheme.of(context).mode.isDark
                      ? CommenService().roundedCornerForDark(Colors.black)
                      : CommenService().roundedCorner(Colors.white),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => amount = int.parse(text),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter an amount';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Discription',
          ),
          textCapitalization: TextCapitalization.sentences,
          onChanged: (text) => disc = text,
          validator: (value) {
            if (value.isEmpty) {
              return 'Discription cannot be empty';
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: 5.0),
        FlatButton(
          onPressed: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewTranCustomer(),
              ),
            ) as MyCustomer;
            myCustomer = result;
            if (result != null) {
              setState(() {
                buttonText = result.name;
              });
            }
          },
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$buttonText'),
              Icon(
                Icons.contacts,
              )
            ],
          ),
        ),
        SizedBox(height: 20.0),
        isLoading
            ? SpinKitThreeBounce(
                color: Colors.blue,
                size: 25.0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: AdaptiveTheme.of(context).mode.isDark
                              ? CommenService()
                                  .roundedCornerNoShadow(Colors.red)
                              : CommenService().roundedCorner(Colors.red),
                          child: FlatButton.icon(
                            padding: EdgeInsets.all(15.0),
                            onPressed: () {
                              var form = _creditFormKey.currentState;
                              if (form.validate()) {
                                if (myCustomer != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _addAndUpdateCredit(-amount, disc, true);
                                  _addCreditToTransaction(
                                      amount, disc, 'credit');
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Choose a Customer'),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(Icons.remove),
                            label: Text('Credit'),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: Container(
                          decoration: AdaptiveTheme.of(context).mode.isDark
                              ? CommenService()
                                  .roundedCornerNoShadow(Colors.green)
                              : CommenService().roundedCorner(Colors.green),
                          child: FlatButton.icon(
                            padding: EdgeInsets.all(15.0),
                            onPressed: () {
                              var form = _creditFormKey.currentState;
                              if (form.validate()) {
                                if (myCustomer != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _addAndUpdateCredit(amount, disc, false);
                                  _addCreditWithCustomerId(
                                      amount, disc, 'creditReturn');
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Choose a Customer'),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(Icons.add),
                            label: Text('Credit return'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
      ],
    );
  }

  void loadCashInOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCashInAndOut = prefs.getBool('isCashInOut') ?? false;
    });
  }

  void _addCreditWithCustomerId(int amount, String disc, String type) {
    CreditDatabase(myCustomer: myCustomer)
        .addTransactionToFirestore(amount, disc, type)
        .then((_) {
      DatabaseService().checkTodays(amount, type, true);
      Navigator.pop(context);
    });
  }

  void _addCreditToTransaction(int amount, String disc, String type) {
    CreditDatabase(myCustomer: myCustomer)
        .addTransactionToFirestore(amount, disc, type)
        .then((_) => {
              DatabaseService().checkTodays(amount, type, false),
              Navigator.pop(context),
            });
  }

  void _addAndUpdateCredit(int amount, String disc, bool isCredit) {
    CreditDatabase(myCustomer: myCustomer)
        .addCreditToDatabase(amount, disc, isCredit)
        .then(
          (_) => CreditDatabase(myCustomer: myCustomer)
              .updateTotalCustomerCredit(amount),
        );
  }

  void _addAndUpdateTran(int amount, String disc, String type) {
    DatabaseService().addTransactionToFirestore(amount, disc, type).then((_) {
      DatabaseService().checkTodays(amount, type, true);
      Navigator.pop(context);
    });
  }
}
