import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/Helper.dart';
import 'package:tickets_app/Helper/MapUtils.dart';
import 'package:tickets_app/Helper/Singelton.dart';
import 'package:tickets_app/Model/Arguments.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';
import 'package:tickets_app/firebase/FirestoreDB.dart';

import 'new_ticket_screen.dart';

class MapScreen extends StatefulWidget {
  static final String routeName = '/MapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  Set<Marker> _markers = {};
   LatLng _center = Global.currentLocation;
  int _markerIdCounter = 1;
  MarkerId selectedMarker;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor myLocationIcon;
  LatLng tappedMarker;
  bool allowMarker = false;
  var statusText = ticketStatuses[2];

  TicketListModel currentTickets = TicketListModel();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _loadTickets() async {
      await FirestoreDB.getAllTicketsWithFilter(statusText, "").then((value) async {
        _markers.clear();
        for (var each in Global.tickets.tickets){
          _markers.add(
              Marker(
                markerId: MarkerId('${each.id}'),
                position: LatLng(double.tryParse(each.lat)??0.0, double.tryParse(each.long)??0.0),
                icon: pinLocationIcon,
                onTap: (){
                  tappedMarker = LatLng(double.tryParse(each.lat)??0.0, double.tryParse(each.long)??0.0);
                  isButtonAllow();
                },
                infoWindow: InfoWindow(title: '${each.customerName}',snippet: '${each.title}',onTap: (){

                  var args = UpdateTicketsArguments();
                  var cust = CustomerModel();
                  cust.name = each.customerName;
                  cust.id = each.id;
                  args.customer = cust;
                  args.ticket = each;
                  Navigator.of(context).pushNamed(AddNewTicketScreen.routeName,arguments:args).then((_) {
                    _loadTickets();
                  });
                }),
              )
          );
        }
        _markers.add(Marker(
          markerId: MarkerId('currentUser'),
          position: LatLng(_center.latitude,_center.longitude),
          //icon: pinLocationIcon,
          infoWindow: InfoWindow(title: 'Your Location',onTap: (){
          }),
        ));

        if (mounted) {setState(() {});}
      }).catchError((e) {});
  }
  @override
  void initState() {
    // TODO: implement initState
    this._loadTickets();
    this.allowMarker = false;
    super.initState();
    _setPinType();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    var cloc = await locateUser();
    _center = LatLng(cloc.latitude, cloc.longitude);
    setState(() {

    });
  }

  void _setPinType(){
    var imageName = "images/";
    if (statusText == ticketStatuses[0]) {
     imageName += "initialCallPin.bmp";
    }else if (statusText == ticketStatuses[1]) {
      imageName += "bidPin.bmp";
    }else if (statusText == ticketStatuses[2]) {
      imageName += "jobPin.bmp";
    }else if (statusText == ticketStatuses[3]) {
      imageName += "completedPin.bmp";
    }
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(50, 50)),
        imageName).then((onValue) {
      pinLocationIcon = onValue;
    });

//    BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(devicePixelRatio: 2.5, size: Size(50, 50)),
//        "images/").then((onValue) {
//      pinLocationIcon = onValue;
//    });
  }

  void isButtonAllow(){
    print("object");
  if (this.tappedMarker != null){
   if (Platform.isIOS){
     setState(() {
       this.allowMarker = true;
     });
   }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left:0.0),
          child: Text(AppStrings.map,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),

      ),
      body: Column(
        children:[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                child: new DropdownButton<String>(
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
                    _setPinType();
                    _loadTickets();
                    setState(() {
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Stack(
              children: [
                GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 3.7,
              ),
              markers: _markers,
        ),
                Positioned(
                    bottom: 20,
                    right: 80,
                    child:

                InkWell(
                  onTap: (){
                    MapUtils.openMap(this.tappedMarker.latitude, this.tappedMarker.longitude);
                  },
                  child: Container(
                    height:  this.allowMarker ? 40 : 0,
                    width: 40,
                    color: Colors.white,
                    child: Icon(
                      Icons.directions,
                      size: this.allowMarker ? 30 : 0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
                )

            ]
            ),
          ),
      ]
      ),
    );
  }
}
