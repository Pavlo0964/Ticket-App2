import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/Helper.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';
import 'package:tickets_app/Widgets/app_button.dart';
import 'package:tickets_app/firebase/FirestoreDB.dart';


class TicketDetailScreen extends StatefulWidget {
  final TicketModel ticket;
  TicketDetailScreen(this.ticket);
  static final String routeName = '/TicketDetailScreen';
  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  var statusText = "";
  bool statusChanged = false;
  ProgressDialog progressDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statusText = "${widget.ticket.status}";
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Please wait...',
      progressWidget: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: Text('${widget.ticket.title}',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        actions: [
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(AppStrings.title+":",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey,)),
                SizedBox(width: 24,),
                Text('${widget.ticket.title}',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).primaryColor))
              ],
            ),
            SizedBox(height: 24,),
            Row(
              children: [
                Text(AppStrings.status+":",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey,)),
                SizedBox(width: 16,),
                Expanded(
                  flex:1,
                  child: Row(
                    children: [
                      
                      Expanded(
                        flex: 1,
                        child: new DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          value: statusText,
//                      hint: Text(AppStrings.facing),
                          isExpanded: true,
                          items: ticketStatuses.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value,style: Theme.of(context).textTheme.subtitle2.copyWith(color: Theme.of(context).primaryColor),),
                            );
                          }).toList(),
                          onChanged: (value) {
                            statusText = value;
                            statusChanged = true;
                            setState(() {

                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:24.0),
                        child:  InkWell(
                            onTap: (){
                              _sendUpdateStatus(context,statusText);
                            },
                            child: Container(

                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: statusChanged ? Theme.of(context).primaryColor : Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(23))
                              ),
                              child: Center(
                                child:Text(AppStrings.update,
                                    style: Theme.of(context).textTheme.subtitle2),
                              ),
                            ),
                          ),
                      )
                    ],
                  ),
                ),

              ],
            ),
            SizedBox(height: 24,),

            Text(AppStrings.address+":",
                style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey,)),
            SizedBox(height: 8,),
            Text('${widget.ticket.address}'.capitalizeFirstofEach,
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).primaryColor)),
            SizedBox(height: 24,),

                Text(AppStrings.notes+":",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey,)),
                SizedBox(height: 8,),
                Text('${widget.ticket.notes}',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }

  void _sendUpdateStatus(BuildContext context,String status) async{
    progressDialog.show();
   var currentTicket = widget.ticket;
   currentTicket.status = status;
    await FirestoreDB.updateTicketStatus(currentTicket).then((value) {
      progressDialog.hide();
      if (value > 0){
        showAlertDialog(context, 'Success', AppStrings.ticketUpdatedSuccessfully, false, (){});

      }else{
        showAlertDialog(context, 'Error', AppStrings.errorOccurredTicketUpdate, false, (){});
      }


    });

  }

}
