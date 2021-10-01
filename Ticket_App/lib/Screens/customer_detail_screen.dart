import 'package:flutter/material.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/ServiceLocator.dart';
import 'package:tickets_app/Helper/URLServices.dart';
import 'package:tickets_app/Model/Arguments.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Screens/tickets_list.dart';
import 'package:tickets_app/Widgets/app_button.dart';
import 'package:tickets_app/firebase/FirestoreDB.dart';

import 'new_ticket_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final CustomerModel customer;
  CustomerDetailScreen(this.customer);
  static final String routeName = '/CustomerDetailScreen';

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  bool _isLoading = false;
  CustomerModel customer = CustomerModel();

  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  Future<void> _getCustomerData() async {

    await FirestoreDB.getCustomerWithId( widget.customer.id).then((value) async {
      customer = value;
      _isLoading = false;
      if (mounted) setState(() {});
    }).catchError((e) {});
  }


  @override
  void initState() {
    // TODO: implement initState
    this._isLoading = true;
    this._getCustomerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: Text("${widget.customer.name}",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        actions: [

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppStrings.email+":",
                style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey,)),
                SizedBox(width: 24,),
                InkWell(
                  onTap: (){
                    _service.sendEmail(customer.email);
                  },
                  child: Text("${customer.email}",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).primaryColor)),
                )
              ],
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Text(AppStrings.phone+":",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey,)),
                SizedBox(width: 24,),
                InkWell(
                  onTap: (){
                    _service.call(customer.phone);
                  },
                  child: Text("${customer.phone}",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).primaryColor)),
                )
              ],
            ),
            SizedBox(height: 24,),
            InkWell(
              onTap: (){
                var args = CustomerTicketsArguments();
                args.customer = customer;
                args.status = "";
                Navigator.of(context)
                    .pushNamed(TicketsListScreen.routeName,arguments: args);
              },
                child: appButton(context, AppStrings.viewTickets,)
            ),
            SizedBox(height: 24,),
            InkWell(
              onTap: (){
                var args = UpdateTicketsArguments();
                args.customer = widget.customer;
                Navigator.of(context).pushNamed(AddNewTicketScreen.routeName,arguments: args);
              },
                child: appButton(context, AppStrings.addTicket,))

          ],
        ),
      ),
    );
  }
}
