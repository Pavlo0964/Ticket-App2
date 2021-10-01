


import 'package:flutter/material.dart';


Widget homeCardButton(BuildContext context,String title,Color bgColor,Function onTap){
  return Expanded(
    child: InkWell(
      onTap: (){
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          height: MediaQuery.of(context).size.width/2 - 32,
          child: Card(
            color: bgColor,
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}