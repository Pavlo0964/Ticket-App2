
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/Helper.dart';
import 'package:tickets_app/Model/Arguments.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';
import 'package:tickets_app/Widgets/app_button.dart';
import 'package:tickets_app/Widgets/app_text_filed.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:tickets_app/firebase/FirestoreDB.dart';
class AddNewTicketScreen extends StatefulWidget {
  final UpdateTicketsArguments args;
  AddNewTicketScreen(this.args);
  static final String routeName = '/AddNewTicketScreen';

  @override
  _AddNewTicketScreenState createState() => _AddNewTicketScreenState();
}

class _AddNewTicketScreenState extends State<AddNewTicketScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  final picker = ImagePicker();

  ProgressDialog progressDialog;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppStrings.kGoogleApiKey);
  Mode _mode = Mode.overlay;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  var imageUrl = "";
  var newTicket = TicketModel();
  var customer = CustomerModel();
  var isUpdate = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.customer = widget.args.customer;
    this.newTicket = widget.args.ticket;
    if (!newTicket.id.toString().isEmpty){
      _setData();
    }
  }
  void _setData() {
    isUpdate = true;
    this.titleController.text = newTicket.title;
    this.addressController.text = newTicket.address;
    this.descriptionController.text = newTicket.notes;
    this.imageUrl =  newTicket.imageUrl;

    setState(() {
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        this.imageUrl = "";
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: Text(
            isUpdate ?AppStrings.updateTicket : AppStrings.addTicket,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              this.isUpdate ?
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
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
                              value: newTicket.status,
//                      hint: Text(AppStrings.facing),
                              isExpanded: true,
                              items: ticketStatuses.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value,style: Theme.of(context).textTheme.subtitle2.copyWith(color: Theme.of(context).primaryColor),),
                                );
                              }).toList(),
                              onChanged: (value) {
                                newTicket.status = value;
                                //statusChanged = true;
                                setState(() {

                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ):Container(height: 1,width: 1,),
              appTextField(context, AppStrings.title, Icon(Icons.title_outlined,color: Theme.of(context).primaryColor,),controller: titleController),
              SizedBox(height: 12,),
              InkWell(
                onTap: (){
                    _handlePressButton();
                },
                  child: IgnorePointer(child: appTextField(context, AppStrings.address, Icon(Icons.pin_drop_outlined,color: Theme.of(context).primaryColor,),controller: addressController))
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).primaryColor),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: AppStrings.notes,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30))
                    ),

                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  this.getImage();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
//                      Container(
//                        width: double.infinity,
//                        child: new Text(
//                          'Please attach background check certificate from RCMP',
//                          textAlign: TextAlign.left,
//                          style: new TextStyle(
//                            fontWeight: FontWeight.w400,
//                            fontSize: 15.0,
//                          ),
//                        ),
//                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          //height: 150,
                          width: double.infinity,
                          child: this._image == null && this.imageUrl.isEmpty
                              ? Icon(
                            Icons.add_a_photo,
                            size: 100,
                          )
                              : this.imageUrl.isEmpty ? Image.file(
                            this._image,
                            fit: BoxFit.contain,
                          ):Image.network(imageUrl),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24,),
              Text(isUpdate ? "":AppStrings.initialStatusInfo),
              SizedBox(height: 8,),
              InkWell(
                onTap: (){
                 // _uploadImage();
                  _validateAndSendRequest(context);
                },
                  child: appButton(context,isUpdate ? AppStrings.update: AppStrings.save,))
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _uploadImage() async{
    var result = "";
    if (_image != null) {
      await FirestoreDB.uploadFile(_image, TicketModel()).then((value) {
        result = value;
      });
    }
    return result;
  }
  void _validateAndSendRequest(BuildContext context){

    if (titleController.text.isEmpty || addressController.text.isEmpty || descriptionController.text.isEmpty) {
      showAlertDialog(context, '', AppStrings.FORM_FILL_MESSAGE, false, (){});
      return;
    }
    _sendAddCustomerRequest(context);
  }

  void _sendAddCustomerRequest(BuildContext context) async{
    progressDialog.show();
    var ticket = TicketModel();
    ticket.id = newTicket.id;
    ticket.title = this.titleController.text.toLowerCase();
    ticket.address = this.addressController.text.toLowerCase();
    ticket.notes = this.descriptionController.text.toLowerCase();
    ticket.lat = newTicket.lat;
    ticket.long = newTicket.long;
    ticket.customerName = customer.name;
    ticket.customerId = customer.id;
    ticket.status = isUpdate ? newTicket.status:ticketStatuses[0];

    var imageUrl = await _uploadImage();
    ticket.imageUrl = imageUrl;

    await FirestoreDB.addNewTicket(ticket,isUpdate).then((value) {
      progressDialog.hide();
      if (value > 0){
        if(isUpdate){
          showAlertDialog(context, 'Success', AppStrings.ticketUpdatedSuccessfully, false, (){},closeMainScreen: true);

        }else {
          showAlertDialog(
              context, 'Success', AppStrings.ticketAddedSuccessfully,
              false, () {
               // Navigator.of(context).pop();
          },closeMainScreen: true);
        }
      }else{
        showAlertDialog(context, 'Error', AppStrings.errorOccurredTicket, false, (){});
      }
});

  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: AppStrings.kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "en",

      components: [Component(Component.country, "us")],
    );

    displayPrediction(p);
  }
  void onError(PlacesAutocompleteResponse response) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      var lat = detail.result.geometry.location.lat;
      var long = detail.result.geometry.location.lng;
      var address  =detail.result.formattedAddress;
      newTicket.address = address;
      newTicket.lat = '$lat';
      newTicket.long = '$long';
      setState(() {
        addressController.text = address;
      });
    }
  }
}
