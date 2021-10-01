
import 'package:tickets_app/Helper/Singelton.dart';

class CustomerModel{
  var id;
  var name;
  var email;
  var phone;
  var company;

  CustomerModel(){
    id = "";
    name = "";
    email = "";
    phone = "";
    company = "";

  }
  CustomerModel.fromJson(Map<String,dynamic> json){
    id = json["id"] ?? "";
    name = json["name"] ?? "";
    email = json["email"] ?? "";
    phone = json["phone"] ?? "";
    company = json["company"] ?? "";

  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'company': company,
  };
}


class CustomerListModel{
  List<CustomerModel> customers;


  CustomerListModel(){
    customers = [];
  }
  CustomerListModel.fromJson(var json){
    for (var each in json){
      this.customers.add(CustomerModel.fromJson(each));
    }
  }

  void searchCustomer(String text){

    var result = List<CustomerModel>();

    for (var each in Global.customers.customers){
      if (each.name.toString().toLowerCase().contains(text) ||
          each.company.toString().toLowerCase().contains(text) ||
          each.email.toString().toLowerCase().contains(text) ||
          each.phone.toString().toLowerCase().contains(text)){
        result.add(each);
      }
    }
    customers = result;
    //return result;
  }

}