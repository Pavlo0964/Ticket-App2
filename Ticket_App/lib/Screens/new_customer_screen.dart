import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:tickets_app/Helper/Constants.dart';
import 'package:tickets_app/Helper/Helper.dart';
import 'package:tickets_app/Model/Customers/CustomerModel.dart';
import 'package:tickets_app/Widgets/app_button.dart';
import 'package:tickets_app/Widgets/app_text_filed.dart';
import 'package:tickets_app/firebase/FirestoreDB.dart';

import 'customer_detail_screen.dart';



class AddNewCustomerScreen extends StatefulWidget {
  static final String routeName = '/AddNewCustomerScreen';
  @override
  _AddNewCustomerScreenState createState() => _AddNewCustomerScreenState();
}

class _AddNewCustomerScreenState extends State<AddNewCustomerScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  ProgressDialog progressDialog;

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
            AppStrings.addCustomer,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              appTextField(context, AppStrings.name, Icon(Icons.person_outline,color: Theme.of(context).primaryColor,),controller: nameController),
              SizedBox(height: 16,),
              appTextField(context, AppStrings.phone, Icon(Icons.phone_outlined,color: Theme.of(context).primaryColor,),keyBoardType: TextInputType.phone,controller: phoneController,isPhoneFormat: true),
              SizedBox(height: 16,),
              appTextField(context, AppStrings.email, Icon(Icons.email_outlined,color: Theme.of(context).primaryColor,),controller: emailController),
              SizedBox(height: 16,),
              appTextField(context, AppStrings.comapny, Icon(Icons.work,color: Theme.of(context).primaryColor,),controller: companyController),
              SizedBox(height: 40,),
              InkWell(
                onTap: (){
                  _validateAndSendRequest(context);
                },
                  child: appButton(context, AppStrings.save,)
              )
            ],
          ),
        ),
      ),
    );
  }
  void _validateAndSendRequest(BuildContext context){
    if (emailController.text.isEmpty || nameController.text.isEmpty || phoneController.text.isEmpty) {
      showAlertDialog(context, '', AppStrings.FORM_FILL_MESSAGE, false, () {});
      return;
    }
    if (!isValidEmail(emailController.text)){
      showAlertDialog(context, '', AppStrings.INVALID_EMAIL_MESSAGE, false, () {});
      return;
    }
    _sendAddCustomerRequest(context);
  }

  void _sendAddCustomerRequest(BuildContext context) async{
        progressDialog.show();
        Map<String, String> parameters = Map();
        var customer = CustomerModel();
        customer.name = this.nameController.text;
        customer.email = this.emailController.text.toLowerCase();
        customer.phone = this.phoneController.text;
        customer.company = this.companyController.text;

        await FirestoreDB.addNewCustomer(customer).then((value) {
          progressDialog.hide();

          if (value.first >= 0 ){
            if (value.first == 0){
              showAlertDialog(
                  context, 'Validation', AppStrings.customerAlreadyExist,
                  true, () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(CustomerDetailScreen.routeName,arguments: value[1]);
              },isShowProfile: true);
            }else {
              showAlertDialog(
                  context, 'Success', AppStrings.customerAddedSuccessfully,
                  false, () {},closeMainScreen: true);
            }

          }else{
            showAlertDialog(context, 'Error', AppStrings.errorOccurredCustomer, false, (){});

          }


        });

  }


}
