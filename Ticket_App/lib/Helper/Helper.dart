
import 'package:flutter/material.dart';
enum ScreenType {Customer,Bids,Job,Map}

final List<String> screenTitles = ["Customers","Bids","Jobs","Map"];

final List<String> ticketStatuses = ["Initial Call","Bid Schedule","Active job","Job Completed"];


String showAlertDialog(BuildContext context, String title, String message,
    bool isInternetDialog, Function onRetryClick,
    {bool closeMainScreen: false,bool isShowProfile: false}) {
  AlertDialog dialog = AlertDialog(
    title: Text(title),
    content: Text(message,style: TextStyle(color: Colors.black),),
    actions: <Widget>[
      FlatButton(
        child: Text('Ok'),
        onPressed: () {
          Navigator.of(context).pop();
          if (closeMainScreen) {
            Navigator.of(context).pop();
          }
        },
      ),
      isInternetDialog
          ? FlatButton(
        child: Text(isShowProfile ? "Go to profile":'Retry'),
        onPressed: onRetryClick,
      )
          : Container(
        width: 0,
        height: 0,
      ),
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.toUpperCase()).join(" ");
}

bool isValidEmail(String email){
  return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}