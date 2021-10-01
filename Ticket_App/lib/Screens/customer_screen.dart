import 'package:flutter/material.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/Helper.dart';
import 'package:tickets_app/Helper/Singelton.dart';
import 'package:tickets_app/Model/Arguments.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';
import 'package:tickets_app/Screens/customer_detail_screen.dart';
import 'package:tickets_app/Screens/tickets_list.dart';
import 'package:tickets_app/Widgets/ActivityIndicator.dart';
import 'package:tickets_app/Widgets/app_button.dart';
import 'package:tickets_app/firebase/FirestoreDB.dart';

import 'new_customer_screen.dart';

class CustomerScreen extends StatefulWidget {
  static final String routeName = '/CustomerScreen';
  final ScreenType screenType;
  CustomerScreen(this.screenType);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  var statusText = "";

  CustomerListModel customerList = CustomerListModel();
  bool _isLoading = false;
  bool _isCustomerData = false;
  bool isSearchEnable = false;
  Future<void> _loadCustomers() async {

    if ( widget.screenType == ScreenType.Customer){
      _isCustomerData = true;
    }else{
      _isCustomerData = false;
    }
    if (_isCustomerData) {
      await FirestoreDB.getAllCustomers().then((value) async {
        _isLoading = false;
        this.customerList.customers.clear();
        this.customerList.customers.addAll(Global.customers.customers);
        if (mounted) setState(() {});
      }).catchError((e) {});
    }else{
      await FirestoreDB.getAllTicketsWithFilter(statusText, "").then((value) async {
        _isLoading = false;
        if (mounted) setState(() {});
      }).catchError((e) {});
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    Global.customers.customers.clear();
    this._isLoading = true;
    isSearchEnable = this.widget.screenType.index == 0;
    statusText = ticketStatuses[this.widget.screenType.index];
    this._loadCustomers();
    super.initState();

  }
  Widget _customerCell(BuildContext context,CustomerModel customer){
    return InkWell(
      onTap: (){
        Navigator.of(context)
            .pushNamed(CustomerDetailScreen.routeName,arguments: customer).then((_) {
          this._loadCustomers();

        });
      },
      child: Container(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${customer.name}',style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).primaryColor),),
                    Text('${customer.company}',style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey,fontSize: 12),),
                  ],
                ),
              InkWell(
                onTap: (){
                  var args = CustomerTicketsArguments();
                  args.customer = customer;
                  args.status = "";
                  Navigator.of(context)
                      .pushNamed(TicketsListScreen.routeName,arguments: args);
                },
                child: Container(
                  width: 120,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(23))
                  ),
                  child: Center(
                    child:Text(AppStrings.viewTickets,
                      style: Theme.of(context).textTheme.subtitle2),
                  ),
                ),
              )
              ],
            ),
          ),
        ),

      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: Text("${screenTitles[widget.screenType.index]}",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:16.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context)
                    .pushNamed(AddNewCustomerScreen.routeName).then((_) {
                  _loadCustomers();
                });
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children:[
        Expanded(
        flex:isSearchEnable ?4:1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width:isSearchEnable ? double.infinity: 150,
            child:    isSearchEnable
              ?TextField(
              onChanged: (value){
                //this.customerList.customers.clear();
              this.customerList.searchCustomer(value);
              setState(() {

              });
              },
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              decoration: InputDecoration(
                  hintText: "Search Customer",
              ),
            ):
            new DropdownButton<String>(
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              value: statusText ,
              isExpanded: true,
              items: ticketStatuses.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value,style: Theme.of(context).textTheme.subtitle2.copyWith(color: Theme.of(context).primaryColor),),
                );
              }).toList(),
              onChanged: (value) {
                statusText = value;
                this._isLoading = true;
                _loadCustomers();
                setState(() {
                });
              },
            ),
          ),
        ),
      ),
         this._isLoading
             ? Expanded(flex:9,child: ActivityIndicator())
             :  Expanded(
            flex: isSearchEnable ?20:9,
            child: ListView.builder(
        itemCount: _isCustomerData ?
        isSearchEnable
            ?this.customerList.customers.length
            :Global.customers.customers.length :Global.tickets.tickets
            .length ,
        itemBuilder: (BuildContext context,int index){
            return _customerCell(context,_isCustomerData
                ?isSearchEnable
                ?this.customerList.customers[index]
                : Global.customers.customers[index]
                :Global.tickets.tickets[index].customerObj);
        },
        ),
          ),
      ]
      ),
    );
  }
}
