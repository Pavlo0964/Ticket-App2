
import 'package:flutter/material.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/Helper.dart';
import 'package:tickets_app/Screens/customer_screen.dart';
import 'package:tickets_app/Screens/map_screen.dart';
import 'package:tickets_app/Screens/new_customer_screen.dart';
import 'package:tickets_app/Widgets/home_card_widget.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: Text(AppStrings.home,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:16.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context)
                    .pushNamed(AddNewCustomerScreen.routeName);
              },
              child: Icon(
                Icons.add_circle_outline,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(
              children: [
                homeCardButton(context, AppStrings.customers, Theme.of(context).primaryColor, (){
                  Navigator.of(context)
                      .pushNamed(CustomerScreen.routeName,arguments: ScreenType.Customer);
                }),
                homeCardButton(context, AppStrings.bids, Theme.of(context).primaryColor, (){
                  Navigator.of(context)
                      .pushNamed(CustomerScreen.routeName,arguments: ScreenType.Bids);
                }),
              ],
            ),
          Row(
            children: [
              homeCardButton(context, AppStrings.jobs, Theme.of(context).primaryColor, (){
                Navigator.of(context)
                    .pushNamed(CustomerScreen.routeName,arguments: ScreenType.Job);
              }),
              homeCardButton(context, AppStrings.map, Theme.of(context).primaryColor, (){
                Navigator.of(context)
                    .pushNamed(MapScreen.routeName);
              }),
            ],
          )
        ],
      ),
    );
  }
}
