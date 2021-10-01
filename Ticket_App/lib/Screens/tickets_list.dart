import 'package:flutter/material.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/Singelton.dart';
import 'package:tickets_app/Model/Arguments.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';
import 'package:tickets_app/Screens/new_ticket_screen.dart';
import 'package:tickets_app/Screens/ticket_detail_screen.dart';
import 'package:tickets_app/Widgets/ActivityIndicator.dart';
import 'package:tickets_app/firebase/FirestoreDB.dart';

class TicketsListScreen extends StatefulWidget {
  final CustomerTicketsArguments args;
  TicketsListScreen(this.args);
  static final String routeName = '/TicketsListScreen';
  @override
  _TicketsListScreenState createState() => _TicketsListScreenState();
}

class _TicketsListScreenState extends State<TicketsListScreen> {

  bool _isLoading = false;



  Future<void> _loadTickets() async {

    await FirestoreDB.getAllTicketsWithFilter(widget.args.status, widget.args.customer.id).then((value) async {
      _isLoading = false;
      if (mounted) setState(() {});
    }).catchError((e) {});
  }


  @override
  void initState() {
    // TODO: implement initState
    this._isLoading = true;
    this._loadTickets();
    super.initState();
  }

  Widget _ticketCell(BuildContext context,TicketModel ticket){
    return InkWell(
      onTap: (){
        var args = UpdateTicketsArguments();
        args.customer = widget.args
            .customer;
        args.ticket = ticket;
        Navigator.of(context).pushNamed(AddNewTicketScreen.routeName,arguments:args).then((_) {
          _loadTickets();
        });
        //        Navigator.of(context).pushNamed(TicketDetailScreen.routeName,arguments: ticket);
      },
      child: Container(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${ticket.title}',style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).primaryColor),),
                    Text('${ticket.status}',style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).primaryColor,fontSize: 15),),
                  ],
                ),
                SizedBox(height: 8,),
                Container(
                  width: MediaQuery.of(context).size.width - 16,
                  child: Text('${ticket.notes}'
                    ,style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).primaryColor),
                    maxLines: 1,
                  ),
                ),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: Text(AppStrings.tickets,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:16.0),
            child: InkWell(
              onTap: (){
                var args = UpdateTicketsArguments();
                args.customer = widget.args
                    .customer;
                Navigator.of(context).pushNamed(AddNewTicketScreen.routeName,arguments:args).then((_) {
                  _loadTickets();
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
      body: this._isLoading
          ?  ActivityIndicator()
          :ListView.builder(
        itemCount: Global.tickets.tickets.length,
        itemBuilder: (BuildContext context,int index){
          return _ticketCell(context,Global.tickets.tickets[index]);
        },
      ),
    );
  }
}
