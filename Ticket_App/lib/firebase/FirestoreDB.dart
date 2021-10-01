import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tickets_app/Helper/Singelton.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as Storage;
class FirestoreDB {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final customerCollection = 'Customers';
  static final ticketCollection = 'Tickets';

//  // Customer Functions
  static Future<int> getAllCustomers() async {
    try {
      var customers = await _db
          .collection(customerCollection)
          .get();
      if (customers != null) {
        Global.customers.customers = [];
        for (var qSnap in customers.docs) {
       //   print(qSnap.data());
        var cus = CustomerModel.fromJson(qSnap.data());
        Global.customers.customers.add(cus);
        }
        return 1;
      }
    } catch (e) {
  return -1;
  }
    return -1;
  }

  static Future<List<dynamic>> addNewCustomer(CustomerModel customer) async{
    try {
      var cust = await _db
          .collection(customerCollection).where("email", isEqualTo: customer.email)
          .get();
      if(cust.docs.length > 0){
        var customer = CustomerModel.fromJson(cust.docs.first.data());
        return [0,customer];
      }else{
      final cID = _db
          .collection(customerCollection)
          .doc()
          .id;
      var currentCustomer = customer;
      currentCustomer.id = cID;
      await _db
          .collection(customerCollection)
          .doc(cID)
          .set(currentCustomer.toJson());
      return [1,currentCustomer];
      }

    } catch (e) {
      return [-1,CustomerModel()];
    }
  }
  
  static Future<int> getAllTickets() async {
    try {
      var tickets = await _db
          .collection(ticketCollection)
          .get();
      if (tickets != null) {
        Global.tickets.tickets = [];
        for (var qSnap in tickets.docs) {
          var tik = TicketModel.fromJson(qSnap.data());
          Global.tickets.tickets.add(tik);
        }
        return 1;
      }
    } catch (e) {
      return -1;
    }
    return -1;
  }

  static Future<int> getAllTicketsWithFilter(String status,String customerId) async {
    try {
      dynamic tickets;
      if (customerId.isEmpty){
        tickets = await _db
            .collection(ticketCollection).where("status", isEqualTo: status)
            .get();
      }else if (status.isEmpty){
        tickets = await _db
            .collection(ticketCollection).where("customerId", isEqualTo: customerId)
            .get();
      }else {
        tickets = await _db
            .collection(ticketCollection).where("status", isEqualTo: status)
            .where("customerId", isEqualTo: customerId)
            .get();
      }
      if (tickets != null) {
        Global.tickets.tickets = [];
        for (var qSnap in tickets.docs) {
          var tik = TicketModel.fromJson(qSnap.data());
          Global.tickets.tickets.add(tik);
        }
        return 1;
      }
    } catch (e) {
      return -1;
    }
    return -1;
  }

  static Future<CustomerModel> getCustomerWithId(String id) async {
    try {
        var cust = await _db
            .collection(customerCollection).doc(id).get();
      if (cust != null) {
        var customer = CustomerModel.fromJson(cust.data());
        return customer;
      }
    } catch (e) {
      return CustomerModel();
    }
    return CustomerModel();
  }

  static Future<int> updateTicketStatus(TicketModel ticket) async {
    try {
   await _db
          .collection(ticketCollection).doc(ticket.id).update(ticket.toJson());
      return 1;
    } catch (e) {
      return -1;
    }
  }
  static Future<int> addNewTicket(TicketModel ticket,bool isUpdate) async{
    try {
      if (isUpdate) {
        await _db
            .collection(ticketCollection).doc(ticket.id).update(ticket.toJson());
        return 1;
      } else {
        final tID = _db
            .collection(ticketCollection)
            .doc()
            .id;
        var currentTicket = ticket;
        currentTicket.id = tID;
        await _db
            .collection(ticketCollection)
            .doc(tID)
            .set(currentTicket.toJson());
        return 1;
      }
      } catch (e) {
      return -1;
    }

  }



//  Future<String> uploadAnImage(File image,TicketModel ticket) async{
//    await image.writeAsBytes(byteData.buffer.asUint8List(
//        byteData.offsetInBytes, byteData.lengthInBytes));
//
//
//
//  }


  static Future<String> uploadFile(File image,TicketModel ticket) async {
    var result = "";
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('tickets/${ticket.customerName}/${Path.basename(image.path)}}');
    var uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() async {
    await storageReference.getDownloadURL().then((fileURL) {
      if (fileURL == null){
        result = "";
    }else{
    print('File Uploaded');
    result = fileURL;
    }

    });

    });
return result;
  }


}
