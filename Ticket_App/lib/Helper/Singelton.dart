
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';

class Global{
  static CustomerListModel customers = CustomerListModel();
  static TicketListModel tickets = TicketListModel();
  static LatLng currentLocation;
  //static LatLng currentLocation  = LatLng(40.7128, 74.0060);


}