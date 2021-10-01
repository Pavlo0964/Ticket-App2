
import 'package:tickets_app/Model/Customers/CustomerModel.dart';

class TicketModel{
  var id;
  var title;
  var address;
  var lat;
  var long;
  var notes;
  var customerId;
  var customerName;
  var status;
  var imageUrl;
  CustomerModel customerObj = CustomerModel();
  TicketModel(){
    id = "";
    title = "";
    address = "";
    lat = "";
    long = "";
    notes = "";
    customerId = "";
    customerName = "";
    status = "";
    imageUrl = "";
    customerObj = CustomerModel();
  }
  TicketModel.fromJson(Map<String,dynamic> json){
    this.id = json["id"] ?? "";
    this.title = json["title"] ?? "";
    this.address = json["address"] ?? "";
    this.lat = json["lat"] ?? "";
    this.long = json["long"] ?? "";
    this.notes = json["notes"] ?? "";
    this.customerId = json["customerId"] ?? "";
    this.customerName = json["customerName"] ?? "";
    this.status = json["status"] ?? "";
    this.imageUrl = json["imageUrl"] ?? "";
    customerObj.id = customerId;
    customerObj.name = customerName;

  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'address': address,
    'lat': lat,
    'long': long,
    'notes': notes,
    'customerId': customerId,
    'customerName': customerName,
    'status': status,
    'imageUrl': imageUrl,
  };
}


class TicketListModel{
  List<TicketModel> tickets;


  TicketListModel(){
    tickets = [];
  }
  TicketListModel.fromJson(var json){
    for (var each in json){
      this.tickets.add(TicketModel.fromJson(each));
    }
  }
}