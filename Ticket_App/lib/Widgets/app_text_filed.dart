import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';


Widget
appTextField(BuildContext context, String text, Widget icon,
    {TextEditingController controller = null,
      bool isPassword = false,
      bool isPhoneFormat = false,
      TextInputType keyBoardType = TextInputType.text,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      elevation: 0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))
        ),
//        child: Row(
//          children: [
        child: Stack(
            children: [ Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                inputFormatters: isPhoneFormat ? [
                  MaskedInputFormater('(###) ###-####')
                ]:[],
                style: TextStyle(fontSize: 12,color: Theme.of(context).primaryColor ),
                keyboardType: keyBoardType,
                controller: controller,
                obscureText: isPassword,
                cursorColor: Theme
                    .of(context)
                    .primaryColor,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: text,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30))
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        child: icon


                    )
                  ],
                ),
              )
            ]
        ),
//          ],
//        ),
      ),
    ),
  );
}