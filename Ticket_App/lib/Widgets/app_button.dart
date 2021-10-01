
import 'package:flutter/material.dart';


Widget appButton(BuildContext context,String title){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16),
    width: double.infinity,
    child: Container(
      height:56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color:Theme.of(context).primaryColor,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),
  );
}

