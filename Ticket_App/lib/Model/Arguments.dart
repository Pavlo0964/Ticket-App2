
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Model/Tickets/TicketModel.dart';

class CustomerTicketsArguments{

  String status;
  CustomerModel customer;

}

class UpdateTicketsArguments{

  TicketModel ticket = TicketModel();
  CustomerModel customer = CustomerModel();

}